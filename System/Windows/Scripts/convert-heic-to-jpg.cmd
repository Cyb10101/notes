@echo off
rem Install ImageMagick https://imagemagick.org/script/download.php#windows

for %%f in (*.heic) do (
    echo "Processing: %%~f"
    "C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe" convert "%%~f" "%%~nf.jpg"
)
