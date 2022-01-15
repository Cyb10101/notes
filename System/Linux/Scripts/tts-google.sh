#!/usr/bin/env bash
set -e

# Requirements
# sudo apt install mpv

# alias tts-google=/home/cyb10101/Sync/notes/System/Linux/Scripts/tts-google.sh
# alias tts-google-de-female='tts-google -l de -g female'
# alias tts-google-de-male='tts-google -l de'
# alias tts-google-en-female='tts-google -g female'
# alias tts-google-en-male=tts-google

# echo 'This is a test.' | tts-google
# tts-google file.txt
# tts-google 'This is a test.'

# tts-google -l en-US -g male 'This is a test.'
# tts-google -l en-US -g male 'This is a test.'
# tts-google -l en-US -g female 'This is a test.'

# tts-google -l en-GB -g male 'This is a test.'
# tts-google -l en-GB -g female 'This is a test.'

# tts-google -l de-DE -g male 'Dies ist ein Test.'
# tts-google -l de-DE -g female 'Dies ist ein Test.'

# Default settings
language=en-US
gender=male

# Parse arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -l|--language)
      if [ "${2}" == "de" ]; then
        language=de-DE
      elif [ "${2}" == "en" ]; then
        language=en-GB
      else
        language=${2}
      fi
      shift # past argument
      shift # past value
    ;;
    -g|--gender)
      if [ "${2}" == "male" ]; then
        gender=male
      elif [ "${2}" == "female" ]; then
        gender=female
      else
        echo 'Error set gender!'
        exit 1
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

setVoiceGermanMale() {
  languageCode="de-DE"
  voiceName="de-DE-Wavenet-B"
  ssmlGender="MALE"
}

setVoiceGermanFemale() {
  languageCode="de-DE"
  voiceName="de-DE-Wavenet-A"
  ssmlGender="FEMALE"
}

setVoiceEnglishGbMale() {
  languageCode="en-GB"
  voiceName="en-GB-Wavenet-D"
  ssmlGender="MALE"
}

setVoiceEnglishGbFemale() {
  languageCode="en-GB"
  voiceName="en-GB-Wavenet-A"
  ssmlGender="FEMALE"
}

setVoiceEnglishUsMale() {
  languageCode="en-US"
  voiceName="en-US-Wavenet-D"
  ssmlGender="MALE"
}

setVoiceEnglishUsFemale() {
  languageCode="en-US"
  voiceName="en-US-Wavenet-E"
  ssmlGender="FEMALE"
}

convertTextByGoogleSpeech() {
  if [ -f ${fileText} ]; then
    jq -Rn --rawfile text ${fileText} \
    --arg languageCode ${languageCode} \
    --arg voiceName ${voiceName} \
    --arg ssmlGender ${ssmlGender} \
    '{"input": {"text": "\($text)"}, "voice": {"languageCode": "\($languageCode)", "name": "\($voiceName)", "ssmlGender": "\($ssmlGender)"}, "audioConfig": {"audioEncoding": "MP3"}}' > ${fileData}

    curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
      -H "Content-Type: application/json; charset=utf-8" \
      --data @${fileData} -sSL "https://texttospeech.googleapis.com/v1/text:synthesize" > ${fileSynthesize}

    # In development
    #cat ${fileSynthesize}
    if [ "$(jq -r '.error.code' ${fileSynthesize})" == "403" ]; then
      printError "$(jq -r '.error.message' ${fileSynthesize})"
      exit 1
    fi

    jq -r '.audioContent' ${fileSynthesize} | base64 --decode > ${fileAudio}
    rm ${fileData} ${fileSynthesize}
  fi
}

createTextFile() {
  echo "${1}" > ${fileText}
}

playAudioAndRemove() {
  if [ -f ${fileAudio} ]; then
    echo -e "\033[0;32mPlay file:\033[0m ${fileAudio}"
    mpv ${fileAudio} && rm "${fileAudio}"
  fi
}

playAudio() {
  if [ -f ${fileAudio} ]; then
    echo -e "\033[0;32mPlay file:\033[0m ${fileAudio}"
    mpv ${fileAudio}
  fi
}

printError() {
  if [ ! -z "${1}" ]; then
    echo -e "\033[0;31mError: ${1}\033[0m"
  fi
}

export GOOGLE_APPLICATION_CREDENTIALS=~/Sync/private-notes/storage/google_text-to-speech.json
setVoiceEnglishGbMale

# Switch language & gender
if [ "${language}" == "de-DE" ]; then
  if [ "${gender}" == "male" ]; then
    setVoiceGermanMale
  else
    setVoiceGermanFemale
  fi
elif [ "${language}" == "en-GB" ]; then
  if [ "${gender}" == "male" ]; then
    setVoiceEnglishGbMale
  else
    setVoiceEnglishGbFemale
  fi
elif [ "${language}" == "en-US" ]; then
  if [ "${gender}" == "male" ]; then
    setVoiceEnglishUsMale
  else
    setVoiceEnglishUsFemale
  fi
fi

VAR_TIME=`date +%H-%M-%S`
fileText=/tmp/tts_text.txt
fileData=/tmp/tts_data.json
fileSynthesize=/tmp/tts_synthesize.json
fileAudio=/tmp/tts_audio_${VAR_TIME}.mp3

if [ -p /dev/stdin ]; then
  # If we want to read the input line by line
  #while IFS= read input; do echo "Pipe Line: ${input}"; done

  # Grab input to a variable
  input=`cat`
  if [[ ! -z "${input}" ]]; then
    createTextFile "${input}"
    convertTextByGoogleSpeech "${fileText}"
    playAudio
  else
    echo "No valid input given!"
  fi
elif [ -f "${1}" ]; then
  #echo "Filename specified: ${1}"
  createTextFile "$(cat "${1}")"
  convertTextByGoogleSpeech "${fileText}"
  playAudio
elif [ ! -z "${1}" ]; then
  #echo "Input specified: ${1}"
  createTextFile "${1}"
  convertTextByGoogleSpeech "${fileText}"
  playAudio
else
  echo "No valid input given!"
fi

unset GOOGLE_APPLICATION_CREDENTIALS
