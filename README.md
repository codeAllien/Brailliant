# Brailliant (EDB WS21)
Felix Teutsch | Giulia Gallico | Max Bambasek | Adrian Kurzbauer | Marc Putz

## Setup
* Installation von Matlab R2021_b
* Installieren Sie das **Image Processing Toolbox Plugin**, damit Sie auf dem Bild zeichnen und die Größe des Bildes ändern können.

## Projektbeschreibung
Dieses Projekt entstand aus der Idee heraus, Angehörigen und Bekannten von Sehbeeinträchtigten das Lesen von Büchern in Braille zu ermöglichen, indem sie in das deutsche Alphabet übersetzt werden.

### Pipeline:
* Bild Zuscheiden und Transformieren
* Grauwert und Schwellwert Filter
* Rauschunterdrückung mit Mittelwerts Filter
* Clusterfilterung
* Auslesen der Braille Punkte
* Braille Übersetzung

## Literatur
[File Select Dialog](https://kr.mathworks.com/help/matlab/ref/uigetfile.html?searchHighlight=uigetfil)  
[Cut IMG](https://de.mathworks.com/help/images/ref/imcrop.html?searchHighlight=imcrop)  
[Resize IMG](https://de.mathworks.com/help/matlab/ref/imresize.html?searchHighlight=imresize)  
[Gauß-Filter um rauschen zu entfernen](https://de.mathworks.com/help/images/ref/fspecial.html?searchHighlight=fspecial)  
[Empfehlung von Matlab](https://de.mathworks.com/help/images/ref/imgaussfilt.html)  
oder [link here](https://de.mathworks.com/help/images/ref/imgaussfilt3.html)  
[Kontrast](https://de.mathworks.com/help/images/ref/imadjust.html?s_tid=srchtitle)  
[Binärebild machen](https://de.mathworks.com/help/images/ref/im2bw.html?searchHighlight=im2bw)  
[Binärebild machen von Matlab empfohlen](https://de.mathworks.com/help/images/ref/imbinarize.html)  
[Objekte auflisten](https://de.mathworks.com/help/images/ref/bwlabel.html?searchHighlight=bwlabel)  
[Objekt-schwerpunkte finden](https://de.mathworks.com/help/images/ref/regionprops.html?searchHighlight=regionprops)  
[Rechtek zeichnen](https://de.mathworks.com/help/matlab/ref/rectangle.html?searchHighlight=rectangle)  
[K-Means-Clustering methode zum Filtern der Objekte](https://de.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans)  
[Objekte Sortieren](https://de.mathworks.com/help/matlab/ref/double.sortrows.html?searchHighlight=sortrows)  
[Bild Rotieren](https://de.mathworks.com/help/images/ref/imrotate.html?searchHighlight=imrotate)  
