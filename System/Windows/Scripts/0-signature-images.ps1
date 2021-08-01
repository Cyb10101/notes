# Convert all images in current directory
# Copyright [Alt + 0169]

# https://wiki.ubuntuusers.de/ExifTool/Optionen/
# https://exiftool.org/index.html#supported

$binExifTool = "data\exiftool.exe"

$pathMagick = "data\ImageMagick"
$binMagickComposite = "$pathMagick\composite.exe"
$binMagickConvert = "$pathMagick\convert.exe"
$binMagickIdentify = "$pathMagick\identify.exe"

function installRequirements() {
  if (-Not(Test-Path "data")) {
    New-Item -ItemType "directory" -Path "data"
  }

  # https://imagemagick.org/script/download.php#windows
  if (-Not(Test-Path "$pathMagick")) {
    curl -O "data\ImageMagick.zip" https://download.imagemagick.org/ImageMagick/download/binaries/ImageMagick-7.1.0-4-portable-Q16-x64.zip
    Expand-Archive -Path "data\ImageMagick.zip" -DestinationPath "$pathMagick\"
    Remove-Item -Path "data\ImageMagick.zip"
  }

  # https://exiftool.org/index.html
  if (-Not(Test-Path "data\exiftool.exe" -PathType leaf)) {
    curl -O "data\exiftool.zip" https://exiftool.org/exiftool-12.29.zip
    Expand-Archive -Path "data\exiftool.zip" -DestinationPath "data\"
    Remove-Item -Path "data\exiftool.zip"
    Rename-Item -Path "data\exiftool(-k).exe" -NewName "exiftool.exe"
  }

  if (-Not(Test-Path "data\OpenSans-Regular.ttf" -PathType leaf)) {
    Start-Process "https://fonts.google.com/specimen/Open+Sans"
    Write-Host "Install 'data\OpenSans-Regular.ttf' manually!"
    pause
    exit
  }

  if (-Not(Test-Path "data\watermark.png" -PathType leaf)) {
    Start-Process "https://pixabay.com/vectors/do-not-copy-business-copy-document-160137/"
    Write-Host "Install 'data\watermark.png' manually!"
    pause
    exit
  }
}

# Export with writeable attributes as html
function exifToolExport([string]$fileImage) {
  Set-Content -Path "${fileImage}_exif.html" -Value (& $binExifTool -listwf -h "$fileImage");
  Add-Content -Path "${fileImage}_exif.html" -Value '<style>table {border-collapse: collapse;} table td, table th {padding: .75rem; vertical-align: top; border-top: 1px solid #dee2e6;} table tbody tr:nth-of-type(2n+1) {background-color: rgba(0,0,0,.05);}</style>'
}

function imageSignature([string]$author) {
  Set-Content -Path data\author.txt -Value "© $author" -NoNewline

  $files = dir .\* -include ("*.jpg", "*.jpeg", "*.png")
  foreach ($file in $files) {
    Write-Host "$file"

    # Add Signature in Exif-Data (Verbose: -v2)
    & $binExifTool -v2 -overwrite_original -CopyrightNotice="$author" -OwnerName="$author" -IFD0:Artist="$author" "$file"

    #& $binExifTool -v2 -overwrite_original -rights="$author rights" -CopyrightNotice="$author CopyrightNotice" -OwnerName="$author OwnerName" -IFD0:Artist="$author Artist" -IPTC:By-line="$author By-line" -XMP-dc:Creator="$author Creator1" -IPTC:By-lineTitle="Photographer 1" -XMP-photoshop:AuthorsPosition="Photographer 2" -XMP-photoshop:Credit="$author Credit" -IPTC:Contact="email: user@example.org; website: https://example.org/" -XMP-iptcCore:CreatorWorkEmail="email@example.org" -XMP-iptcCore:CreatorWorkURL="https://example.org/" "$file"

#    Start-Process -Wait -NoNewWindow -FilePath $binExifTool -ArgumentList "-overwrite_original -rights=`"$author rights`" -CopyrightNotice=`"$author CopyrightNotice`" -OwnerName=`"$author OwnerName`" -IFD0:Artist=`"$author Artist`" -IPTC:By-line=`"$author By-line`" -XMP-dc:Creator=`"$author Creator1`" -IPTC:By-lineTitle=`"Photographer 1`" -XMP-photoshop:AuthorsPosition=`"Photographer 2`" -XMP-photoshop:Credit=`"$author Credit`" -IPTC:Contact=`"email: user@example.org; website: https://example.org/`" -XMP-iptcCore:CreatorWorkEmail=`"email@example.org`" -XMP-iptcCore:CreatorWorkURL=`"https://example.org/`" -dateFormat %Y -IFD0:Copyright`"<© `$createdate $author`"  `"$file`""
    #& $binExifTool -overwrite_original -rights="$author rights" -CopyrightNotice="$author CopyrightNotice" -OwnerName="$author OwnerName" -IFD0:Artist="$author Artist" -IPTC:By-line="$author By-line" -XMP-dc:Creator="$author Creator1" -IPTC:By-lineTitle="Photographer 1" -XMP-photoshop:AuthorsPosition="Photographer 2" -XMP-photoshop:Credit="$author Credit" -IPTC:Contact="email: user@example.org; website: https://www.fotocommunity.de/fotografin/astrid-buschmann/119176" -XM-iptcCore:CreatorWorkEmail="email@example.org" -XMP-iptcCore:CreatorWorkURL="https://example.org/" -dateFormat %Y -IFD0:Copyright"<© `$createdate $author" "$file"
    #-dateFormat %Y `"-IPTC:CopyrightNotice<© `$createdate $author, all rights reserved. 2`" -dateFormat %Y `"-XMP-dc:Rights<© `$createdate $author, all rights reserved. 3`"

#    Start-Process -Wait -NoNewWindow -FilePath $binExifTool -ArgumentList "-overwrite_original -rights=`"$author rights`" -CopyrightNotice=`"$author CopyrightNotice`" -OwnerName=`"$author OwnerName`" -IFD0:Artist=`"$author Artist`" -IPTC:By-line=`"$author By-line`" -XMP-dc:Creator=`"$author Creator1`" -IPTC:By-lineTitle=`"Photographer 1`" -XMP-photoshop:AuthorsPosition=`"Photographer 2`" -XMP-photoshop:Credit=`"$author Credit`" -IPTC:Contact=`"email: user@example.org; website: https://example.org/`" -XMP-iptcCore:CreatorWorkEmail=`"email@example.org`" -XMP-iptcCore:CreatorWorkURL=`"https://example.org/`" -d %Y `"-IFD0:Copyright<© `$createdate $author, all rights reserved. 1`" -d %Y `"-IPTC:CopyrightNotice<© `$createdate $author, all rights reserved. 2`" -d %Y `"-XMP-dc:Rights<© `$createdate $author, all rights reserved. 3`" `"$file`""
    #& $binExifTool -overwrite_original -rights="$author rights" -CopyrightNotice="$author CopyrightNotice" -OwnerName="$author OwnerName" -IFD0:Artist="$author Artist" -IPTC:By-line="$author By-line" -XMP-dc:Creator="$author Creator1" -IPTC:By-lineTitle="Photographer 1" -XMP-photoshop:AuthorsPosition="Photographer 2" -XMP-photoshop:Credit="$author Credit" -IPTC:Contact="email: user@example.org; website: https://example.org/" -XM-iptcCore:CreatorWorkEmail="email@example.org" -XMP-iptcCore:CreatorWorkURL="https://example.org/" -d %Y "-IFD0:Copyright<© `$createdate $author, all rights reserved. 1" -d %Y "-IPTC:CopyrightNotice<© `$createdate $author, all rights reserved. 2" -d %Y "-XMP-dc:Rights<© `$createdate $author, all rights reserved. 3" "$file"

    #exifToolExport "$file"

    # Add text left
    & $binMagickConvert "$file" -gravity SouthWest -weight 500 -pointsize 30 -fill "#000000" -font "data\OpenSans-Regular.ttf" -annotate +16+10 @data\author.txt "$file"
    & $binMagickConvert "$file" -gravity SouthWest -weight 500 -pointsize 30 -fill "#ffffff" -font "data\OpenSans-Regular.ttf" -annotate +15+11 @data\author.txt "$file"

    # Image
    & $binMagickConvert "$file" -gravity SouthEast -draw "image Over 0,0,160,160 data\watermark.png" "$file"

    # Image better
    & $binMagickComposite -compose atop -geometry x120+50+20 -gravity southeast -background none "data\watermark.png" "$file" "$file"

    # Transparent bar
    $width = $(& $binMagickIdentify -format %w "$file")
    #& $binMagickConvert -background "#00000088" -fill white -gravity center -size ${width}x35 -font "data\OpenSans-Regular.ttf" -pointsize 30 -gravity center caption:'@data\author.txt' "$file" +swap -gravity south -composite "$file"

    # Transparent right corner
    $widthBar = 350
    $widthBarExtra = $widthBar + 8
    & $binMagickConvert "$file" `( -background transparent -size ${widthBar}x35 -gravity center -fill "#00000088" -draw "roundrectangle 0,0 ${widthBarExtra},43 8,8" caption:"" `) -gravity SouthEast -composite `( -background transparent -size ${widthBarExtra}x35 -gravity center -font "data\OpenSans-Regular.ttf" -pointsize 30 -fill "#ffffff" caption:@data\author.txt `) -gravity SouthEast -composite "$file"
  }
}

# For development
#copy original\*.jpg .\

installRequirements
imageSignature("Firstname Lastname")
