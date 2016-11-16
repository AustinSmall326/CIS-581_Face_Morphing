Overview:
------------------
This project focused on image morphing techniques.  The goal of this project was to create a "morph" animation of my face into another person's face.  A morph is a simultaneous warp of the image shape and a cross-dissolve of the image colors.  

In this project, I implement two morphing methods (point triangulation and thin plate spline).  The techniques utilized in this project were referenced from the following sources.

- https://alliance.seas.upenn.edu/~cis581/wiki/Projects/fall2016/project2/main.pdf
- http://cseweb.ucsd.edu/~sjb/eccv_tps.pdf

Project Walk-Through and Results:
--------------------

- *Define Correspondences*

  First, pairs of corresponding poins are selected by hand across the two input images.  This portion of my code leverages MATLAB's built-in "cpselect" tool.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/9031637/20342033/c413059c-abb6-11e6-9ea7-4e75bf347f61.png" width="800">
</p>

- Image Morph Via Triangulation



- Thin Plate Spline (TPS)
