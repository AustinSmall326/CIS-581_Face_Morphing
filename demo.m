% Clear workspace.
clf; clear; clc;

% Load face images.
img1 = imread('Images/image1.jpg');
img2 = imresize(imread('Images/image2.jpg'), [size(img1, 1) size(img1, 2)]);

load('point_correspondences');

[im1_pts, im2_pts] = click_correspondences(img1, img2, im1_pts, im2_pts);

save('point_correspondences', 'im1_pts', 'im2_pts');

%% Generate transition video using triangulation.
fname = 'Output/Project2_trig_Austin_Brad.avi';

% VideoWriter based video creation
h_avi = VideoWriter(fname, 'Uncompressed AVI');
h_avi.FrameRate = 10;
h_avi.open();
    
% Morph iteration
for w=0:(1/59):1
    morphed_im = morph(img1, img2, im1_pts, im2_pts, w, w);

    % if image type is double, modify the following line accordingly if necessary
    imagesc(morphed_im);
    axis image; axis off; drawnow;
    
    % VideoWriter based video creation
    h_avi.writeVideo(getframe(gcf));
end
  
% VideoWriter based video creation
h_avi.close();
clear h_avi;    
    
%% Generate transition video using tps.
fname = 'Output/Project2_tps_Austin_Brad.avi';

% VideoWriter based video creation
h_avi = VideoWriter(fname, 'Uncompressed AVI');
h_avi.FrameRate = 10;
h_avi.open();
    
% Morph iteration
for w=0:(1/59):1
    morphed_im = morph_tps_wrapper(img1, img2, im1_pts, im2_pts, w, w);

    % if image type is double, modify the following line accordingly if necessary
    imagesc(morphed_im);
    axis image; axis off; drawnow;
    
    % VideoWriter based video creation
    h_avi.writeVideo(getframe(gcf));
end
  
% VideoWriter based video creation
h_avi.close();
clear h_avi;    