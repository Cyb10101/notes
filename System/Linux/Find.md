# Find

```bash
# Find long filenames
find -regextype posix-extended -regex '.*[^/]{128,}$' -exec gwenview '{}' \;
```

## Bad files in websites

```bash
TMP_FOLDER=`mktemp -d /tmp/bad_filename_XXXXXXXX`
echo "${TMP_FOLDER}";

find -type f \( -iname '*.html' -o -iname '*.php' \) | sort > ${TMP_FOLDER}/0-websites.md
find -regextype posix-extended -iregex '.*\s.*' | sort > ${TMP_FOLDER}/0-space.md
find -regextype posix-extended -iregex '.*[[:upper:]].*' | sort > ${TMP_FOLDER}/0-uppercase.md
find -type f -regextype posix-extended -iregex '.*\.(jpg|jpeg|png|gif|tif|bmp|webp)$' | sort > ${TMP_FOLDER}/0-images.md

# Global
echo "# Global" > ${TMP_FOLDER}/0-global.md

echo "\n## Bad encoding\n" >> ${TMP_FOLDER}/0-global.md
find -type d \( -name node_modules \) -prune -false -o -iname '*' \
    | iconv -f windows-1252 | grep -P '[^a-zA-Z0-9\/\-_\.\s\(\)\+]' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Very Bad filename\n" >> ${TMP_FOLDER}/0-global.md
find -type f | grep -P '[^a-zA-Z0-9\/\-_\.\s\(\)\+]' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Bad filename\n" >> ${TMP_FOLDER}/0-global.md
#find -regextype posix-extended -iregex '.*[~$&+,:;=?@#|^*<>(){}%!"].*' | sort >> ${TMP_FOLDER}/0-global.md
find -regextype posix-extended -iregex '.*[~$&+,:;=?@#|^*<>{}%!"].*' | sort >> ${TMP_FOLDER}/0-global.md
find -iname "*[']*" | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Archive\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(zip|z)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Java\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(class|cab|jar|java)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Flash\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(swf)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Logs\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(log)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Text\n" >> ${TMP_FOLDER}/0-global.md
find -type d \( -name assets -o -name build \) -prune -false -o \
 -type f -regextype posix-extended -iregex '.*\.(txt)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Documents\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(docx?|dot|odt|pdf|pps|pptx?|txt|xlsx?)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Videos\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(avi|mov|mp3|mp4|mpg)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Bad Documents\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(lnk|ini)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Other\n" >> ${TMP_FOLDER}/0-global.md
find -type f -regextype posix-extended -iregex '.*\.(art|au|drw|lst|LZZZZZZZ|mei|ref|ufo|uas|wbk|whtt)$' | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Bad Images\n" >> ${TMP_FOLDER}/0-global.md
find -type f \( \
    -iname '*.jpeg' -o \
    -iname '*.bmp' -o \
    -iname '*.tif' \
\) | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Bad Website\n" >> ${TMP_FOLDER}/0-global.md
find -type f \( -iname '*.htm' \) | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Bad Ending\n" >> ${TMP_FOLDER}/0-global.md
find -type f \( \
    -name '*.Html' -o \
    -name '*.PHP' \
 \) | sort >> ${TMP_FOLDER}/0-global.md

echo "\n## Scripts\n" >> ${TMP_FOLDER}/0-global.md
find -type d \( -name assets -o -name build \) -prune -false -o \
-type f \( \
    -iname '*.css' -o \
    -iname '*.js' -o \
    -iname '*.json' \
\) | sort >> ${TMP_FOLDER}/0-global.md
```
