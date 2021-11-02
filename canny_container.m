% source: https://youtu.be/mdcp72epXWw
classdef canny_container
    methods(Static)
        function canny_output = canny_edge_detection(img, display_steps)
            
            % Preprocessing - Median filter
            p=1; % 1 default
            pad=uint8(zeros(size(img)+2*(p-1)));
            
            for x=1:size(img, 1)
                for y=1:size(img, 2)
                    pad(x+p-1, y+p-1) = img(x, y);
                end
            end
            
            for i=1:size(pad, 1)-(p-1)
                for j=1:size(pad, 2)-(p-1)
                    kernel = uint8(ones((p)^2, 1));
                    t=1;
                    for x=1:p
                        for y=1:p
                            kernel(t) = pad(i+x-1, j+y-1);
                            t = t+1;
                        end
                    end
                    filt = sort(kernel);
                    out(i,j) = filt(ceil(((p)^2)/2));
                end
            end
            
            if display_steps
                canny_container.display_steps(out, 'Median Filtered');
            end
            
            img = double(img);
            [counts, x] = imhist(out, 16);
            T1 = otsuthresh(counts);
            
            % Value for Tresholding
            T_Low = 0.063; % 0.063
            T_High = T1 * 0.06; % 0.01
            
            % Gaussian Filter Coefficient
            B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4; 5, 12, 15, 12, 5; 4, 9, 12, 9, 4; 2, 4, 5, 4, 2];
            B = 1/159. * B;
            
            % Convolution of image by Gaussian Coefficient
            A1 = conv2(img, B, 'same');
            
            % Filter for horizontal and vertical direction
            KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
            KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];
            
            % Convolution of image by horizontal and vertical filter
            Filtered_X = conv2(A1, KGx, 'same');
            Filtered_Y = conv2(A1, KGy, 'same');
            
            % Calculate directions / orientations
            arah = atan2 (Filtered_Y, Filtered_X);
            arah = arah * 180 / pi;
            
            pan = size(A1, 1);
            leb = size(A1, 2);
            
            % Adjustment for negative directions, making all directions positive
            for i=1:pan
                for j=1:leb
                    if(arah(i, j)<0)
                        arah(i, j) = 360 + arah(i, j);
                    end
                end
            end
            
            arah2 = zeros(pan, leb);
            
            %Adjusting directions to nearest 0, 45, 90 or 135 degree
            for i=1:pan
                for j=1:leb
                    if ((arah(i, j) >= 0) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) < 0))
                        arah2(i, j) = 0;
                    elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) > 247.5))
                        arah2(i, j) = 45;
                    elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
                        arah2(i, j) = 90;
                    elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
                        arah2(i, j) = 135;
                    end
                end
            end
            
            if display_steps
                figure;
                imagesc(arah2);
                colorbar;
                title('Direction adjust');
            end
            
            % Calculate magnitude
            magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
            magnitude2 = sqrt(magnitude);
            
            BW = zeros(pan, leb);
            
            % Non-Maximum Supression
            for i=2:pan-1
                for j=2:leb-1
                    if(arah2(i, j)==0)
                        BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i, j+1), magnitude2(i, j-1)]));
                    elseif(arah2(i, j) == 45)
                        BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j-1), magnitude2(i-1, j+1)]));
                    elseif(arah2(i, j) == 90)
                        BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j), magnitude2(i-1, j)]));
                    elseif(arah2(i, j) == 135)
                        BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j+1), magnitude2(i-1, j-1)]));
                    end
                end
            end
            
            BW = BW.*magnitude2;
            
            if display_steps
                canny_container.display_steps(BW, 'Non-Maximum Supression');
            end
            
            % Hysteresis Thresholding
            T_Low = T_Low * max(max(BW));
            T_High = T_High * max(max(BW));
            
            T_res = zeros(pan, leb);
            
            for i=1:pan
                for j=1:leb
                    if(BW(i, j) < T_Low)
                        T_res(i, j) = 0;
                    elseif(BW(i, j) > T_High)
                        T_res(i, j) = 1;
                        % Using 8-Connected components
                    elseif(BW(i+1, j) > T_High || BW(i-1, j) > T_High || BW(i, j+1) > T_High || BW(i, j-1) > T_High || BW(i+1, j+1) > T_High || BW(i-1, j-1) > T_High)
                        T_res(i, j) = 1;
                    end
                end
            end
            
            edge_final = uint8(T_res.*255);
            
            if display_steps
                canny_container.display_steps(edge_final, 'Canny Edge Detection');
            end
            
            % Return IMG after canny operation(s)
            canny_output = edge_final;
            
        end
        function display_steps(img, name)
            figure;
            imshow(img);
            title(name);
        end
    end
end