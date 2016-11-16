% Author:    Austin Small
% Class:     CIS-581
% File Name: morph_tps_wrapper.m
% Inputs:    im1           H x W x 3 matrix representing the first image.
%            im2           H x W x 3 matrix representing the second image.
%            im1_pts       N x 2 matrix representing point correspondences 
%                          in the first image.
%            im2_pts       N x 2 matrix representing point correspondences
%                          in the second image.
%            warp_frac     parameter to control shape warping.
%            dissolve_frac parameter to control cross-dissolve.
% Outputs:   morphed_im:   H x W x 3 matrix representing the morphed 
%                          image.

function [morphed_im] = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, ...
                                          warp_frac, dissolve_frac)
    % Compute intermediate shape.
    imINTERMEDIATE_pts = (1 - warp_frac) * im1_pts + warp_frac * im2_pts;
    
    [a1_x, ax_x, ay_x, w_x] = est_tps(imINTERMEDIATE_pts, im1_pts(:, 1));
    [a1_y, ax_y, ay_y, w_y] = est_tps(imINTERMEDIATE_pts, im1_pts(:, 2));
    
    sz = [size(im1, 1) size(im1, 2)];
    
    morphed_im1 = morph_tps(im1, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ...
                            ay_y, w_y, imINTERMEDIATE_pts, sz);
                                              
    [a1_x, ax_x, ay_x, w_x] = est_tps(imINTERMEDIATE_pts, im2_pts(:, 1));
    [a1_y, ax_y, ay_y, w_y] = est_tps(imINTERMEDIATE_pts, im2_pts(:, 2));
    
    sz = [size(im2, 1) size(im2, 2)];
    
    morphed_im2 = morph_tps(im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ...
                            ay_y, w_y, imINTERMEDIATE_pts, sz);
                       
                       
    morphed_im = (1 - dissolve_frac) * morphed_im1 + dissolve_frac * morphed_im2;    
    morphed_im = uint8(morphed_im);                          
end                                          