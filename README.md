# Brailliant (EDB WS21)
Felix Teutsch | Giulia Gallico | Max Bambasek | Adrian Kurzbauer | Marc Putz

## Setup
* Installation von Matlab R2021_b
* Installieren Sie das **Image Processing Toolbox Plugin**, damit das Bild in dem GUI gelesen und angezeigt wird.
* Installieren Sie das **Statistics and Machine Learning Toolbox Plugin**, so dass der K-Means Algorithmus ausgeführt werden kann.

## Anleitung
1. Öffnen Sie das Programm mit Matlab R2021b und starten Sie die Klasse *main.m* mittels den Befehl *Run*.
2. Das Bild wird geöffnet und ein Auswahlrechteck kann mit dem Cursor per Klick und Drag & Drop gezogen werden. Sie können das Auswahlfeld verschieben, vergrößern und verkleinern.
4. Doppelklicken Sie auf das Auswahlfeld, um die Größe des Fotos zu ändern, und das Bild wird nun von der *Pipeline* verarbeitet.
5. Als Ergebnis wird der ausgewählte Text ins Deutsche übersetzt.

## Projektbeschreibung
Dieses Projekt entstand aus der Idee heraus, Angehörigen und Bekannten von Sehbeeinträchtigten das Lesen von Büchern in Braille zu ermöglichen, indem sie in das deutsche Alphabet übersetzt werden.

Die Bilder werden nach folgendem Pipeline verarbeitet, so dass jedes Bild von der Brailleschrift ins Deutsche übersetzt werden können.

### Pipeline:
* Bild Zuscheiden und Transformieren
* Grauwert und Schwellwert Filter
* Rauschunterdrückung mit Mittelwert- und Gauss-Filter
* Clusterfilterung
* Auslesen der Braille Punkte
* Braille Übersetzung

## Literatur
[File Select Dialog](https://kr.mathworks.com/help/matlab/ref/uigetfile.html?searchHighlight=uigetfil)  
[Cut IMG](https://de.mathworks.com/help/images/ref/imcrop.html?searchHighlight=imcrop)  
[Resize IMG](https://de.mathworks.com/help/matlab/ref/imresize.html?searchHighlight=imresize)  
[Gauß-Filter um rauschen zu entfernen](https://de.mathworks.com/help/images/ref/fspecial.html?searchHighlight=fspecial)  
[Empfehlung von Matlab](https://de.mathworks.com/help/images/ref/imgaussfilt.html) oder [link here](https://de.mathworks.com/help/images/ref/imgaussfilt3.html)  
[Kontrast](https://de.mathworks.com/help/images/ref/imadjust.html?s_tid=srchtitle)  
[Binärebild machen](https://de.mathworks.com/help/images/ref/im2bw.html?searchHighlight=im2bw) oder [von Matlab empfohlen](https://de.mathworks.com/help/images/ref/imbinarize.html)  
[Objekte auflisten](https://de.mathworks.com/help/images/ref/bwlabel.html?searchHighlight=bwlabel)  
[Objekt-schwerpunkte finden](https://de.mathworks.com/help/images/ref/regionprops.html?searchHighlight=regionprops)  
[Rechtek zeichnen](https://de.mathworks.com/help/matlab/ref/rectangle.html?searchHighlight=rectangle)  
[K-Means-Clustering methode zum Filtern der Objekte](https://de.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans)  
[Objekte Sortieren](https://de.mathworks.com/help/matlab/ref/double.sortrows.html?searchHighlight=sortrows)  
[Bild Rotieren](https://de.mathworks.com/help/images/ref/imrotate.html?searchHighlight=imrotate)  
