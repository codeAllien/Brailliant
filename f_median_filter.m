% Author Giulia
function I_out = f_median_filter(I)
    [r c] = size(I);
    Rep = zeros(r + 2, c + 2);
    for x = 2 : r + 1
        for y = 2 : c + 1
         Rep(x,y) = I(x - 1, y - 1);
        end
    end
    B = zeros(r, c);
    for x = 1 : r
        for y = 1 : c
            for i = 1 : 3
                for j = 1 : 3
                    q = x - 1;     w = y -1;
                    array((i - 1) * 3 + j) = Rep(i + q, j + w);
                end
            end
            B(x, y) = median(array(:));
        end
    end
    I_out = uint8(B);
end
