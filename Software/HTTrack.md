# HTTrack - Website copier

* [HTTrack](https://www.httrack.com/)

```bash
# Not needed: httrack
sudo apt -y install webhttrack
```

Start HTTrack in Browser:

* Start > WebHTTrack
* Language preference > English
* Next

Select Project:

* Select a existing or create new project: website_www
* Base path: Set Download directory: /home/cyb10101/websites
* Next

Select Urls:

* Action: Download web sites(s)
* Add url: https://example.org
* Preferences and mirror options > Set options

Set options:

* Build > Structure type = ISO9960 names (CDROM)
* Flow Control > N# connections = 8
* Limits > Max transfer rate = 250000
* Browser ID > HTML-Footer = None (Clear field)

* Scan rules:

```text
+*.css +*.js -ad.doubleclick.net/* -mime:application/foobar
+*.gif +*.jpg +*.jpeg +*.png +*.tif +*.bmp
+*.zip +*.tar +*.tgz +*.gz +*.rar +*.z +*.exe
+*.mov +*.mpg +*.mpeg +*.avi +*.asf +*.mp3 +*.mp2 +*.rm +*.wav +*.vob +*.qt +*.vid +*.ac3 +*.wma +*.wmv
```

* Scan rules - Exclude something:

```text
-example.org/de/build/search*
-example.org/en/build/search*
-example.org/*/search*
```

* Save with "OK"
* Next
* Start
