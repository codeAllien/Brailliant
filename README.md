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
[Idee aus dem Blog 1](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=22wowow22&logNo=220819500053)  
[Idee aus dem Blog 2](https://homepages.inf.ed.ac.uk/rbf/HIPR2/stretch.htm)  
[GitHub Project](https://github.com/mitzsu/Braille-Matlab) 
[Graufilter](https://de.mathworks.com/help/matlab/ref/rgb2gray.html#buiz8mj-9)  
[Matlab K-Menas](https://de.mathworks.com/matlabcentral/fileexchange/24616-kmeans-clustering?s_tid=FX_rc2_behav)  
[Mittelwert-Filter](https://de.mathworks.com/matlabcentral/answers/36182-how-to-do-median-filter-without-using-medfilt2)  
[Gauß-Filter](https://stackoverflow.com/questions/13193248/how-to-make-a-gaussian-filter-in-matlab/13205520)  
