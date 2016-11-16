% Author:    Austin Small
% Class:     CIS-581
% File Name: click_correspondences.m
% Inputs:    im1:   H1 x W1 x 3 matrix representing the first image.
%            im2:   H2 x W2 x 3 matrix representing the second image.
% Outputs:   im1_pts:   N x 2 matrix representing correspondences
%                       coordinates in first image.
%            im2_pts:   N x 2 matrix representing correspondences
%                       coordinates in second image.

function [im1_pts, im2_pts] = click_correspondences(im1, im2, im1_pts, im2_pts)
    % Use cpselect tool to identify point correspondences between two
    % images.  When finished using tool, close window so that program may
    % proceed.
    [im1_pts, im2_pts] = cpselect(im1, im2, im1_pts, im2_pts, 'wait', true);
end