# Youtube Downloader

*Note: Rename `https://youtube.com/shorts/_I_m2_6TBbQ` to `https://youtube.com/watch?v=_I_m2_6TBbQ`.*

## YT-DL

* [yt-dlp](https://github.com/yt-dlp/yt-dlp)
* [Simple Youtube Downloader GUI](../System/Linux/Scripts/youtube-downloader.sh)

Install Linux:

```bash
curl -o /tmp/yt-dlp -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo install /tmp/yt-dlp /usr/local/bin/yt-dlp

# Config file
gedit ~/.config/yt-dlp/config

# Download
yt-dlp 'https://www.youtube.com/watch?v=_I_m2_6TBbQ'

# Lazy slow down downloading a playlist
yt-dlp-playlist 'https://www.youtube.com/@SproutsDeutschland/shorts'
yt-dlp-playlist() { yt-dlp --flat-playlist -j "$1" | jq -r '.webpage_url' | sed -r 's/(.*)/yt-dlp "\1"/'| awk 'NR % 3 == 0 {print; print "echo \"Sleep for 10 seconds ...\"; sleep 10"; next} 1' > 0-download.txt && bash 0-download.txt; }
```

Install Windows, run `powershell` as user.

```powershell
# Installation via scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install yt-dlp ffmpeg

# Config file for scoop
notepad "$($env:userprofile)\scoop\apps\yt-dlp\current\yt-dlp.conf"

# Config file for portable
New-Item -Path "$($env:appdata)\yt-dlp" -ItemType Directory
notepad "$($env:appdata)\yt-dlp\config.conf"
```

Config file:

```bash
# Linux: ~/.config/yt-dlp/config
# Windows: notepad "$($env:appdata)\yt-dlp\config.conf"
# Windows Scoop: notepad "$($env:userprofile)\scoop\apps\yt-dlp\current\yt-dlp.conf"

# Cookies
#--cookies-from-browser firefox:~/.mozilla/firefox/your-profile

# Output folder
#--paths ~/Downloads

# Filename template: 01 Title (2023-01-21) [video-id].extension
#--output "%(autonumber)02d %(title)s (%(upload_date>%Y-%m-%d)s) [%(id)s].%(ext)s"

# Filename template: 01 Title [video-id]/01 Title (2023-01-21).extension
--output "%(autonumber)02d %(title)s [%(id)s]/%(autonumber)02d %(title)s (%(upload_date>%Y-%m-%d)s).%(ext)s"

# Restrict filenames to only ASCII characters, and avoid "&" and spaces in filenames
--restrict-filenames

# Do not overwrite any files
--no-overwrites

# Select best format
-f bestvideo[ext=mkv]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best

# Encode the video to another format if necessary
--recode-video mkv

# If a merge is required, output to given container format. [mkv, mp4, ogg, webm, flv]
--merge-output-format mkv

# Keep the video file on disk after the post-processing
--keep-video

# Write video description to a .description file
--write-description

# Embed metadata and chapters
--embed-metadata

################################################################################
# Subtitles

# Download all the available subtitles
#--all-subs

# Languages of the subtitles
--sub-lang en,de

# Convert the subtitles to other format [srt, ass, vtt, lrc]
--convert-subs srt

# Write subtitle file
--write-sub

# Write automatically generated subtitle file
--write-auto-sub

# Embed subtitles in the video [mp4, webm, mkv]
--embed-subs
```

## Youtube-DL

* [youtube-dl](https://github.com/ytdl-org/youtube-dl)

```bash
sudo apt -y install youtube-dl

youtube-dl --sub-lang en,de --convert-subs srt --write-sub \
    --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' \
    'https://youtube.com/watch?v=_I_m2_6TBbQ'

youtube-dl --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' 'https://youtube.com/watch?v=_I_m2_6TBbQ'

youtube-dl 'https://youtube.com/watch?v=_I_m2_6TBbQ'
```

Config file:

```bash
# Config paths
# Linux: ~/.config/youtube-dl/config
# Windows: %APPDATA%\youtube-dl\config.conf

# Filename template: 01 Title (2023-01-21) [video-id].extension
--output "%(autonumber)02d %(title)s (%(upload_date>%Y-%m-%d)s) [%(id)s].%(ext)s"

# Do not overwrite any files
--no-overwrites

# Select best format
-f bestvideo[ext=mkv]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
```
