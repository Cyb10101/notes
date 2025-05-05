# Internet Streams

* [Internet Radio](https://www.internet-radio.com/)

Note: You don't need to stream twice (download and play), just use two terminals:

* One with `curl -o radio.mp3 https://example.org/steam` for download
* and one with `mpv --player-operation-mode=pseudo-gui radio.mp3` to play

## Play

```bash
vlc 'https://example.com/stream.mp3'

mpv 'https://example.com/stream.mp3'
mpv --player-operation-mode=pseudo-gui --volume=50 'https://example.com/stream.mp3'
```

## Download on Linux

```bash
# Curl
curl -o "radio_$(date +%Y-%m-%d_%H-%M-%S).mp3" 'https://example.com/stream.mp3'

# Youtube Downloader
yt-dlp -o "radio_$(date +%Y-%m-%d_%H-%M-%S).mp3" 'https://example.com/stream.mp3'

# Streamripper (-a = rip to a single file, -q = add sequence number to filenames, -u = User-Agent)
# Alternative codeset: CP1252
streamripper 'https://example.com/radio/stream.mp3' -a -q -u 'VLC/3.0.18-rc2 LibVLC/3.0.18-rc2' \
  --codeset-filesys=CP1252 --codeset-id3=CP1252 --codeset-metadata=CP1252 --codeset-relay=CP1252
```

If timestamps are incorrect, fix it with ffmpeg:

```bash
sudo apt install ffmpeg
ffmpeg -i radio.mp3 radio_fixed.mp3
```

Check file extension / mime type:

```bash
mimeType="$(file -b --mime-type radio.mp3)"; echo "Detected: ${mimeType}"; grep "${mimeType}" /etc/mime.types
```

File `0-radio.sh`:

```bash
#!/bin/bash
# ./0-radio.sh
# ./0-radio.sh 'https://example.com/stream.mp3'

ERROR_COUNT=0
ERROR_MAX=1000

trap exitScript SIGINT

exitScript() {
    echo ""
    echo "Finished with error count: ${ERROR_COUNT}."
    exit 0
}

streamUrl='https://example.com/stream.mp3'
if [[ ! -z "${1}" ]]; then
    streamUrl="${1}"
fi

while :; do
    curl -o "radio_curl_$(date +%Y-%m-%d_%H-%M-%S).mp3" "${streamUrl}"
    #yt-dlp -o "radio_yt-dlp_$(date +%Y-%m-%d_%H-%M-%S).mp3" "${streamUrl}"

    (( ERROR_COUNT+=1 ))
    echo "$(date +%Y-%m-%d_%H-%M-%S) ERROR: Stream is unreachable! Total count is ${ERROR_COUNT}."

    if [[ ${ERROR_COUNT} -gt ${ERROR_MAX} ]]; then
        echo "$(date +%Y-%m-%d_%H-%M-%S) ERROR: Exit because error max is reached!"
        exit 1
    fi

    #sleep 0.5
done
```

## Download on Windows

Run a PowerShell as user:

```shell
# Disable progressbar for faster downloading (PS < 7.2) ( https://github.com/PowerShell/PowerShell/issues/2138 )
$ProgressPreference = 'SilentlyContinue'
curl -o "radio_$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')).mp3" 'https://example.com/stream.mp3'

yt-dlp -o "radio_$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')).mp3" 'https://example.com/stream.mp3'
```

## Download chunked stream (m3u8)

This is just an example for... I don't know. It works.

```bash
url=$(yt-dlp --get-url "https://example.com/steam/"); echo ${url}
#url=$(youtube-dl --get-url "https://example.com/steam/"); echo ${url}
ffmpeg -i "${url}" -c copy file_$(date +%Y-%m-%d_%H-%M-%S).mkv
timeout 60 ffmpeg -i "${url}" -c copy file_$(date +%Y-%m-%d_%H-%M-%S).mkv
```

## Upgrade http/0.9 to newer

* [Caddy Server](https://caddyserver.com/)

Example for url `https://example.com/radio/stream.mp3`:

```bash
# If you have Caddy installed, you may want to stop and disable the default server
sudo systemctl stop caddy
sudo systemctl disable caddy

# Start Caddy reverse proxy (You may wan't to add --access-log for debugging)
sudo caddy reverse-proxy --change-host-header --from :2080 --to https://example.com

streamripper 'https://127.0.0.1:2080/radio/stream.mp3' -a -q -u 'VLC/3.0.18-rc2 LibVLC/3.0.18-rc2'
mpv --player-operation-mode=pseudo-gui 'http://127.0.0.1:2080/radio/stream.mp3'
```
