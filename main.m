close all;
clc;

% get Input
input_name = "braille.png";
input_path = "img_resource/"+input_name;

% display original img
img = imread(input_path);
img_width = size(img, 1);
img_height = size(img, 2);

figure;
imshow(img);
title('Original Picture + Kreis');

canny_og_size = imresize(canny_output, [img_width img_height]);

[centers, radii, metric] = imfindcircles(img,[25 250]);

% centersStrong5 = centers(1:5,:); 
% radiiStrong5 = radii(1:5);
% metricStrong5 = metric(1:5);

viscircles(centers, radii,'EdgeColor','b');

figure;
imshow(img);
title('Original Picture');

% resize img
img = imresize(img, [1024 1024]);
img = rgb2gray(img); % tut was es soll
img = im2bw(img, 0.5); % funktioniert teilweise
canny_container.display_steps(img, "Converted Picture");

% figure;
% imshow(img);
% title('Resized & Black & White');

canny_output = canny_container.canny_edge_detection(img, 0);

canny_container.display_steps(canny_output, 'Canny Edge Detection Original');

% figure;
% imshow(canny_output);
% title('Canny Edge Detection Original');

% canny_container.display_steps(canny_og_size, 'Canny Edge Detection Resized');

% BW2 = canny_output;

%     S1 = strel('ball',1,5);
%     BW2 = imdilate(BW2,S1);

%     S2 = strel('line', 3, 90);
%     BW2 = imerode(BW2,S2);
%     S2 = strel('line', 3, 0);
%     BW2 = imerode(BW2, S2);
    % se = offsetstrel('ball',5,5);