function I_out = gauss_filter(I,N,sigma)
    % Rework the value inside the matrix image
    I = double(I);

    %Window size
    sz = 5;
    [x,y]=meshgrid(-sz:sz,-sz:sz);

    %Design the Gaussian Kernel
    M = size(x,1)-1;
    N = size(y,1)-1;
    Exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
    Kernel= exp(Exp_comp)/(2*pi*sigma*sigma);

    %Initialize output matrix
    I_out=zeros(size(I));

    %Pad the vector with zeros
    I = padarray(I,[sz sz]);

    %Convolution
    for i = 1:size(I,1)-M
        for j =1:size(I,2)-N
            Temp = I(i:i+M,j:j+M).*Kernel;
            I_out(i,j)=sum(Temp(:));
        end
    end
    
    I_out = uint8(I_out);
end


 