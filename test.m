clc
clear variables
close all

% % % FIRST PART % % %

I = imread('img_resource/ampel_wien.jpeg');
% I = imread('img_resource/blog.jpg');
% I = imread('img_resource/braille (2).jpeg');
% I = imread('img_resource/bahnhof.jpg');
% I = imread('img_resource/bahnhof (2).jpg');
% I = imread('coloredChips.png');

I = image_processing(I);
BW = I;

[height, width] = size(BW);

% % % CODE % % %

% % Canny Filter
E = edge(BW);

% % https://de.mathworks.com/help/images/ref/regionprops.html?searchHighlight=regionprops
s = regionprops(BW,'BoundingBox');
bbox = cat(1,s.BoundingBox);

% % bbox = rmoutliers(bbox);
figure;
imshow(BW);
hold on

bbox = group_elements(bbox, width, height);
angle = draw_groups(bbox);
figure;
imshow(imrotate(BW, mean(angle)));
title('Rotated ungrouped');

% % Get Median Height to connect different boxes
bbox_med_height = mean(bbox(:,4));
threshold = 0.2;
temp = bbox(:,5);
min_y = 0;
max_y = 0;

% % Unite simular lines
for i = 2:size(bbox,1)
    if min_y == 0
        min_y = bbox(i-1, 2);
        max_y = bbox(i-1, 2) + bbox(i-1, 4);
    end
    if bbox(i, 5) == bbox(i-1, 5)
        continue;
    elseif (abs(max_y - bbox(i, 2)) < bbox_med_height * threshold) || (abs(min_y - (bbox(i, 2)+bbox(i, 4))) < bbox_med_height * threshold)
        for c = i:size(bbox, 1)
            bbox(c, 5) = bbox(c, 5) -1;
        end
        min_y = 0;
    else
        min_y = 0;
    end
end

cat(2, bbox(:,5), temp)

figure
imshow(BW);
bbox = group_elements(bbox, width, height);
angle = draw_groups(bbox);

figure;
rotation_angle = mean(angle)
rotated_image = imrotate(BW, rotation_angle);
imshow(rotated_image);
title('Rotated Optimised');

% % Rotation Test
[width, height] = size(BW);

pos = zeros(4, 4);
count = 0;
bbox = sortrows(sortrows(bbox, 1, 'ascend'), 5, 'ascend');
% for i = 1:size(bbox, 1)
%     switch(count)
%         case 0
%             count = 1;
%             pos(count) = bbox(i, 1:4); 
%         case 1
%             if i+1 < i
% end
orig = [0 0; 0 height; width height ; width 0];


H = invert(fitgeotrans(orig,pos,'projective'));
J = imwarp(BW,H,'OutputView',imref2d(size(BW)));
imshow(J)


% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % Functions % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % 

function [lower_limit, upper_limit] = mark_element(element, width, height, color)
lower_limit = [element(1), element(2)];
upper_limit = [lower_limit(1)+element(3), lower_limit(2)+element(4)];

% line([lower_limit(1) lower_limit(1)], [0 height], 'Color', color);
% line([upper_limit(1) upper_limit(1)], [0 height], 'Color', color);
% line([width 0], [lower_limit(2) lower_limit(2)], 'Color', color);
% line([width 0], [upper_limit(2) upper_limit(2)], 'Color', color);
% plot(element(1)+element(3)/2, element(2)+element(4)/2, 'ro');
end

function result = group_elements(bbox, width, height)
selected = zeros(size(bbox,1), 1);

count = 1;
bbox = sortrows(sortrows(bbox, 1, 'ascend'), 2, 'ascend');
bbox = cat(2, bbox, zeros(size(bbox,1),1));

threshold = 0;%.35;%mean(bbox(:,2));

for start_element = 1:size(bbox,1)
    if selected(start_element) | bbox(start_element, 5) ~= 0
        continue;
    else
        [lower_limit, upper_limit] = mark_element(bbox(start_element,:), width, height, 'cyan');
        
        bbox(start_element, 5) = count;
        selected(start_element) = 1;
    end
    
    for i=1:size(bbox,1)
        if selected(i)
            continue
        end
        lokal_lower_limit = [bbox(i, 1), bbox(i, 2)];
        lokal_upper_limit = [bbox(i, 1)+bbox(i, 3), bbox(i, 2)+bbox(i, 4)];
        
        % x_extrema_p1 = [lokal_lower_limit(1) lokal_upper_limit(1)];
        % x_extrema_p2 = [lower_limit(1) upper_limit(1)];
        % % can be done by a variable in a third big loop
        y_extrema_p1 = [lokal_lower_limit(2) lokal_upper_limit(2)];
        y_extrema_p2 = [lower_limit(2) upper_limit(2)];
        
        if are_aligned(y_extrema_p1, y_extrema_p2, threshold) % | are_aligned(y_extrema_p1, [bbox(i-1, 2) bbox(i-1, 2)+bbox(i-1, 4)])
            selected(i) = 1;
            bbox(i, 5) = count;
        else
            break;
        end
    end
    count = count + 1;
end
result = bbox;
end


% % OPTIMISATION NEEDED.
% % NO NEED TO CALCULATE X AND Y
% % ONLY ONE IS REQUIRED
function result = are_aligned(extrema_p1, extrema_p2, threshold)
result = extrema_p1(1) >= extrema_p2(1) & extrema_p1(1) <= extrema_p2(2);
result = result | (extrema_p1(2) * (1+threshold) >= extrema_p2(1) & extrema_p1(2) <= extrema_p2(2) * (1+threshold));
result = result | (extrema_p1(1) <= extrema_p2(1) * (1+threshold) & extrema_p1(1) * (1+threshold) >= extrema_p2(2));
result = result | (extrema_p1(2) <= extrema_p2(1) * (1+threshold) & extrema_p1(2) * (1+threshold) >= extrema_p2(2));
end

function angle = draw_groups(bbox)
bbox = sortrows(sortrows(bbox, 1, 'ascend'), 5, 'ascend');

hold on
start_value = bbox(1,:);
global_mid = [start_value(1)+start_value(3)/2 start_value(2)+start_value(4)/2];
angle = zeros(bbox(size(bbox, 1)-1, 5), 1);
plot(global_mid(1), global_mid(2), 'ro');
count = 0;
for i=2:size(bbox, 1)
    if start_value(5) ~= bbox(i, 5)
        rectangle('Position', start_value(1:4), 'EdgeColor', 'r');
        rectangle('Position', bbox(i-1, 1:4), 'EdgeColor', 'r');
        start_value = bbox(i,:);
        global_mid = [start_value(1)+start_value(3)/2 start_value(2)+start_value(4)/2];
        plot(global_mid(1), global_mid(2), 'ro');
    else
        angle(start_value(5)) = angle(start_value(5)) + calculate_angle(start_value, bbox(i,:));
        count = count + 1;
        lokal_mid = [bbox(i,1)+bbox(i,3)/2 bbox(i,2)+bbox(i,4)/2];
        line([lokal_mid(1) global_mid(1)], [lokal_mid(2) global_mid(2)], 'Color', 'red');
        plot(lokal_mid(1), lokal_mid(2), 'ro');
    end
    if bbox(i-1, 5) ~= bbox(i, 5) | i == size(bbox, 1)
        if count ~= 0
            temp = angle(bbox(i-1, 5)) / count;
            angle(bbox(i-1, 5)) = temp;
        end
        count = 0;
    end
end
hold off
angle

    function calc_angle = calculate_angle(A, B)
        a = (A(1) + A(3)/2) - (B(1) + B(3)/2); % x1 - x2
        b = (A(2) + A(4)/2) - (B(2) + B(4)/2); % y1 - y2
        c = sqrt(a*a+b*b);
        calc_angle = 0;
        if c ~= 0
            calc_angle = acos(a/c);
        end
    end
end