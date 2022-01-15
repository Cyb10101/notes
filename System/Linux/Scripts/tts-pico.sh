#!/bin/bash
set -e

# Requirements
# sudo apt install mpv libttspico-utils

# alias tts-pico=/home/cyb10101/Sync/notes/System/Linux/Scripts/tts-pico.sh
# alias tts-pico-de='tts-pico -l de'
# alias tts-pico-en=tts-pico

# echo 'This is a test.' | tts-pico-en
# tts-pico-en file.txt
# tts-pico-en 'This is a test.'
# tts-pico-de 'Dies ist ein Test.'

# Default settings
language=en-US

# Parse arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -l|--language)
      if [ "${2}" == "de" ]; then
        language=de-DE
      else
        language=${2}
      fi
      shift # past argument
      shift # past value
    ;;
    --default)
      DEFAULT=YES
      shift # past argument
    ;;
    *) # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

ttsPico2Wave() {
  echo ${language}
  pico2wave -l "${language}" -w "${fileAudio}" "${1}" && \
    mpv "${fileAudio}" && \
    rm "${fileAudio}"
}

fileAudio=/tmp/tts_audio.wav

if [ -p /dev/stdin ]; then
  # If we want to read the input line by line
  #while IFS= read input; do echo "Pipe Line: ${input}"; done

  # Grab input to a variable
  input=`cat`
  if [[ ! -z "${input}" ]]; then
    ttsPico2Wave "${input}"
  else
    echo "No valid input given!"
  fi
elif [ -f "${1}" ]; then
  #echo "Filename specified: ${1}"
  ttsPico2Wave "$(cat "${1}")"
elif [ ! -z "${1}" ]; then
  #echo "Input specified: ${1}"
  ttsPico2Wave "${1}"
else
  echo "No valid input given!"
fi
