# Find

```bash
# Find long filenames
find -regextype posix-extended -regex '.*[^/]{128,}$' -exec gwenview '{}' \;
```

## Bad files in websites

```bash
find -type f \( -iname '*.html' -o -iname '*.php' \) | sort > ../0-websites.md
find -regextype posix-extended -iregex '.*\s.*' | sort > ../0-space.md
find -regextype posix-extended -iregex '.*[[:upper:]].*' | sort > ../0-uppercase.md
find -type f -regextype posix-extended -iregex '.*\.(jpg|jpeg|png|gif|tif|bmp|webp)$' | sort > ../0-images.md

# Global
echo "# Global" > ../0-global.md

echo "\n## Bad filename\n" >> ../0-global.md
#find -regextype posix-extended -iregex '.*[~$&+,:;=?@#|^*<>(){}%!"].*' >> ../0-global.md
find -regextype posix-extended -iregex '.*[~$&+,:;=?@#|^*<>{}%!"].*' >> ../0-global.md
find -iname "*[']*" >> ../0-global.md

echo "\n## Archive\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(zip|z)$' | sort >> ../0-global.md

echo "\n## Java\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(class|cab|jar|java)$' | sort >> ../0-global.md

echo "\n## Flash\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(swf)$' | sort >> ../0-global.md

echo "\n## Logs\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(log)$' | sort >> ../0-global.md

echo "\n## Text\n" >> ../0-global.md
find -type d \( -name assets -o -name build \) -prune -false -o \
 -type f -regextype posix-extended -iregex '.*\.(txt)$' | sort >> ../0-global.md

echo "\n## Documents\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(docx?|dot|odt|pdf|pps|pptx?|txt|xlsx?)$' | sort >> ../0-global.md

echo "\n## Videos\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(avi|mov|mp3|mp4|MPG)$' | sort >> ../0-global.md

echo "\n## Bad Documents\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(lnk|ini)$' | sort >> ../0-global.md

echo "\n## Other\n" >> ../0-global.md
find -type f -regextype posix-extended -iregex '.*\.(art|au|drw|lst|LZZZZZZZ|mei|ref|ufo|uas|wbk|whtt)$' | sort >> ../0-global.md

echo "\n## Bad Images\n" >> ../0-global.md
find -type f \( \
    -iname '*.jpeg' -o \
    -iname '*.bmp' -o \
    -iname '*.tif' \
\) | sort >> ../0-global.md

echo "\n## Bad Website\n" >> ../0-global.md
find -type f \( -iname '*.htm' \) | sort >> ../0-global.md

echo "\n## Bad Ending\n" >> ../0-global.md
find -type f \( \
    -name '*.Html' -o \
    -name '*.PHP' \
 \) | sort >> ../0-global.md

echo "\n## Scripts\n" >> ../0-global.md
find -type d \( -name assets -o -name build \) -prune -false -o \
-type f \( \
    -iname '*.css' -o \
    -iname '*.js' -o \
    -iname '*.json' \
\) | sort >> ../0-global.md
```
