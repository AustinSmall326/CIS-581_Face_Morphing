% Author:    Austin Small
% Class:     CIS-581
% File Name: morph.m
% Inputs:    im1:           H1 x W1 x 3 matrix representing the first image.
%            im2:           H2 x W2 x 3 matrix representing the second image.
%            im1_pts:       N x 2 matrix representing correspondences in the
%                           first image.
%            im2_pts:       N x 2 matrix representing correspondences in the 
%                           second image.
%            warp_frac:     parameter to control shape warping.
%            dissolve_frac: parameter to control cross-dissolve.
% Outputs:   morphed_im:    H2 x W2 x 3 matrix representing the morphed 
%                           image.

function morphed_im = morph(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
    % Compute average shape between im1_pts and im2_pts.
    imAVG_pts = (im1_pts + im2_pts) / 2;
    
    % Triangulate average point correspondences.
    triangles = delaunay(imAVG_pts);
    
    % Compute intermediate shape.
    imINTERMEDIATE_pts = (1 - warp_frac) * im1_pts + warp_frac * im2_pts;

    %% (1) For each pixel in intermediate shape, determine which triangle it originates from.
    
    % Create a matrix to store coordinates for all points in intermediate image.    
    [I, J] = meshgrid(1 : (size(im1, 2)), ...
                      1 : (size(im1, 1)));
    I = reshape(I, [(size(I, 1) * size(I, 2)) 1]);
    J = reshape(J, [(size(J, 1) * size(J, 2)) 1]);
    allIntermediateCoordinates = horzcat(I, J);
        
    t = tsearchn(imINTERMEDIATE_pts, triangles, allIntermediateCoordinates);
    
    %% (2) Iterate through each triangle, and compute baricentric coordinates
    %      for points in each triangle.
    intermediateBariPoints = [];

    for tri = 1 : size(triangles, 1)
        A = [imINTERMEDIATE_pts(triangles(tri, 1), 1) imINTERMEDIATE_pts(triangles(tri, 2), 1) imINTERMEDIATE_pts(triangles(tri, 3), 1);
             imINTERMEDIATE_pts(triangles(tri, 1), 2) imINTERMEDIATE_pts(triangles(tri, 2), 2) imINTERMEDIATE_pts(triangles(tri, 3), 2);
             1                                        1                                        1];
        
        Ainv         = inv(A);
        
        % Identify points from allIntermediateCoordinates in triangle.
        pointsInTriangle = allIntermediateCoordinates(t == tri, :);
                
        numPoints = size(pointsInTriangle, 1);
        
        pointsInTriangle = horzcat(pointsInTriangle, ones(size(pointsInTriangle, 1), 1));
        
        AinvRowOne   = Ainv(1, :);
        AinvRowTwo   = Ainv(2, :);
        AinvRowThree = Ainv(3, :);

        bariX = (AinvRowOne   * pointsInTriangle')';
        bariY = (AinvRowTwo   * pointsInTriangle')';
        bariZ = (AinvRowThree * pointsInTriangle')';
        
        intermediateBariPointsAddition = horzcat(tri * ones(numPoints, 1), pointsInTriangle(:, 1), pointsInTriangle(:, 2), bariX, bariY, bariZ); 
        intermediateBariPoints = vertcat(intermediateBariPoints, intermediateBariPointsAddition);  
    end 

    %% (3) Compute the cooresponding pixel position in source image 1 and source image 2.
    % Iterate through each triangle.
    correspondingPointsSource1 = [];
    correspondingPointsSource2 = [];
    
    for tri =  1 : size(triangles, 1)
        A1 = [im1_pts(triangles(tri, 1), 1) im1_pts(triangles(tri, 2), 1) im1_pts(triangles(tri, 3), 1);
              im1_pts(triangles(tri, 1), 2) im1_pts(triangles(tri, 2), 2) im1_pts(triangles(tri, 3), 2);
              1                             1                             1];
          
        A2 = [im2_pts(triangles(tri, 1), 1) im2_pts(triangles(tri, 2), 1) im2_pts(triangles(tri, 3), 1);
              im2_pts(triangles(tri, 1), 2) im2_pts(triangles(tri, 2), 2) im2_pts(triangles(tri, 3), 2);
              1                             1                             1];
         
        % Extract contents from intermediateBariPoints for the relevant
        % triangle.
        try
            info = intermediateBariPoints(intermediateBariPoints(:,1) == tri, 2:6);
        catch
            disp('Exception caught');
            continue;
        end
        
        % Iterate through points in triangle.
        bari = info(:, 3:5);
        
        pixelPoints1 = (A1 * bari')';
        pixelPoints1 = pixelPoints1 ./ repmat(pixelPoints1(:, 3), [1 3]);
        
        correspondingPointsSource1 = vertcat(correspondingPointsSource1, horzcat(pixelPoints1(:, 1), pixelPoints1(:, 2), info(:, 1), info(:, 2)));
        
        pixelPoints2 = (A2 * bari')';
        pixelPoints2 = pixelPoints2 ./ repmat(pixelPoints2(:, 3), [1 3]);
        
        correspondingPointsSource2 = vertcat(correspondingPointsSource2, horzcat(pixelPoints2(:, 1), pixelPoints2(:, 2), info(:, 1), info(:, 2))); 
    end
    
    %% (4) Copy back the pixel value from source images 1 and 2 to target (floor pixel locations).
    morphedImage1  = zeros(size(im1, 1), size(im1, 2), 3);
    
    jSource = round(correspondingPointsSource1(:, 1));
    iSource = round(correspondingPointsSource1(:, 2));
    jTarget = round(correspondingPointsSource1(:, 3));
    iTarget = round(correspondingPointsSource1(:, 4));
    
    % Disregard invalid points.
    iLim = size(im1, 1);
    jLim = size(im1, 2);
        
    iSource(iSource < 1)    = 1;
    iSource(iSource > iLim) = iLim;
    jSource(jSource < 1)    = 1;
    jSource(jSource > jLim) = jLim;
     
    iTarget(iTarget < 1)    = 1;
    iTarget(iTarget > iLim) = iLim;
    jSource(jSource < 1)    = 1;
    jTarget(jTarget > jLim) = jLim;
     
    % Loop through points. 
    for i = 1 : size(correspondingPointsSource1, 1)
        morphedImage1(iTarget(i), jTarget(i), :) = im1(iSource(i), jSource(i), :);
    end

    morphedImage2 = zeros(size(im1, 1), size(im1, 2), 3);
    
    jSource = round(correspondingPointsSource2(:, 1));
    iSource = round(correspondingPointsSource2(:, 2));
    jTarget = round(correspondingPointsSource2(:, 3));
    iTarget = round(correspondingPointsSource2(:, 4));
    
    % Disregard invalid points.
    iLim = size(im2, 1);
    jLim = size(im2, 2);
        
    iSource(iSource < 1)    = 1;
    iSource(iSource > iLim) = iLim;
    jSource(jSource < 1)    = 1;
    jSource(jSource > jLim) = jLim;
     
    iTarget(iTarget < 1)    = 1;
    iTarget(iTarget > iLim) = iLim;
    jSource(jSource < 1)    = 1;
    jTarget(jTarget > jLim) = jLim;
     
    % Loop through points. 
    for i = 1 : size(correspondingPointsSource2, 1)
        morphedImage2(iTarget(i), jTarget(i), :) = im2(iSource(i), jSource(i), :);
    end
    
    % Cross dissolve images.
    dissolvedImage = (1 - dissolve_frac) * morphedImage1 + dissolve_frac * morphedImage2;
    morphed_im = uint8(dissolvedImage);
end