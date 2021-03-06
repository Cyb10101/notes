# Archives

Create archives and split files.

## Archive: 7-Zip

Linux:

```bash
# Create archive with password (-p) and split to 50 MB parts
7z a -p -v50m archive.7z ~/Documents
7z a -p123456 -v50m archive.7z ~/Documents

# Extract archive
7z x archive.7z.001
```

## Archive: Rar

Linux:

```bash
# Create archive with password (-hp) and split to 50 MB parts
rar a -hp -ep1 -v50m archive.rar ~/Documents
rar a -hp123456 -ep1 -v50m archive.rar ~/Documents

# Extract archive
rar x archive.part1.rar
```

## Archive: Zip

Linux:

```bash
# Create archive
zip -r archive.zip ~/Documents

# Create archive with password (-P) and split to 50 MB parts
zip -P123456 -s50m -r archive-splitet.zip ~/Documents

# Combine splittet zip into one file
zip -F archive-splitet.zip --out archive.zip

# Extract archive
unzip archive.zip
```

## Archive: Tar

Linux:

```bash
# Create archive
tar cfJ archive.tar.xz ~/Documents

# Extract archive
tar xf archive.tar.xz
```

## Split

Splits every file into parts.

* [Split on Linux](https://wiki.ubuntuusers.de/split/)
* [Split on Windows - GNU CoreUtils](http://gnuwin32.sourceforge.net/packages/coreutils.htm)

Linux:

```bash
sudo apt install coreutils

# Split a file in 50 MB parts (do not remove last point)
split -b 50MB archive.tar.xz archive.tar.xz.

# Merge files to one file
cat archive.tar.xz.* > archive.tar.xz
```

Windows:

```bash
# Install: GNU CoreUtils

# Split a file in 50 MB parts (do not remove last point)
"C:\Program Files (x86)\GnuWin32\bin\split.exe" -b 50000000 archive.zip archive.zip.

# Merge files to one file
copy /b archive.zip.* archive.zip
# copy /b archive.zip.aa+archive.zip.ab+archive.zip.ac archive2.zip
# copy /b archive.zip.aa + archive.zip.ab + archive.zip.ac archive3.zip
```
