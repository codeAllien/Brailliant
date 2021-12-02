clc
clear variables
close all

I = imread('img_resource/ampel_wien.jpeg');
% I = imread('img_resource/blog.jpg');

I = imcomplement(I); % Bild Invertierung funktioniert noch nicht
imshow(I,"Parent",gca)
pos = customWait(drawpolygon('Position',[75 75; 75 205; 320 205; 320 75]));

heighta = abs(pos(1,1) - pos(3, 1))
widtha = abs(pos(1,2) - pos(3, 2))
[height, width, color] = size(I);

orig = [0 0; 0 height; width height ; width 0];

H = invert(fitgeotrans(orig,pos,'projective'));

J = imwarp(I,H,'OutputView',imref2d(size(I)));
J = imresize(J, [widtha heighta]);
J = imresize(J, 1000/heighta);

imshow(J);

BW = im2gray(J);
BW = medfilt2(BW,[5, 5]);
BW = imgaussfilt(BW,5); % smoth img

binaryThreshhold = 0.5;
BW = imbinarize(im2gray(BW),binaryThreshhold);

BW = medfilt2(BW,[5,5]);

figure;
imshow(BW);
title('Filter Only');

if sum(BW(:) == 1) > sum(BW(:) ==0)
    BW = imcomplement(BW);
    imshow(BW);
    title('Filters Only + Inverted');
end
% CC = bwconncomp(BW);
% numPixels = cellfun(@numel,CC.PixelIdxList);
%
% med = median(numPixels);
%
% [biggest,idx] = max(numPixels);
%
% pixels = CC.PixelIdxList{[numPixels > medPixelIdxList]};
%
% BW(pixels) = 0; % 0 replaced with a 1 to avoid losing circles
%
% img = ones(size(BW));
% img(pixels) = 0;
%
% figure;
% imshow(img);

% % % ****************************************
% % % ***************ADRIAN*******************
% % % ****************************************

% Bild wird auf der Variable BW bearbeitet und gespeichert

% Bild einlesen

E = edge(BW);

% % https://de.mathworks.com/help/images/ref/regionprops.html?searchHighlight=regionprops
s = regionprops(BW,'BoundingBox');
bbox = cat(1,s.BoundingBox);

% bbox = rmoutliers(bbox);
figure;
imshow(E);
hold on
width = [0];
height = [0];
boxsizes = [0];
% plot(centroids(:,1),centroids(:,2),'b*');
for i=1:size(bbox,1)
    rectangle('Position',[bbox(i,1) bbox(i,2) bbox(i,3) bbox(i,4)],'EdgeColor','r');
    boxsizes(i) = sqrt(bbox(i,3) * bbox(i,3) + bbox(i,4) * bbox(i,4));
end
hold off

med = median(boxsizes)/2;

se = strel('disk', round(med/4));
for i=0:10
    BW = imerode(BW, se);
    BW = imdilate(BW, se);
end

imshow(BW);

stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

hold on
viscircles(centers,radii);
hold off

% Connect Dots
[height, width] = size(BW);

imshow(BW);
title("Area Selection");
hold on

[count, horizontal_lines, vertical_lines] = draw_lines_and_circles(centers, radii, width, height);
count
horizontal_lines
vertical_lines


horizontal_diff = find_differences(horizontal_lines, BW, width, height, 0)
vertical_diff = find_differences(vertical_lines, BW, width, height, 1)

figure;
plot(horizontal_diff, 1, 'ro', vertical_diff, 2, 'ro');
title('Differences');

hold off

min = round(med*0.4);
max = round(med*1.8);
[centers, radii, metric] = imfindcircles(E, [min, max]); % ; can be removed


figure
imshow(BW);
title("Line Selection");
hold on
[count, horizontal_lines, vertical_lines] = draw_lines_and_circles(centers, radii, width, height);
count
horizontal_lines
vertical_lines
hold off




% % % Übersetzung in "Binär"
% % % Durch Vertikalen & Horizontale Projektion Z.B.

% BINÄR CODE
% 11    ".."
% 01    " ."
% 10    ". "
% 00    "  "


% % % ****************************************
% % % ***************FELIX********************
% % % ****************************************

braille_code = ["100000" "101000" "110000"];
result = braille_translate(braille_code ,"german");

% % % ****************************************
% % % ***************FUNCTION*****************
% % % ****************************************
function pos = customWait(hROI)

% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);
% Return the current position
pos = hROI.Position;
%pos(:,1) = (pos(:,1) - hROI.Parent.XLim(1)) / (hROI.Parent.XLim(2) - hROI.Parent.XLim(1));
%pos(:,2) = (pos(:,2) - hROI.Parent.YLim(1)) / (hROI.Parent.YLim(2) - hROI.Parent.YLim(1));

end

function clickCallback(~,evt)

if strcmp(evt.SelectionType,'double')
    uiresume;
end

end

function [count, horizontal_lines, vertical_lines]= draw_lines_and_circles(centers, radii, width, height)

daviationPercent = 0.09;
count = 0;

av_size = median(radii);
vertical_lines = 0;
horizontal_lines = 0;
for time=1:2
%     result_centers(1,:) = centers(1,:);
%     result_radii(1) = radii(1);
    line_count = 1;
    unselected_circles = ones(size(radii));
    for a=1:size(unselected_circles)
        if unselected_circles(a)
            unselected_circles(a) = 0;
            viscircles(centers(a,:), radii(a), 'Color', 'r');
            if time == 2
                line([0 width], [centers(a, 2), centers(a, 2)], 'Color','blue');
                horizontal_lines(line_count) = centers(a, 2);
            else
                line([centers(a, 1), centers(a, 1)], [0, height], 'Color','blue');
                vertical_lines(line_count) = centers(a, 1);
            end
            line_count = line_count + 1;
            for i=1:size(radii)
                if unselected_circles(i) & a ~= i & (abs(centers(i, time)-centers(a, time))<=radii(i) | abs(abs(centers(i, time)-centers(a, time))-radii(i)) <= av_size * daviationPercent)
                    count = count + 1;
                    viscircles(centers(i, :), radii(i), 'Color', 'b');
%                     result_centers(count, :) = centers(i, :);
%                     result_radii(count) = radii(i);
                    %                     pl = line([centers(a,1) centers(i, 1)], [centers(a,2), centers(i,2)], 'Color','red');
                    unselected_circles(i) = 0;
                end
            end
        end
    end
end
end

function differences = find_differences(lines, I, width, height, a)



line_array = sort(lines);
differences = ones([size(lines, 2)-1, 1]);
for i=1:size(line_array, 2)-1
    differences(i) = abs(line_array(i) - line_array(i+1));
    if a
        line([line_array(i), line_array(i+1)], [width/(i+1), width/(i+1)], 'Color','yellow');
    else
        line([height/(i+1), height/(i+1)], [line_array(i), line_array(i+1)], 'Color','yellow');
    end
end
end