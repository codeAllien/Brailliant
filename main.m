clc
clear variables
close all

I = imread('Datensatz/ampel.jpg');

I = image_processing(I);


BW = I;

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
% figure;
imshow(E);
hold on
boxsizes = zeros(size(bbox, 1),1);
% plot(centroids(:,1),centroids(:,2),'b*');
for i=1:size(bbox,1)
    rectangle('Position',[bbox(i,1) bbox(i,2) bbox(i,3) bbox(i,4)],'EdgeColor','r');
    boxsizes(i) = sqrt(bbox(i,3) * bbox(i,3) + bbox(i,4) * bbox(i,4));
end
hold off

med = median(boxsizes)/2;
figure;
imshow(BW);

stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
% Connect Dots
[height, width] = size(BW);

[~, ~, ~, angle] = draw_lines_and_circles(centers, radii, width, height);
angle(:)
    "Rotate IMG by " + mean(angle) + " deg."
BW = imrotate(BW, mean(angle));
hold off


BW = smooth_img(BW, round(med/4), 4);

figure;
imshow(BW);

stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

[height, width] = size(BW);
[count, horizontal_lines, vertical_lines, angle] = draw_lines_and_circles(centers, radii, width, height);

if count ~= 0

horizontal_diff = find_differences(horizontal_lines, BW, width, height, 0)
vertical_diff = find_differences(vertical_lines, BW, width, height, 1)

figure;
plot(horizontal_diff, 1, 'ro', vertical_diff, 2, 'ro');
title('Differences');

size(horizontal_diff)
size(horizontal_diff, 1)
remove_min = 0;
if size(horizontal_diff, 1) == 2
    "a"
    hor_k_means = kmeans(horizontal_diff, 2);
    hor_k_means
elseif size(horizontal_diff, 1) >2
    "ab"
    hor_k_means = kmeans(horizontal_diff, 3);
    hor_k_means
    remove_min = 1;
end
if size(vertical_diff, 1) > 2
    ver_k_means = kmeans(vertical_diff, 3);
    ver_k_means
end

figure;
p = plot(vertical_diff, ver_k_means, 'bo', horizontal_diff, hor_k_means, 'ro');
title('Groups');
hold off

figure
imshow(BW);
title("Optimised Lines");
hold on


% Remove Excessive Lines
% vertical_lines = vertical_lines(ver_k_means ~= 2);
% ver_k_means = ver_k_means( ver_k_means ~= 2);
% ver_k_means(ver_k_means==2) = 1;
% ver_k_means(ver_k_means==3) = 2;

% if remove_min
%     horizontal_lines = horizontal_lines(hor_k_means ~= 1);
%     hor_k_means = hor_k_means( hor_k_means ~= 1);
%     hor_k_means(hor_k_means==2) = 1;
%     hor_k_means(hor_k_means==3) = 2;
% end


if remove_min
    hor_mean_diff(:) = [mean(horizontal_diff(hor_k_means==1)) mean(horizontal_diff(hor_k_means==2)) mean(horizontal_diff(hor_k_means==3))];
    horizontal_diff = horizontal_diff(horizontal_diff ~= max(horizontal_diff));
else
    hor_mean_diff(:) = [mean(horizontal_diff(hor_k_means==1)) mean(horizontal_diff(hor_k_means==2))];
end
ver_mean_diff(:) = [mean(vertical_diff(ver_k_means==1)) mean(vertical_diff(ver_k_means==2)) mean(vertical_diff(ver_k_means==3))];

ver_mean_diff = ver_mean_diff(ver_mean_diff ~= max(ver_mean_diff));

% Draw calculated Lines
[top_left, rec_size] = draw_optimised_lines(hor_mean_diff, min(horizontal_lines), ver_mean_diff, min(vertical_lines), BW)

rec_size(:) = rec_size(:)+med*4;

im_width = round(rec_size(1));
im_height = round(rec_size(2));


for i=1:size(top_left,1)
    if top_left(i,1)-2*med + rec_size(1) > width | top_left(i,2)-2*med + rec_size(2) > height
        continue;
    end
    braille_symboles(:,:,i) = imresize(imcrop(BW, [top_left(i,1)-2*med, top_left(i,2)-2*med, im_width, im_height]), [im_height im_width]);
    %     figure;
    %     imshow(braille_symboles(:,:,i));
    %     title(i);
    
    for j=0:5
        top_left_x = top_left(i,1)-2*med + rec_size(1)/2*mod(j, 2);
        top_left_y = top_left(i,2)-2*med + rec_size(2)/3*mod(j, 3);
        rectangle('Position',[top_left_x top_left_y rec_size(1)/2 rec_size(2)/3],'EdgeColor','m');
        
    end
end

% figure;
% montage(imresize(braille_symboles(:,:,:), [im_height im_width]));
% title('Elementes');

hold off

min = round(med*0.4);
max = round(med*1.8);


E = edge(BW);

[centers, radii, metric] = imfindcircles(E, [min, max]); % ; can be removed


figure
imshow(BW);
title("Line Selection Original");
hold on
[count, horizontal_lines, vertical_lines, angle] = draw_lines_and_circles(centers, radii, width, height);
hold off




[new_centers, new_radii] = find_overlapping_circles(centers, radii);

figure
imshow(BW);
title("Line Selection Optimised");
hold on
[count, horizontal_lines, vertical_lines, angle] = draw_lines_and_circles(new_centers, new_radii, width, height);
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
braille_code = get_binary(braille_symboles, med*2)
result = braille_translate(braille_code ,"german")

% % % ****************************************
% % % ***************FUNCTION*****************
% % % ****************************************

else
    warning('Warning! No braille dots detected in input image!');
end

function [count, horizontal_lines, vertical_lines, angle]= draw_lines_and_circles(centers, radii, width, height)

daviationPercent = 0.09;
count = 0;

av_size = median(radii);
vertical_lines = 0;
horizontal_lines = 0;
angle = 0;
position = 1;
for time=1:2
    %     result_centers(1,:) = centers(1,:);
    %     result_radii(1) = radii(1);
    line_count = 1;
    unselected_circles = ones(size(radii));
    for origin=1:size(unselected_circles)
        if unselected_circles(origin)
            unselected_circles(origin) = 0;
            viscircles(centers(origin,:), radii(origin), 'Color', 'r');
            if time == 2
                line([0 width], [centers(origin, 2), centers(origin, 2)], 'Color','blue');
                horizontal_lines(line_count) = centers(origin, 2);
            else
                line([centers(origin, 1), centers(origin, 1)], [0, height], 'Color','blue');
                vertical_lines(line_count) = centers(origin, 1);
            end
            line_count = line_count + 1;
            for i=1:size(radii)
                if unselected_circles(i) & origin ~= i & (abs(centers(i, time)-centers(origin, time))<=radii(i) | abs(abs(centers(i, time)-centers(origin, time))-radii(i)) <= av_size * daviationPercent)
                    count = count + 1;
                    viscircles(centers(i, :), radii(i), 'Color', 'b');
                    %                     result_centers(count, :) = centers(i, :);
                    %                     result_radii(count) = radii(i);
                    line([centers(origin,1) centers(i, 1)], [centers(origin,2), centers(i,2)], 'Color','red');
                    unselected_circles(i) = 0;
                    
                    if time
                        % Calculate the angle of the Dot to the "origin" dot
                        a = (centers(origin, 2)+radii(origin)-centers(i, 2)-radii(i));
                        b = (centers(origin, 1)+radii(origin)-centers(i, 1)-radii(i));
                        c = sqrt((a*a)+(b*b));
                        angle(position) = asin(a/c); % asin(((c*c)+(b*b)-(a*a))/(2*b*sqrt(c)));
                        position = position+1;
                    end
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


function [IMG]=smooth_img(IMG, size, times)
se = strel('disk', round(size));
for a=1:times
    IMG = imerode(IMG, se);
    IMG = imdilate(IMG, se);
end
end

function [new_centers, new_radii] = find_overlapping_circles(centers, radii)

unselected_circles = ones(size(radii));
calc_new_radii = 1;
new_centers = 1;
new_radii = 1;
for circle=1:size(radii)
    if unselected_circles(circle)
        unselected_circles(circle) = 0;
    else
        continue;
    end
    
    centers_temp = 0;
    radii_temp = 0;
    
    centers_temp(1,1) = centers(circle, 1);
    centers_temp(1,2) = centers(circle, 2);
    radii_temp(1) = radii(circle);
    for overlap=1:size(radii)
        a = abs(centers(circle, 1) - centers(overlap, 1));
        b = abs(centers(circle, 2) - centers(overlap, 2));
        if unselected_circles(overlap) &  sqrt(a*a + b*b) <= radii(circle) + radii(overlap)
            centers_temp(size(centers_temp,1)+1,:) = centers(overlap, :);
            radii_temp(size(radii_temp)+1) = radii(overlap);
            unselected_circles(overlap) = 0;
            
        end
    end
    
    %     if size(radii_temp) == 1
    %         "1"
    %         new_centers(calc_new_radii,1) = centers(circle, 1);
    %         new_centers(calc_new_radii,2) = centers(circle, 2);
    %         new_radii(calc_new_radii) = radii(circle);
    %     else
    
    new_centers(calc_new_radii,1) = mean(centers_temp(:, 1));
    new_centers(calc_new_radii,2) = mean(centers_temp(:, 2));
    
    %     new_centers(calc_new_radii) = [mean(centers_temp(:,1)) mean(centers_temp(:,2))];
    
    a = centers_temp(:,1) - new_centers(calc_new_radii, 1);
    b = centers_temp(:, 2) - new_centers(calc_new_radii, 2);
    new_radii(calc_new_radii) = max(radii_temp(:) + sqrt(a(:).*a(:)+b(:).*b(:)));
    
    calc_new_radii = calc_new_radii + 1;
end
new_radii = new_radii(:);
end

function [top_left, rec_size] = draw_optimised_lines(hor_mean_diff, horizontal_start, ver_mean_diff, vertical_start, image)
[height, width] = size(image);

pos = horizontal_start;
time = 0;
color = "yellow";

count = 0;
while pos < height
    line([0, width], [pos, pos], 'Color',color);
    count = count + 1;
    row_list(count) = pos;
    if time ~= 2
        pos = pos +  min(hor_mean_diff);
        color = "red";
    else
        pos = pos + max(hor_mean_diff);
        color = "yellow";
    end
    time = mod(time + 1, 3);
end


pos = vertical_start;
time = 1;
color = "yellow";

count = 0;
while pos < width
    line([pos, pos], [0, height], 'Color', color);
    count = count + 1;
    col_list(count) = pos;
    if time
        pos = pos + min(ver_mean_diff);
        color = "blue";
    else
        pos = pos + max(ver_mean_diff);
        color = "yellow";
    end
    time = mod(time + 1, 2);
end

row_size = round(size(row_list, 2)/3);
col_size = round(size(col_list, 2)/2);
top_left = zeros(row_size*col_size, 2)
rec_size = [min(hor_mean_diff) min(ver_mean_diff)*2]
% bottom_right = zeros(row_size, col_size, 2)
count = 1;
for row=1:row_size
    for col=1:col_size
        top_left(count,:) = [col_list(2*col-1) row_list(3*row-2)];
        count = count + 1;
        %         (row_size*(row-1))+col
        %         bottom_right(row,col,:) = [top_left(row, 1) + min(hor_mean_diff),top_left(row, 2) + min(ver_mean_diff)];
    end
end

end


function [binary_code] = get_binary(im_data, padding)

[height width count] = size(im_data)
segment_height = (height - padding*2)/2;
segment_width = (width - padding*2);
figure;
for i=1:count
    I = im_data(:,:,i);
    s = regionprops(I,'BoundingBox');
    bbox = cat(1,s.BoundingBox);
    binary_for_letter = zeros(6);
    imshow(I);
    
    line([0, width], [padding, padding], 'Color','blue');
    line([0, width], [padding + segment_width, padding + segment_width], 'Color','blue');
    line([0, width], [padding + 2*segment_width, padding + 2*segment_width], 'Color','blue');
    
    line([padding, padding], [0, height], 'Color','blue');
    line([padding + segment_height, padding + segment_height], [0, height], 'Color','blue');
    
    
    for element=1:size(bbox, 1)
        rectangle('Position',bbox(element,:),'EdgeColor','r');
        center_x = bbox(element, 1) + bbox(element, 3)/2;
        center_y = bbox(element, 2) + bbox(element, 4)/2;
        if center_x < padding + segment_width/2
            a=1;
        else
            a=2;
        end
        
        if center_y < padding + segment_height/2
            b=0;
        elseif center_y < padding + 3*segment_height/2
            b=2;
        else
            b=4;
        end
        if binary_for_letter(a+b)
            "Error Dot was matched twice"
        end
        binary_for_letter(a+b) = 1;
    end
    temp = "";
    for k=1:6
        temp = temp + string(binary_for_letter(k));
    end
    binary_code(i, :) = string(temp);
    title(binary_code(i) + " -> " +braille_translate(binary_code(i) ,"german"));
end

end