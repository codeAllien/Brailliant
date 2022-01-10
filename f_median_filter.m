function result = f_median_filter(I, filter_size)
[height, width, dimension] = size(I);

if dimension > 1
    temp = (I(:,:,1) + I(:,:,2) + I(:,:,3))/3;
    imshow(temp);
    I = temp;
    [height, width, dimension] = size(I)
end

result = zeros(size(I));
if filter_size(1) <= 0
    filter_size(1) = 1;
end
filter_height = filter_size(1)*2-1;
filter_width = filter_height;
if size(filter_size, 2) == 2
    if filter_size(2) <= 0
        filter_size(2) = 1;
    end
    filter_width = filter_size(2)*2-1;
end

T = zeros(size(I));

for d = 1:dimension
    for o_x = 1:height % original_x
        for o_y = 1:width % original_y
            s_x = (filter_height- 1) / 2; % start_x
            s_y = (filter_width - 1) / 2; % start_y
            values = 0;
            value_count = 0;
            for n_x = 0:filter_height-1 % new_x
                x_pos = (o_x + n_x) - s_x;
                if x_pos <= 0 | x_pos > size(I, 1) % check if area is outside image boundaries
                    continue
                end
                for n_y = 0:filter_width-1 % new_y
                    y_pos = (o_y + n_y) - s_y;
                    if y_pos <= 0 | y_pos > size(I, 2) % check if area is outside image boundaries
                        continue
                    end
                    value_count = value_count + 1;
                    values(value_count) = I(x_pos, y_pos, d);
                end
            end
            med = median(values);
            result(o_x, o_y, d) = med;
            T(o_x, o_y, d) = 250;
        end
    end
end
figure(2);
set(gcf, 'Position', get(0,'ScreenSize'));
subplot(2,3,1),imshow(imread('kobi.png')), title('Original');
subplot(2,3,2),imshow(I),title('Noisy Image');
subplot(2,3,3),imshow(result),title('Output');
subplot(2,3,4),imshow(zeros(size(T))), title('Selected Element 1');

% The video explaining code is available at : https://www.youtube.com/watch?v=SkZlpe0nD64
%
% close all;
% clear all;
% clc;
%
% I = imread('kobi.png');
% Im = rgb2gray(I);
%
% noisy = imnoise(Im, 'salt & pepper',0.1);
%
% [m,n] = size(noisy);
%
% output = zeros(m,n);
% output = uint8(output);
%
% for i = 1:m
%     for j = 1:n  %intesity of pixel in the noisy image is given as noisy(i,j)
%         % here we define max and minimum values x and y coordinates of any
%         % pixel can take
%         xmin = max(1,i-1); % minimum x coordinate has to be greater than or equal to 1
%         xmax = min(m,i+1);
%         ymin = max(1,j-1);
%         ymax = min(n,j+1);
%         % the neighbourhood matrix will then be
%         temp = noisy(xmin:xmax, ymin:ymax);
%         %now the new intensity of pixel at (i,j) will be median of this
%         %matrix
%         output(i,j) = median(temp(:));
%     end
% end
%
% figure(1);
% set(gcf, 'Position', get(0,'ScreenSize'));
% subplot(131),imshow(I),title('Original Image');
% subplot(132),imshow(noisy),title('noisy Image');
% subplot(133),imshow(output),title('output of median filter');

end

