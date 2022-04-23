# Text to speech

## Pico 2 wave

Examples:

```bash
alias tts-pico=~/Sync/notes/System/Linux/Scripts/tts-pico.sh
alias tts-pico-de='tts-pico -l de'
alias tts-pico-en='tts-pico'

echo 'Piped input' | tts-pico
tts-pico 'Text or file'

tts-pico -l de 'Text or file'
```

## Google Text to Speech

* [Google Cloud](https://console.cloud.google.com/)

* [Cloud Text-to-Speech: Before you begin](https://cloud.google.com/text-to-speech/docs/before-you-begin)
* [Cloud Text-to-Speech: API](https://console.cloud.google.com/marketplace/product/google/texttospeech.googleapis.com)
* [Cloud Text-to-Speech: Quota](https://console.cloud.google.com/iam-admin/quotas?service=texttospeech.googleapis.com)
* [Credentials / API Key](https://console.cloud.google.com/apis/credentials)
* [gcloud - Cloud SDK](https://cloud.google.com/sdk/docs/quickstart#deb)
* [Rollen: Cloud Speech-Client](https://console.cloud.google.com/iam-admin/roles)

gcloud installation:

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
gcloud init
```

* [Convert text to speech (mp3)](../system/)

Examples:

```bash
alias tts-google=~/Sync/notes/System/Linux/Scripts/tts-google.sh
alias tts-google-de-male='tts-google -l de'
alias tts-google-de-female='tts-google -l de -g female'
alias tts-google-en-male='tts-google'
alias tts-google-en-female='tts-google -g female'

echo 'Piped input' | tts-google
tts-google 'Text or file'

tts-google -l de-DE -g male "Dies ist ein Test."
tts-google -l de-DE -g female "Dies ist ein Test."
tts-google -l de-DE -g male "This is a test."
tts-google -l en-GB -g female "This is a test."
tts-google -l en-US -g male "This is a test."
tts-google -l en-US -g female "This is a test."
```
