% Author:      Austin Small
% Class:       CIS-581
% File Name:   est_tps.m
% Description: We are looking for a mapping from control points to 
%              target points.
% Inputs:      source_pts:    N x 2 matrix, each row representing
%                             corresponding point position (x,y) in second
%                             image.
%              target_val:    N x 1 matrix representing corresponding point
%                             position (x or y) in first image.
% Outputs:     a1:            double, TPS parameters.
%              ax:            double, TPS parameters.
%              ay:            double, TPS parameters.
%              w:             N x 1 vector, TPS parameters.

function [a1, ax, ay, w] = est_tps(ctr_pts, target_val)
    lambda = eps;
    N = size(ctr_pts, 1);
    
    % Compose K matrix.
    xPointsMat  = repmat(ctr_pts(:, 1), 1, N);
    xPointsDiff = xPointsMat - xPointsMat'; 

    yPointsMat  = repmat(ctr_pts(:, 2), 1, N);
    yPointsDiff = yPointsMat - yPointsMat';
    
    normMat = (xPointsDiff .^ 2 + yPointsDiff .^ 2) .^ (1/2);
    
    K = -1 * normMat.^2 .* log(normMat.^2);
    K(isnan(K)) = 0;
        
    % Compose P matrix.
    P = horzcat(ctr_pts, ones(N, 1));

    AUpper = horzcat(K, P);
    ALower = horzcat(P', zeros(3));
    A      = vertcat(AUpper, ALower);
    
    B = vertcat(target_val, zeros(3, 1));
    
    % Ax = b
    % x = inv (A + lambda *I)*b
    output = (A + lambda * eye(N + 3)) \ B;
        
    ax = output(N + 1, 1);
    ay = output(N + 2, 1);
    a1 = output(N + 3, 1);
    w  = output(1:N, 1);
end