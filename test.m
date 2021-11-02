I = imread('circuit.tif');

imshow(I)
 
BW1 = edge(I,'Canny');
BW2 = edge(I,'Prewitt');

imshowpair(BW1,BW2,'montage')
