clc;
close all;
clear all;
[filen, pathn]=uigetfile('*.bmp; *.png; *.jpg; *.tif' , 'Select an Input Image');%open file section
I=imread([pathn, filen]);
N=ndims(I)%returns the number of array dimensions
if ndims(I)==3
    I1=rgb2gray(I);%convert rgb to grayscale image 
else
    I1=I;
end 
I1=imresize(I1, [300,400]);
figure  
imshow(I1);
title ('Fundus Image');

m=zeros(size(I1,1), size(I1,2)); %Create array of all zeros
m(90:222,110:325) = 1;
I2=imresize(I1, 0.5);
m=imresize(m, 0.5 ); 
figure  
subplot(1,3,1); imshow(I2); title('Resized Fundus Image');
subplot(1,3,2); imshow(m); title('Initialization');

%activecontour is to segment image into foreground and background using active contours (snakes) region growing technique
seg = activecontour(I2, m, 150); %-- Run segmentation
subplot(1,3,3); imshow(seg); title('Region-Based Segmentation');
seg=imresize(seg, [size(I1,1), size(I1,2)]);
figure , imshow(seg); 
title('Contour Image');
 
for i=1:300
    for j=1:400
        if seg(i,j)==0
            I1(i,j)=0;
        end
    end
end
figure ,imshow (I1);
stats=regionprops (im2bw (I1), 'Area', 'BoundingBox'); %measure properties of image region including the properties area and bonding box
a=[stats.Area]==max([stats.Area]);
box1=round(stats(a).BoundingBox);
hold on
rectangle('Position', box1, 'EdgeColor', 'g', 'LineWidth', 3)
img=imcrop(I1,box1);
title('Image With Extracted Pixels'); 
figure  
imshow(img);
title ('Cropped Image');
img=imresize(img, [300,400]);
m=zeros(size(I1,1), size(I1,2));
m(90:222,110:325) = 1;
img2=imresize(img,0.5);
m=imresize(m, 0.5);
figure 
subplot(1,3,1); imshow(img); title('Resized cropped Image');
subplot(1,3,2); imshow(m); title('Initialization');
%activecontour is to segment image into foreground and background using active contours (snakes) region growing technique
seg1 = activecontour(img2, m, 550); %-- Run segmentation
subplot(1,3,3); imshow(seg1); title('Region-Based Segmentation');
figure 
BW = roipoly(seg1);%Specify polygonal region of interest (ROI)
BW=edge(BW,'canny');% detects edges in image  using the edge-detection algorithm specified by canny method.
imshow(BW);