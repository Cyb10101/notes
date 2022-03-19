# Convert

Requirements:

```bash
sudo apt -y install ffmpeg
```

## Audio

```bash
for file in ./*.m4a; do avconv -i "${file}" "${file/%m4a/mp3}";	done

avconv -i "${file}" "${file/%wav/ogg}"
avconv -i "${file}" "${file/%wav/mp3}"
avconv -i "${file}" "${file/%ogg/mp3}"
avconv -i "${file}" -acodec libvorbis "${file/%mp3/ogg}"
```

## Midi to MP3

```bash
sudo apt-get install timidity fluid-soundfont-gm fluid-soundfont-gs
for file in ./*.mid; do timidity "${file}" -Ow -o - | lame - -b 192 "${file/%mid/mp3}"; done
```

## Video to 720p

```bash
ffmpeg -i movie.mkv -vf scale=-1:720 movie_720p.mkv
```

## Picture to thumbnail

```bash
width=200
height=300

mkdir convert
for file in ./*.jpg; do
	convert -resize $widthx$height "$file" "convert/$file.png"
	#convert -type Grayscale bild.jpg bild.eps
	#convert -quality 80 bild.bmp bild.jpg
done
for file in ./*.png; do
	convert -resize $widthx$height "$file" "convert/$file.png"
done
```
