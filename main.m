% % % ****************************************
% % % *****************Max********************
% % % ****************************************

clc
clear variables
close all

BW = imread('img_resource/blog.jpg');

imshow(BW,"Parent",gca)

pos = customWait(drawpolygon('Position',[0.5 0.5; 0.5 100.5; 100.5 100.5;100.5 0.5;]));

[height, width,color] = size(BW);

% pos = [posRel(:,1) * width,posRel(:,2) * height]

orig = [0 0; 0 height; width height ; width 0];


H = invert(fitgeotrans(orig,pos,'projective'));
J = imwarp(BW,H,'OutputView',imref2d(size(BW)));
imshow(J)


BW = im2gray(J);
BW = medfilt2(BW,[5,5]);
BW = imgaussfilt(BW,5); % smoth img


binaryThreshhold = 0.5;
BW = imbinarize(im2gray(BW),binaryThreshhold);


BW = medfilt2(BW,[5,5]);



CC = bwconncomp(BW);


numPixels = cellfun(@numel,CC.PixelIdxList);


[biggest,idx] = max(numPixels);

pixels = CC.PixelIdxList{[numPixels > 10]};

BW(pixels) = 0;

figure;
imshow(BW);

% og = BW
%
% se = strel('disk',5); % sphere
% for i=0:2
% BW = imdilate(BW, se);
% BW = imerode(BW, se);
% end

% figure;
% montage([og, BW]);
figure;
imshow(BW);

% % % ****************************************
% % % ***************ADRIAN*******************
% % % ****************************************

% Bild wird auf der Variable I bearbeitet und gespeichert

% Bild einlesen

E = edge(BW);
[centers, radii, metric] = imfindcircles(E, [6, 50])

imshow(BW);
viscircles(centers, radii);

deviationPercent = 0.05;

originPoints = 0;
countOrigins = 0;
for i = 1:size(centers,1)
    
    % search for 2 points in the same horizontal line
    countHoriz = 0;
    horiz1 = 0;
    horiz2 = 0;
    for j = 1:size(centers,1)
        deviation = abs(centers(j,1)-centers(i,1))*deviationPercent;
        if (centers(i,2) < centers(j,2)+deviation && centers(i,2) > centers(j,2)-deviation)
            countHoriz=countHoriz+1;
            if(countHoriz == 1 && horiz1 ~= 0)
                horiz1 = centers(j,2);
            end
            if(countHoriz == 2)
                horiz2 = centers(j,2);
                break
            end
        end
    end
    
    % search for a point in the same vertical line
    vert = 0;
    for j = 1:size(centers,1)
        deviation = abs(centers(j,2)-centers(i,2))*deviationPercent;
        if(centers(i,1) < centers(j,1)+deviation && centers(i,1) > centers(j,1)-deviation)
            vert = 1;
            break
        end
    end
    
    if (countHoriz == 2 && vert == 1)
        if(originPoints == 0)
            originPoints = [centers(i,:), radii(i)];
        else
            originPoints = [originPoints;centers(i,:), radii(i)];
        end
    end
    
end
originPoints

horizLines = 0;
% search for similar horizontal alignment between originPoints and count
% similar lines in horizLines
for i = 1:size(originPoints,1)
    for j = 1:size(originPoints:1)
        % check for similar lines
        if(i~=j && originPoints(i,1) < originPoints(j,1)+(originPoints(j,3)*1.5) ...
                && originPoints(i,1) > originPoints(j,1)-(originPoints(j,3)*1.5))
            
            % if empty, create new line
            if(horizLines == 0)
                horizLines = [originPoints(i,1),i, 1];
            else
                added = false;
                % if line already in horizLines add to count
                for k = 1:size(horizLines,1)
                    
                    if(horizLines(k,1) < originPoints(i,1)+(originPoints(i,3)*1.5) ...
                            && horizLines(k,1) > originPoints(i,1)-(originPoints(i,3)*1.5))
                        horizLines(k,3) = horizLines(k,3)+1;
                        added = true;
                        break
                    end
                end
                % else add new line to horizLines
                if (added == false)
                    horizLines = [horizLines;originPoints(i,1),i,1];
                end
            end
        end
    end
end
horizLines

% get originPoint of horizontalLine with most originPoint alignments
highestCount = 0;
highestPointIndex = 0;

for i = 1:size(horizLines,1)
    if(highestCount<horizLines(i,3))
        highestCount = horizLines(i,3);
        highestIndex = horizLines(i,2);
    end
    
end
gridOrigin = originPoints(highestIndex,:)




pointsInLine = gridOrigin;
pointsInGrid = [gridOrigin,1];
for i = 1:size(centers,1)
    deviation = abs(gridOrigin(1,1)-centers(i,1))*deviationPercent;
    if(gridOrigin(1,2)<centers(i,2)+deviation && gridOrigin(1,2)>centers(i,2)-deviation)
        pointsInGrid = [pointsInGrid;centers(i,:),radii(i),1];
    end
end
lowestDiff = size(BW,1);
% for i = 1:size(pointsInGrid,1)
%     for j = 1:size(pointsInGrid)
%         if(i~=j)
%             if()
%         end
%     end
% end
characterPointDistance = lowestDiff

pointsInGrid
pointsInGrid(:,1:2)

imshow(BW)
% viscircles(gridOrigin(:,1:2), gridOrigin(:,3))
viscircles(pointsInGrid(:,1:2), pointsInGrid(:,3));

viscircles(centers, radii)

% imshow(viscircles(centers, radii));

% % % Übersetzung in "Binär"
% % % Durch Vertikalen & Horizontale Projektion Z.B.

% BINÄR CODE
% 11    ".."
% 01    " ."
% 10    ". "
% 00    "  "

% % % ****************************************
% % % ***************FELIX********************
% % % ****************************************

braille_code = ["100000" "101000" "110000"];
result = braille_translate(braille_code ,"german");

% % % ****************************************
% % % ***************FUNCTION*****************
% % % ****************************************
function pos = customWait(hROI)

% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);
% Return the current position
pos = hROI.Position;
%pos(:,1) = (pos(:,1) - hROI.Parent.XLim(1)) / (hROI.Parent.XLim(2) - hROI.Parent.XLim(1));
%pos(:,2) = (pos(:,2) - hROI.Parent.YLim(1)) / (hROI.Parent.YLim(2) - hROI.Parent.YLim(1));

end

function clickCallback(~,evt)

if strcmp(evt.SelectionType,'double')
    uiresume;
end

end