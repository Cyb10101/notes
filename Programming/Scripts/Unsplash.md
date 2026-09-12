# Unsplash

## Unsplash Datasets

Handy if you need a lot of images for test purposes.

- [Unsplash Datasets](https://github.com/unsplash/datasets)

Create a aria2 hook file `0-aria2-fix-extension.sh`:

```shell
#!/usr/bin/env bash
# aria2c calls this with: GID, number of files, file path
filepath="$3"
[[ "$filepath" == *.* ]] && exit 0 # already has an extension

mime=$(file --mime-type -b "$filepath")
case "$mime" in
  image/jpeg) ext=jpg ;;
  image/png)  ext=png ;;
  image/gif)  ext=gif ;;
  image/webp) ext=webp ;;
  *) ext=bin ;;
esac
mv "$filepath" "$filepath.$ext"
```

Prepare and download images:

```shell
# Download and extract file
wget -O unsplash-lite.zip https://unsplash.com/data/lite/latest
unzip -p unsplash-lite.zip photos.tsv000 > 0-photos.tsv

# Generate download file
tail -n +2 0-photos.tsv | cut -f3 > 1-images.txt

# Consider if you really need original pictures
# sed -i 's/$/\?w=1920/' 1-images.txt
sed -i 's/$/\?w=640/' 1-images.txt

# Add aria2 hook file and make it executable
chmod +x 0-aria2-fix-extension.sh

# Download and resume aborted download
aria2c -i 1-images.txt --continue --save-session=1-images.txt --save-session-interval=5 --human-readable=true \
  --max-concurrent-downloads=8 --on-download-complete=./0-aria2-fix-extension.sh --dir=images
```
