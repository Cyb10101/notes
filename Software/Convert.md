# Convert

Requirements:

```bash
sudo apt -y install ffmpeg faac faad flac lame libmad0 libmpcdec6 mppenc vorbis-tools wavpack
```

## Image

Convert images:

```bash
for file in ./*.webp; do convert "${file}" "${file/%webp/jpg}"; done
for file in ./*.webp; do convert "${file}" "${file/%webp/png}"; done
```

Resize images:

```bash
mkdir converted
for file in ./*.jpg; do convert "${file}" -resize 2048x -quality 90% "converted/${file}"; done
```

Resize images on Windows with PowerToys:

* [PowerToys: Releases](https://github.com/microsoft/PowerToys/releases/latest)
* [PowerToys: Image resizer](https://learn.microsoft.com/de-de/windows/powertoys/image-resizer)

```shell
winget install Microsoft.PowerToys --source winget
```

Resize images on Windows with ImageMagick (resize.cmd):

```shell
@echo off
rem https://www.imagemagick.org/script/download.php#windows
rem scoop install imagemagick
cd /d "%~dp0"

set /p quality="Quality (0-100): "
set /p size="Size (2048x): "

if not exist converted (
  mkdir converted
)

for %%E in (jpeg jpg png) do (
  if exist "%~dp0.\*.%%E" (
    for /F "tokens=*" %%A IN ('DIR /B  "%~dp0.\*.%%E"') do (
      echo * %%E: %%A
      magick convert "%~dp0.\%%A" -resize %size% -quality %quality%%% "%~dp0.\converted\%%A"
    )
    echo.
  )
)
```

Generate sprites:

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
lame -q 2 -b 320 -F file.wav file.mp3

# Variable bitrate
lame -q 2 -b 128 -m j -V 1 -B 320 -F file.wav file.mp3

for file in ./*.wav; do ffmpeg -i "${file}" "${file/%wav/ogg}"; done
for file in ./*.wav; do ffmpeg -i "${file}" "${file/%wav/mp3}"; done
for file in ./*.ogg; do ffmpeg -i "${file}" "${file/%ogg/mp3}"; done
for file in ./*.mp3; do ffmpeg -i "${file}" -acodec libvorbis "${file/%mp3/ogg}"; done
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
# Convert multiple
find -type f -regextype posix-extended -iregex '.*\.(avi|mov|mp3|mp4|mpg)$' -exec sh -c 'for file; do ffmpeg -i "${file}" "${file%.*}.mkv"; done' sh {} +

# Convert files
for file in ./*.mkv; do ffmpeg -i "${file}" "${file/%mkv/mp4}"; done
for file in ./*.mov; do ffmpeg -i "${file}" "${file/%mov/mp4}"; done

# Show codec
ffprobe input.avi

# Copy do not re-encode
ffmpeg -i input.avi -c:v copy -c:a copy output.mp4
ffmpeg -i input.avi -c:v copy -c:a copy output.mkv

# Re-encode Xvid to h264
ffmpeg -i input.avi -c:a copy -c:v libx264 -crf 18 -preset slow output.mp4
ffmpeg -i input.avi -c:a copy -c:v libx264 -crf 18 -preset slow output.mkv
```

```bash
# Scale to 720p
ffmpeg -i input.mkv -vf scale=-1:720 output_720p.mkv

# Change audio volume
ffmpeg -i input.mp4 -vcodec copy -af "volume=20dB" output.mp4

# Cut Video from-to position
ffmpeg -i input.mkv -vcodec copy -acodec copy -ss 01:40:29.017 -to 02:04:26.020 output.mkv

# Cut Video after 23 seconds
ffmpeg -i input.mp4 -ss 00:00:23 -c copy output.mp4
```

## 3D to 2D

* [FFmpeg: Stereoscopic](https://trac.ffmpeg.org/wiki/Stereoscopic)
* [FFmpeg: Stereo3D](https://ffmpeg.org/ffmpeg-filters.html#stereo3d)

```bash
# Side by side 3D (left and right) to 2D
ffmpeg -i input.mkv -vf stereo3d=sbsl:ml -metadata:s:v:0 stereo_mode="mono" -aspect 16:9 output.mkv

# Above & below
ffmpeg -i input.mkv -vf stereo3d=abl:ml -metadata:s:v:0 stereo_mode="mono" -aspect 16:9 output.mkv
```

## Rotate Video

Test or change with exiftool:

```bash
# Show rotation
exiftool -rotation video.mp4

# Set rotation
exiftool -rotation=0 video.mp4
```

Transcode video:

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
# ffmpeg -i merged.ts video.mkv

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

## Download and concat from ARD Mediathek

* [MediathekViewWeb](https://mediathekviewweb.de/)
* [MediathekView](https://mediathekview.de/download/)
* [ttconv](https://pypi.org/project/ttconv/)

```bash
curl -o /tmp/MediathekView.deb -fsSL 'https://download.mediathekview.de/stabil/MediathekView-latest-linux.deb'
sudo dpkg -i /tmp/MediathekView.deb

# Convert subtitle from ttml to srt
pip install ttconv
python3 -c "import ttconv as _; print(_.__file__)"
python3 ~/.local/lib/python3.10/site-packages/ttconv/tt.py convert -i "subtitle.ttml" -o "subtitle.srt"

# Move and merge subtitle
ffprobe -v error -sexagesimal -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 video1.mp4
# 1:29:08.083000 -> 1h29m08s083ms
sudo apt -y install python3-pysrt
srt shift 1h29m08s83ms subtitle2.srt > subtitle2_shift.srt
cat subtitle1.srt subtitle2_shift.srt > subtitle.srt

# Clean subtitle file
sed -i -r "s/^<font color=\"[^\"]+\">(.*)<\/font>$/\1/g" subtitle.srt

# Concat video
ffmpeg -f concat -safe 0 -i <(find -maxdepth 1 -type f -name '*.mp4' -printf "file '$PWD/%p'\n" | sort) -c copy output.mp4

# Create Mkv file
```

## Concat *.mp4

```bash
# Re-encode
filterComplex=$(for i in {0..2}; do echo -n "[${i}:v] [${i}:a] "; done; i=$((i+1)); echo "concat=n=${i}:v=1:a=1 [vv] [aa]")
ffmpeg -i file1.mp4 -i file2.mp4 -i file3.mp4 \
    -filter_complex "${filterComplex}" -map "[vv]" -map "[aa]" output.mp4

# Just concat
ffmpeg -f concat -safe 0 -i <(find -maxdepth 1 -type f -name '*.mp4' -printf "file '$PWD/%p'\n" | sort) -c copy output.mp4
```

## Concat *.vob

```bash
# Note: https://www.internalpointers.com/post/convert-vob-files-mkv-ffmpeg
ffmpeg \
  -analyzeduration 100M -probesize 100M \
  -i "concat:$(find -regextype egrep -regex '.*VTS_01_([1-9])\.VOB' | sort -u | tr '\n' '|' | sed 's/|$//')" \
  -codec:v libx264 -crf 21 \
  -codec:a libmp3lame -qscale:a 2 \
  -codec:s copy \
  output.mkv
```

## Crop Video

```bash
# Preview Video
ffplay -i input.mkv -vf "crop=in_w:in_h-100"

# Crop Video
ffmpeg -i input.mkv -filter:v "crop=in_w:in_h-100" output.mkv
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
