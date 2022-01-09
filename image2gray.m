function I_out = image2gray(I_in)
    % function only works with 3D-uint8 arrays, as other datatypes are not
    % needed in this program.
    I_out = zeros(size(I_in,1), size(I_in,2), 'uint8');
    
    % take the 3-dimension value (= RGB values) of every 2D element (=
    % pixels) and calculate the mean value. Place this value in the
    % corresponding spot (= pixel) in the new array.
    for i = 1:size(I_in,1)
        for j = 1:size(I_in,2)
            I_out(i,j) = mean(I_in(i,j,:));
        end
    end
end