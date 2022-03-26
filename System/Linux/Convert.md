# Convert

Requirements:

```bash
sudo apt -y install ffmpeg faac faad flac lame libmad0 libmpcdec6 mppenc vorbis-tools wavpack
```

## Audio

```bash
for file in ./*.m4a; do avconv -i "${file}" "${file/%m4a/mp3}";	done

# Static bitrate
lame -q 2 -b 320  -F file.wav file.mp3

# Variable bitrate
lame -q 2 -b 128 -m j -V 1 -B 320 -F file.wav file.mp3

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

## Convert svg to ico

Convert filename.svg to filename.ico.

*Keywords: favicon*

```bash
sudo apt -y install inkscape imagemagick

generateFaviconFromSvg favicon.svg

# Magick version 7 untested
# magick -density X -colorspace sRGB file.svg -background white -gravity center -extent "%[fx:max(w,h)]x%[fx:max(w,h)]" result.png

# Magick version 6
generateFaviconFromSvg() { \
    local file="${1}"; \
    local folder=`mktemp -d /tmp/favicon_XXXXXXXX`; \
    maxSize=$(convert -density X -colorspace sRGB "${file}" -format "%[fx:max(w,h)]" info:); \
    convert -density X -background transparent -colorspace sRGB "${file}" -gravity center -extent ${maxSize}x${maxSize} -resize 16x16 "${folder}/16.png"; \
    convert -density X -background transparent -colorspace sRGB "${file}" -gravity center -extent ${maxSize}x${maxSize} -resize 32x32 "${folder}/32.png"; \
    convert -density X -background transparent -colorspace sRGB "${file}" -gravity center -extent ${maxSize}x${maxSize} -resize 32x32 "${folder}/32.png"; \
    convert "${folder}/16.png" "${folder}/32.png" "${folder}/48.png" "${file/%svg/ico}"; \
    echo 'Convert info:'; \
    identify "${file/%svg/ico}"; \
}

# Inkscape
generateFaviconFromSvg() { \
    local file="${1}"; \
    local folder=`mktemp -d /tmp/favicon_XXXXXXXX`; \
    inkscape -w 16 -h 16 -e "${folder}/16.png" "${file}"; \
    inkscape -w 32 -h 32 -e "${folder}/32.png" "${file}"; \
    inkscape -w 48 -h 48 -e "${folder}/48.png" "${file}"; \
    convert "${folder}/16.png" "${folder}/32.png" "${folder}/48.png" "${file/%svg/ico}"; \
    echo 'Convert info:'; \
    identify "${file/%svg/ico}"; \
}
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