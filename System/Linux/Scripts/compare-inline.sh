#!/usr/bin/env bash
# ./compare-inline.sh 'Text 1 changed' 'Text 2 ChAnGeFD'
# ./compare-inline.sh file1 file2

if [ $# != 2 ]; then
    echo 'Error: Two input parameters required!'
    exit 1
fi

tmpFile1=$(mktemp .compare_XXXXXXXX) || exit 1
tmpFile2=$(mktemp .compare_XXXXXXXX) || exit 1
trap 'rm -rf "${tmpFile1}" "${tmpFile2}"; exit' EXIT

if [ -e "$1" ]; then
    cp "$1" "${tmpFile1}"
else
    echo "$1" > "${tmpFile1}"
fi

if [ -e "$2" ]; then
    cp "$2" "${tmpFile2}"
else
    echo "$2" > "${tmpFile2}"
fi

git diff -U0 --no-index --word-diff=color --word-diff-regex=. "${tmpFile1}" "${tmpFile2}"
