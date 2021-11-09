close all;
clc;

% Bild wird auf der Variable I bearbeitet und gespeichert

% Bild einlesen
I = rgb2gray(imread('img_resource/blog.jpg'));
imshow(I);

% Bildgröße festlegen
img_width = 500;
img_height = 500;

% Resize IMG
I = imresize(I, [img_width img_height]);

% Bild Rauschen Entfernen
I = imgaussfilt(I,0.7);
figure;
imshow(I);
title('Rauschunterdrückung');

% Kontrast
n = 2;  
Idouble = im2double(I); 
avg = mean2(Idouble)
sigma = std2(Idouble)
avg+(n*sigma)
avg-(n*sigma)
I = imadjust(I,[abs(avg-(n*sigma)) abs(avg+(n*sigma))]); % avg+(n*sigma) anstelle von 1

% Hintergrund erkennen
% Pixel in Cluster Unterteilen
% Zwei Cluster Bilden
%   -> Hintergrund
%   -> Vordergrund
% Größerer Cluster ist Hintergrund und wird weiß gefärbt
% Kleinerer Cluster schwarz, für die Punkte

result = kmeans(I, 2); % 
result
figure;
imshow(result);
title('pls work')

% figure;
% imshow(I);
% title('Kontrast');

% Schwarz Weiß Bild
temp = I;
I = imbinarize(I);
figure;
imshowpair(temp,I,'montage');
title('Kontrast vs. Binärbild');

