# Internet Streams

* [Internet Radio](https://www.internet-radio.com/)

Note: You don't need to stream twice (download and play), just use two terminals:

* One with `curl -o radio.mp3 https://example.org/steam` for download
* and one with `mpv --player-operation-mode=pseudo-gui radio.mp3` to play

## Play

```bash
vlc 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'

mpv 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'
mpv --player-operation-mode=pseudo-gui --volume=50 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'
```

## Download on Linux

```bash
curl -o "radio_$(date +%Y-%m-%d_%H-%M-%S).mp3" 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'

yt-dlp -o "radio_$(date +%Y-%m-%d_%H-%M-%S).mp3" 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'
```

Check file extension / mime type:

```bash
mimeType="$(file -b --mime-type radio.mp3)"; echo "Detected: ${mimeType}"; grep "${mimeType}" /etc/mime.types
```

## Download on Windows

Run a PowerShell as user:

```shell
## Disable Windows PowerShell progressbar for faster downloading ( https://github.com/PowerShell/PowerShell/issues/2138 )
$ProgressPreference = 'SilentlyContinue'
curl -o "radio_$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')).mp3" 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'

yt-dlp -o "radio_$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')).mp3" 'https://uk4.internet-radio.com/proxy/danceattackfm?mp=/stream;'
```

## Download chunked stream (m3u8)

This is just an example for... I don't know. It works.

```bash
url=$(yt-dlp --get-url "https://chaturbate.com/username/"); echo ${url}
#url=$(youtube-dl --get-url "https://chaturbate.com/username/"); echo ${url}
ffmpeg -i "${url}" -c copy file_$(date +%Y-%m-%d_%H-%M-%S).mkv
timeout 60 ffmpeg -i "${url}" -c copy file_$(date +%Y-%m-%d_%H-%M-%S).mkv
```
