function I_out = image2gray(I_in)
    % Efficient Matlab version with matrix operations:
    I_out = (I_in(:,:,1) .* 0.2989 + I_in(:,:,2) .* 0.5870 + I_in(:,:,3) .* 0.1140)./3.0;
    % Based on: https://de.mathworks.com/help/matlab/ref/rgb2gray.html#buiz8mj-9
end
