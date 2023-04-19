%% clear workspace
clc
clear all
close all

%% Part 1

P1 = [776.649963 -298.408539 -32.048386 993.1581875;132.852554 120.885834 -759.210876 1982.174000;0.744869 0.662592 -0.078377 4.629312012];
P2 = [431.503540 586.251892 -137.094040 1982.053375;23.799522 1.964373 -657.832764 1725.253500;-0.321776 0.869462 -0.374826 5.538025391];
P3 = [-153.607925 722.067139 -127.204468 2182.4950;141.564346 74.195686 -637.070984 1551.185125;-0.769772 0.354474 -0.530847 4.737782227];
P4 = [-823.909119 55.557896 -82.577644 2498.20825;-31.429972 42.725830 -777.534546 2083.363250;-0.484634 -0.807611 -0.335998 4.934550781];
P5 = [-715.434998 -351.073730 -147.460815 1978.534875;29.429260 -2.156084 -779.121704 2028.892750;0.030776 -0.941587 -0.335361 4.141203125];
P6 = [-417.221649 -700.318726 -27.361042 1599.565000;111.925537 -169.101776 -752.020142 1982.983750;0.542421 -0.837170 -0.070180 3.929336426];
P7 = [94.934860 -668.213623 -331.895508 769.8633125;-549.403137 -58.174614 -342.555359 1286.971000;0.196630 -0.136065 -0.970991 3.574729736];
P8 = [452.159027 -658.943909 -279.703522 883.495000;-262.442566 1.231108 -751.532349 1884.149625;0.776201 0.215114 -0.592653 4.235517090];

P = zeros(3,4,8);

im1 = imread('cam00_00023_0000008550.png');
im2 = imread('cam01_00023_0000008550.png');
im3 = imread('cam02_00023_0000008550.png');
im4 = imread('cam03_00023_0000008550.png');
im5 = imread('cam04_00023_0000008550.png');
im6 = imread('cam05_00023_0000008550.png');
im7 = imread('cam06_00023_0000008550.png');
im8 = imread('cam07_00023_0000008550.png');

sil1 = imread('silh_cam00_00023_0000008550.pbm');
sil2 = imread('silh_cam01_00023_0000008550.pbm');
sil3 = imread('silh_cam02_00023_0000008550.pbm');
sil4 = imread('silh_cam03_00023_0000008550.pbm');
sil5 = imread('silh_cam04_00023_0000008550.pbm');
sil6 = imread('silh_cam05_00023_0000008550.pbm');
sil7 = imread('silh_cam06_00023_0000008550.pbm');
sil8 = imread('silh_cam07_00023_0000008550.pbm');

[rows,cols,colors] = size(im1); %582 * 780
colored_im = zeros(rows, cols, colors, 8);
silhouette_im = zeros(rows, cols, 8);

P(:,:,1) = P1;
P(:,:,2) = P2;
P(:,:,3) = P3;
P(:,:,4) = P4;
P(:,:,5) = P5;
P(:,:,6) = P6;
P(:,:,7) = P7;
P(:,:,8) = P8;

colored_im(:,:,:,1) = im1;
colored_im(:,:,:,2) = im2;
colored_im(:,:,:,3) = im3;
colored_im(:,:,:,4) = im4;
colored_im(:,:,:,5) = im5;
colored_im(:,:,:,6) = im6;
colored_im(:,:,:,7) = im7;
colored_im(:,:,:,8) = im8;

silhouette_im(:,:,1) = sil1;
silhouette_im(:,:,2) = sil2;
silhouette_im(:,:,3) = sil3;
silhouette_im(:,:,4) = sil4;
silhouette_im(:,:,5) = sil5;
silhouette_im(:,:,6) = sil6;
silhouette_im(:,:,7) = sil7;
silhouette_im(:,:,8) = sil8;

x_min = -2.5;
x_max = 2.5;
x_range = x_max - x_min;
y_min = -3;
y_max = 3;
y_range = y_max - y_min;
z_min = 0;
z_max = 2.5;
z_range = z_max - z_min;
voxel_num = 100000000; 
voxel_size = nthroot((x_range*y_range*z_range/voxel_num), 3);

%% Part 2 & 3
occupied_coords = [];
occupied_colors = [];
total_occ = 0;
total_surface = 0;
surface_points = [];

for x = x_min:voxel_size:x_max
    for y = y_min:voxel_size:y_max
        is_first = 0;
        last = [];
        for z = z_min:voxel_size:z_max
            hom_coords = [x, y, z, 1]';
            projected_imgs = zeros(1, 8);
            for img_num = 1:8
                projected_pixel = P(:,:,img_num) * hom_coords;
                u = projected_pixel(1)/projected_pixel(3);
                v = projected_pixel(2)/projected_pixel(3);
                % if u and v are between 1 and max index, check if it's in
                % silhouetted image
                if((u>=1 && u<=cols) && (v>=1 && v<=rows))
                    projected_imgs(:, img_num) = silhouette_im(round(v), round(u), img_num);
                end   
            end
            % if all 8 projected voxels are in the silhouettes, then the
            % voxel is occupied
            if(all(projected_imgs(:,:) == 1))
                
                % add coordinated to list of occupied coords and add colors
                total_occ = total_occ + 1;
                occupied_coords = [occupied_coords; hom_coords(1:end-1)'];
                r = colored_im(round(v), round(u), 1, 8);
                g = colored_im(round(v), round(u), 2, 8);
                b = colored_im(round(v), round(u), 3, 8);
                occupied_colors = [occupied_colors; [r g b]];

                % checking if this is the first occupied pixel, i.e. if the
                % neighbors are empty
                if(is_first == 0)
                    surface_points = [surface_points; last];
                    surface_points = [surface_points; hom_coords(1:end-1)'];
                    total_surface = total_surface + 1;
                    is_first = 1;
                    continue;
                end

                if(is_first == 1)
                    last = [];
                    last = [last; [x, y, z]];
                end

            end         
        end
    end
end

disp("total occupied: " + total_occ);
disp("total surface: " + total_surface);
disp("total occupied / total voxels: " + total_occ / voxel_num);
disp("total surface / total voxels: " + total_surface / voxel_num);

%% Part 4
surfacePtCloud = pointCloud(surface_points);
pcwrite(surfacePtCloud,'surfacePtCloud','PLYFormat','ascii');

%% Part 5
coloredPtCloud = pointCloud(occupied_coords);
coloredPtCloud.Color = uint8(occupied_colors);
pcwrite(coloredPtCloud,'coloredPtCloud','PLYFormat','ascii');
