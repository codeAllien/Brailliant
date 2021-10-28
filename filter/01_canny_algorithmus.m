% output of this function is canny_output
classdef canny_output
fuction canny_output = canny_algorithmus(img)
    canny_output = edge(img,'Canny');
    % canny_output = edge(img,'Prewitt');
end