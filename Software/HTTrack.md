# HTTrack - Website copier

https://www.httrack.com/

```bash
sudo apt install webhttrack
```

Struktur > ISO9960-Namen (CDROM)

* Site-Kopie > Optionen ändern
	- Grenzwerte > Maximale übertragungsrate = 250000
	- FlussKontrolle > Anzahl Verbindungen = 8
	- Browser ID > HTML-Fußzeile > (none)

AcceptLanguage=de, en, *

Filterregeln:

```text
+*.css +*.js -ad.doubleclick.net/* -mime:application/foobar
+*.gif +*.jpg +*.jpeg +*.png +*.tif +*.bmp
+*.zip +*.tar +*.tgz +*.gz +*.rar +*.z +*.exe
+*.mov +*.mpg +*.mpeg +*.avi +*.asf +*.mp3 +*.mp2 +*.rm +*.wav +*.vob +*.qt +*.vid +*.ac3 +*.wma +*.wmv
-domain.de/de/build/search*
-domain.de/en/build/search*
-domain.de/*/search*
```
