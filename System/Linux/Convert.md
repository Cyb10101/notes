# Convert

Requirements:

```bash
sudo apt -y install ffmpeg faac faad flac lame libmad0 libmpcdec6 mppenc vorbis-tools wavpack
```

## Image

```bash
# Vertical sprite
convert image1.png image2.png image3.png -append result.png

# Horizontal sprite
convert image1.png image2.png image3.png +append result.png
```

## Audio

```bash
for file in ./*.m4a; do ffmpeg -i "${file}" "${file/%m4a/mp3}"; done

# Static bitrate
lame -q 2 -b 320  -F file.wav file.mp3

# Variable bitrate
lame -q 2 -b 128 -m j -V 1 -B 320 -F file.wav file.mp3

ffmpeg -i "${file}" "${file/%wav/ogg}"
ffmpeg -i "${file}" "${file/%wav/mp3}"
ffmpeg -i "${file}" "${file/%ogg/mp3}"
ffmpeg -i "${file}" -acodec libvorbis "${file/%mp3/ogg}"
```

## Audio from Stereo to Mono

ffmpeg -i stereo.mp4 -vc copy -ac 1 mono.mp4

## Midi to MP3

```bash
sudo apt-get install timidity fluid-soundfont-gm fluid-soundfont-gs
for file in ./*.mid; do timidity "${file}" -Ow -o - | lame - -b 192 "${file/%mid/mp3}"; done
```

## Video

```bash
for file in ./*.mkv; do ffmpeg -i "${file}" "${file/%mkv/mp4}"; done
for file in ./*.mov; do ffmpeg -i "${file}" "${file/%mov/mp4}"; done

ffmpeg -i video.mkv video.mp4
ffmpeg -i video.mov video.mp4
```

## Video to 720p

```bash
ffmpeg -i movie.mkv -vf scale=-1:720 movie_720p.mkv
```

## Cut Video

```bash
ffmpeg -i original.mp4 -ss 00:00:23 -c copy cutted.mp4
```

## 3D to 2D

```bash
# Side by side 3D (left and right) to 2D
ffmpeg -i input.mkv -vf stereo3d=sbsl:ml -metadata:s:v:0 stereo_mode="mono" -aspect 16:9 output.mkv
```

## Rotate Video

```bash
# 90 Counter Clockwise and Vertical Flip (default)
ffmpeg -i in.mp4 -vf "transpose=0" out.mp4

# 90 Clockwise
ffmpeg -i in.mp4 -vf "transpose=1" out.mp4

# 90 Counter Clockwise
ffmpeg -i in.mp4 -vf "transpose=2" out.mp4

# 90 Clockwise and Vertical Flip
ffmpeg -i in.mp4 -vf "transpose=3" out.mp4

# Flip the input video horizontally
ffmpeg -i in.mp4 -vf "hflip" out.mp4
```

## Merge video & audio

```bash
ffmpeg -i video.mp4 -i audio.mp4 -c copy output.mp4
ffmpeg -i video.mp4 -i audio.mp4 -c copy output.mkv
```

## Combine *.ts/m4s to audio or video

```bash
#for i in {0..3}; do curl -fsSL "https://example.org/file${i}.ts" -o "file${i}.ts"; cat "file${i}.ts" >> merged.ts; done

for i in {0..3}; do curl -fsSL "https://example.org/file${i}.ts" >> merged.ts; done

ffmpeg -i merged.ts video.mp4
ffmpeg -i merged.ts audio.mp3
```

## Combine *.m4s (Servus TV)

See playlist.m3u8:

```text
Audio: #EXT-X-MEDIA:TYPE=AUDIO,URI="https://host/audio.m3u8"
Video: #EXT-X-STREAM-INF:RESOLUTION=1920x1080,{new line} https://host/video.m3u8
```

```bash
mkdir audio video

# Audio
grep 'https://' audio.m3u8 > audio/download.txt
cd audio && aria2c -i download.txt
cat init.mp4 >> merged.m4s; for i in {0..952}; do cat "${i}.m4s" >> merged.m4s; done
cd ..

# Video
grep 'https://' video.m3u8 > video/download.txt
cd video && aria2c -i download.txt
cat init.mp4 >> merged.m4s; for i in {0..952}; do cat "${i}.m4s" >> merged.m4s; done
cd ..

ffmpeg -i video/merged.m4s -i audio/merged.m4s -c copy output.mp4
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
