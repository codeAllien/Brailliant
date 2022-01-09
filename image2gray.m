function I_out = image2gray(I_in)
    I_out = zeros(size(I_in,1), size(I_in,2), 'uint8');
    
    for i = 1:size(I_in,1)
        for j = 1:size(I_in,2)
            I_out(i,j) = mean(I_in(i,j,:));
        end
    end
end