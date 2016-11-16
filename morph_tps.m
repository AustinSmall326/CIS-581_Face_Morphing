% Author:    Austin Small
% Class:     CIS-581
% File Name: morph_tps.m
% Inputs:    im_source      H x W x 3 matrix representing the source image.
%            a1_x, ax_x     The parameters solved when doing est_tps in the
%            ay_x, w_x      x direction
%            ctr_pts        N x 2 matrix, each row representing 
%                           corresponding point position (x,y) in source
%                           image.
%            sz             1x2 vector representing the target image size
%                           (H, W).
% Outputs:   morphed_im:    H x W x 3 matrix representing the morphed 
%                           image.

function [morphed_im] = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz)
    % For all points in morphed image, determine corresponding point in 
    % source image, and copy pixel.
    morphed_im = zeros(sz(1), sz(2), 3);
        
    [X_t, Y_t] = meshgrid(1 : sz(2), 1 : sz(1));
        
    X_t2d = X_t;
    Y_t2d = Y_t;
    
    X_t = repmat(X_t, 1, 1, size(ctr_pts, 1));
    Y_t = repmat(Y_t, 1, 1, size(ctr_pts, 1));
    
    ctr_pts_x_cubed = repmat(reshape(ctr_pts(:, 1), [1 1 size(ctr_pts, 1)]), size(X_t, 1), size(X_t, 2));    
    ctr_pts_y_cubed = repmat(reshape(ctr_pts(:, 2), [1 1 size(ctr_pts, 1)]), size(Y_t, 1), size(Y_t, 2));    
    
    % Compute r.
    rMat = ((ctr_pts_x_cubed - X_t) .^ 2 + (ctr_pts_y_cubed - Y_t) .^ 2) .^ (1/2);
    
    % Compute K.
    kMat = -1 * rMat .^ 2 .* log(rMat .^ 2);
    kMat(isnan(kMat)) = 0;
    
    kMat = cat(3, kMat, X_t2d, Y_t2d, ones(size(kMat, 1), size(kMat, 2)));
    
    % Develop x vector in Ax = b equation.
    XMat_x = repmat(reshape(w_x, [1 1 size(w_x, 1)]), size(X_t, 1), size(X_t, 2));
    XMat_x = cat(3, XMat_x, ax_x * ones(size(XMat_x, 1), size(XMat_x, 2)), ...
                            ay_x * ones(size(XMat_x, 1), size(XMat_x, 2)), ...
                            a1_x * ones(size(XMat_x, 1), size(XMat_x, 2)));
                        
    XMat_y = repmat(reshape(w_y, [1 1 size(w_y, 1)]), size(Y_t, 1), size(Y_t, 2));
    XMat_y = cat(3, XMat_y, ax_y * ones(size(XMat_y, 1), size(XMat_y, 2)), ...
                            ay_y * ones(size(XMat_y, 1), size(XMat_y, 2)), ...
                            a1_y * ones(size(XMat_y, 1), size(XMat_y, 2)));

    X_s = sum(kMat .* XMat_x, 3);
    Y_s = sum(kMat .* XMat_y, 3);
    
    % Perform rounding and account for borders.
    X_s = round(X_s);
    Y_s = round(Y_s);
    
    X_s(X_s < 1) = 1;
    Y_s(Y_s < 1) = 1;
    
    xLimSource = size(im_source, 2);
    yLimSource = size(im_source, 1);
    
    X_s(X_s > xLimSource) = xLimSource;
    Y_s(Y_s > yLimSource) = yLimSource;
    
    % Loop through pixels.
    for x = 1 : size(morphed_im, 2)
        for y = 1 : size(morphed_im, 1)
            morphed_im(y, x, :) = im_source(Y_s(y, x), X_s(y, x), :);
        end
    end
end