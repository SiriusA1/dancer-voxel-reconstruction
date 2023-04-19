Voxel Reconstruction

Using the given pixel values and x range of -2.5:2.5, y range of -3:3, and z range of 0:2.5 with
100,000,000 voxels, constructs a 3d mesh of the dancer from the images and silhouettes. Projects
the pixel values onto the voxels and if all 8 images land on the same voxel, that voxel is "occupied."
If an occupied voxel is surrounded by empty voxels, it is a surface voxel. Outputs surfacePtCloud.ply
and coloredPtCloud.ply.

Step 2:
total occupied: 129257
total occupied / total voxels: 0.0012926

Step 3:
total surface: 3149
total surface / total voxels: 3.149e-05

Step 4:
surfacePtCloud.ply vertices: 3149
This number is the same as the total number of surface voxels from step 3. This is because
our voxels are essentially represented by pixels in the code, so the number of voxels and number of vertices
will be the same.