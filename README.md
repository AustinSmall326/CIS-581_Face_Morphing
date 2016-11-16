Overview:
------------------
This project focused on image morphing techniques.  The goal of this project was to create a "morph" animation of my face into another person's face.  A morph is a simultaneous warp of the image shape and a cross-dissolve of the image colors.  

In this project, I implement two morphing methods (point triangulation and thin plate spline).  The techniques utilized in this project were referenced from the following sources.

- https://alliance.seas.upenn.edu/~cis581/wiki/Projects/fall2016/project2/main.pdf
- http://cseweb.ucsd.edu/~sjb/eccv_tps.pdf

Project Walk-Through and Results:
--------------------

**Define Correspondences**

  -First, pairs of corresponding points are selected by hand across the two input images.  This portion of my code leverages MATLAB's built-in "cpselect" tool.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/9031637/20342033/c413059c-abb6-11e6-9ea7-4e75bf347f61.png" width="800">
</p>

**Image Morph Via Triangulation**

  - The point correspondences across two images are averaged, giving an average face.  Delauney triangulation is then performed on these points, sectioning the plane into triangles.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/22136934/20359373/89a8e934-abfd-11e6-854d-070eb894a3cb.jpg" width="650">
</p>

  - These triangles computed in the average face can be applied to the points in each of the original faces.

<p align="center">
  <img src="![untitled](https://cloud.githubusercontent.com/assets/22136934/20359684/e7e03cc2-abfe-11e6-9256-0b2d3fb1daa6.jpg)" width="650">
</p>

  - For each pixel in the new image, we determine where that point lies in the two original face images.  The new pixel is computed as a weighted 
  average of the original pixels.  The key insight here is that points that lie within a triangle in the original face images remain within that trangle after a transformation into the new image.




**Thin Plate Spline (TPS)**
