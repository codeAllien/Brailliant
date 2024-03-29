function I = image_processing(I)

show_steps = 0;
keep_steps = 0;

% % Select Braille area on img
imshow(I);
selected_area = customWait(drawrectangle('Label','Select Braille'));
I = imcrop(I, selected_area);
% Resize image to a minimum
[height, width] = size(I);
if min([height, width]) < 300
    I = imresize(I, 500/height);
end

[height, width] = size(I);

% % Display Selected Area
display_result(I, 'Selected Area', show_steps, keep_steps);

% % Grayscale
I = im2gray(I);
display_result(I, 'Gray Scale', show_steps, keep_steps);

% % Stretch Contrast (maximise it)
I = imadjust(I);
display_result(I, 'Contrast Stretching', show_steps, keep_steps);

% Contrast Stretching
% q_min = min(min(BW(:)))
% q_max = max(max(BW(:)))
% BW(:,:) = (1-0)*(BW(:,:)-q_min)./(q_max - q_min)+0;

corner_fix = I;

% % Median Filter
 I =  f_median_filter(I);
 display_result(I, 'Median Filter', 1, 1);

% % Restore Corners broken by median filter
I(I < 0.5) = corner_fix(I < 0.5);
display_result(I, 'Fixed Corners', show_steps, keep_steps);

% % Gaussian Filter
filter_size = 5;
I = f_gauss_filter(I, filter_size, 1.76);
display_result(I, 'Gaussian Filter', 1, 1);


% % Binarise Image
t = 0.4;
I_inverted = create_binary(imcomplement(I), t);
I = create_binary(I, t);

% Determin the optimal binarisation
difference = abs(sum(I(:) == 1) - sum(I(:) == 0));
difference_inverted = abs(sum(I_inverted(:) == 1) - sum(I_inverted(:) == 0));

if difference < difference_inverted
    I = I_inverted;
end

display_result(I, 'Binarise Image', show_steps, keep_steps);


% Ensure that the dots are white
if sum(I(:) == 1) > sum(I(:) == 0)
    I = imcomplement(I);
    display_result(I, 'Filters + Inverted', show_steps, keep_steps);
end

% Budget border
I = imrotate(I, 1);
I = imrotate(I, -1);

% % Optimise Image
s = regionprops(I,'BoundingBox');
bbox = cat(1,s.BoundingBox);

display_result(I, 'Detected Areas', show_steps, keep_steps);
boxsizes = zeros(size(bbox, 1), 1);
for i=1:size(bbox,1)
    if show_steps
        rectangle('Position',[bbox(i,1) bbox(i,2) bbox(i,3) bbox(i,4)],'EdgeColor','r');
    end
    boxsizes(i) = bbox(i,3)/2;
end

med_size = mean(boxsizes(:))/5

% % Optimise Blobs and remove small ones / errors
I = erode_and_dialate(I, med_size, round(med_size));

display_result(I, 'Eroded and Dialated Image', show_steps, keep_steps);


% % Visualise the differences between the two images
% % Remove for Performance Optimization
% temp = I;
% 
% temp(temp(:)==1) = 255;
% temp(temp(:)==1) = 255;
% 
% difference_image = ~temp & temp;
% 
% result = cat(3, difference_image, zeros(size(I)), temp);
% display_result(difference_image, 'Test', show_steps, keep_steps);
% 
% display_result(result, 'Colored Differences', show_steps, keep_steps);

% % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % FUNCTIONS % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % %

% % User Area Selection
    function pos = customWait(hROI)
        % Listen for mouse clicks on the ROI
        l = addlistener(hROI,'ROIClicked',@clickCallback);
        
        % Block program execution
        uiwait;
        
        % Remove listener
        delete(l);
        % Return the current position
        pos = hROI.Position;
        
        
        function clickCallback(~,evt)
            if strcmp(evt.SelectionType,'double')
                uiresume;
            end
        end
        
    end

% % Binary Image
    function return_image = create_binary(I, level)
        return_image = true(size(I));
        return_image(I <= max(I)*level) = 0;
    end

% % Image Output
    function display_result(I, caption, show_steps, keep_steps)
        if show_steps
            if keep_steps
                figure;
            end
            imshow(I);
            title(caption);
        end
    end

% % Blob Modification
    function I = erode_and_dialate(I, size, times)
        for a=1:times
            I = f_erode(I, 'circle', round(size));
            I = f_dialate(I, 'circle', round(size));
        end
    end
end