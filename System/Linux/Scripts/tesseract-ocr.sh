#!/bin/bash

# ./tesseract-ocr.sh -l eng
# ./tesseract-ocr.sh -l deu
language=deu

while getopts l: flag; do
    case "${flag}" in
        l) language=${OPTARG:-eng};;
    esac
done

echo -e "\033[0;33mLanguage: ${language}\033[0m";

tesseractFile() {
    echo -e "\033[0;32m# ${1}\033[0m";
    outputFile=$(basename "${1}")
    outputFile=${outputFile%.*}
    tesseract "${1}" "output/${outputFile}" -l ${language}
}

if [ -f /usr/bin/tesseract ]; then
	if [ ! -d output ]; then
	    mkdir output
	fi

    for file in *.jpg *.jpeg *.png; do
        [ -f "${file}" ] || continue
        tesseractFile "${file}"
    done
else
    echo 'Tesseract ocr not installed! Installing tesseract ocr...';
    sudo apt -y install tesseract-ocr \
        tesseract-ocr-eng \
        tesseract-ocr-deu
    # Other Languages: apt-cache search ^tesseract-ocr- | grep tesseract-ocr-
    echo 'Run script again!';
fi

