function result = f_erode(I, type, radius)
if ~islogical(I)
    throw(MException('f_erode:invalidInput', ...
        'Input Image is not a logical Image'));
end

result = I;
M = get_errode_matrix(type, radius);

for o_x = 1:size(I, 1) % original_x
    for o_y = 1:size(I, 2) % original_y
        if I(o_x, o_y) % if original_x & y are a true value dialate image
            s_x = (size(M, 1)-1)/2; % start_x
            s_y = (size(M, 2)-1)/2; % start_y
            for n_x = 0:size(M, 1)-1 % new_x
                if ~result(o_x, o_y)
                    result(o_x, o_y) = 0;
                    break
                end
                x_pos = (o_x + n_x) - s_x;
                if x_pos <= 0 | x_pos > size(I, 1) % check if area is outside image boundaries 
                    continue
                end
                for n_y = 0:size(M, 2)-1 % new_y
                    y_pos = (o_y + n_y) - s_y;
                    if y_pos <= 0 | y_pos > size(I, 2) | ~M(n_x + 1, n_y + 1) % check if area is outside image boundaries
                        continue
                    end
                    result(o_x, o_y) = I(x_pos, y_pos) & M(n_x + 1, n_y + 1);
                end
            end
        end
    end
end
% figure;
% image(M) ;
% colormap([0 0 0; 1 1 1]);
% title('Binary image of a circle');
% axis square;
% figure;
% imshow(cat(2,  I, ones(size(I, 1), 1), result));
result = logical(result);

    function M = get_errode_matrix(type, radius)
        M = 1;
        switch(type)
            case {'square', ''}
                M = ones(radius(1)*2+1);
            case {'circle', 'diamound'}
                % https://de.mathworks.com/matlabcentral/answers/495387-how-to-create-a-filled-circle-within-a-matrix
                
                % Create a logical image of a circle with specified
                % diameter, center, and image size.
                [columns, rows] = meshgrid(1:radius(1)*2+1, 1:radius(1)*2+1);
                center = radius(1)+1;
                if type == "circle"
                    M = (rows - center).^2 + (columns - center).^2 <= radius(1)^2;
                else
                    M = abs((rows - center)) + abs((columns - center)) <= radius(1);
                end
            case 'rectangle'
                if size(radius, 2) <= 2
                    M = ones(radius(1)*2+1, radius(2)*2+1);
                else
                    M = ones(radius(1)*2+1);
                end
        end
    end
end