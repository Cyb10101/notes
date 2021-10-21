# Convert a Book to Epub

## Scan pages

Scan the pages of a book into images and get the text via `tesseract ocr`.

* [Tesseract Ocr Script](../System/Linux/Scripts/tesseract-ocr.sh)

```bash
# For english text
./tesseract-ocr.sh -l eng

# For german text
./tesseract-ocr.sh -l deu
```

## Create a markdown book

Create a markdown book with multiple chapter01.md.

```bash
# Rename *.txt to *.md
rename 's/\.txt$/\.md/' *.txt
```

## Convert Markdown to to Epub

```bash
sudo apt -y install pandoc
```

* [Pandoc: EPUB Metadata](https://pandoc.org/MANUAL.html#epub-metadata)

metadata.yml:

```yml
title: My Book
author: Firstname Lastname
language: en-US
```

Convert Markdown to Epub:

*Note: Links/Images must relative to pandoc command! (Maybe a bug?)*

```bash
pandoc --output progit.epub --from markdown --to epub metadata.yml \
  chapter01.md \
  chapter02.md \
  chapter03.md
```

Use Calibre for the rest:

* [Calibre](https://calibre-ebook.com/)
