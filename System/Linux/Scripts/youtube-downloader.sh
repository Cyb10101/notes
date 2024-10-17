#!/usr/bin/env bash

# Install script
# wget -O /tmp/youtube-downloader.sh https://raw.githubusercontent.com/Cyb10101/notes/master/System/Linux/Scripts/youtube-downloader.sh && bash /tmp/youtube-downloader.sh install

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

installSelf() {
  textColor 2 "$(translate 'Install YT-Dlp: Youtube Downloader')..."
  install "${0}" /usr/local/bin/youtube-downloader
  createLauncher

  packages="$(checkInstalledSoftware)"
  if [ ! -z "$packages" ]; then
    textColor 2 "$(translate 'Install missing software'): $packages"
    apt update && apt -y install $packages

    if ! hash yad 2>/dev/null || ! hash yt-dlp 2>/dev/null; then
      echo "$(translate 'Error')! $(translate 'Missing software is not installed'): $packages"
      zenity --error --width=210 --title "$(translate 'Error')" --text="$(translate 'Error')! $(translate 'Missing software is not installed'): $packages" &
      exit 1
    fi
  fi
  zenity --info --width=210 --title "$(translate 'Script has been installed')" --text="$(translate 'Start the script via the start menu')." &
  exit 0
}

createLauncher() {
  cat <<EOF | tee /usr/share/applications/youtube-downloader.desktop > /dev/null
[Desktop Entry]
Name=YT-Dlp: Youtube Downloader
Comment=Download from Youtube and other websites
Exec="/usr/local/bin/youtube-downloader"
TryExec=/usr/local/bin/youtube-downloader
Terminal=false
Type=Application
Icon=/usr/share/icons/Yaru/256x256/emblems/emblem-downloads.png
Categories=Utility;
Name[de]=YT-Dlp: Youtube Downloader
Comment[de_DE]=Download von YouTube und anderen Websites
EOF
}

textColor() {
  echo -e "\033[0;3${1}m${2}\033[0m"
}

translate() {
  local msg="$1"
  
  # Definieren Sie die Übersetzungen für jede Sprache
  declare -A translations
  case "${LANG:0:2}" in
    de)
      translations["Elevate script permission"]="Skriptberechtigung erhöhen"
      translations["Script has been installed"]="Skript wurde installiert"
      translations["Start the script via the start menu"]="Starte das Skript über das Startmenü"
      translations["Website"]="Webseite"
      translations["Save as"]="Speichern unter"
      translations["Mode"]="Modus"
      translations["Error"]="Fehler"
      translations["Folder does not exists"]="Ordner existiert nicht"
      translations["Website missing"]="Webseite fehlt"
      translations["Script done"]="Script fertig"
      translations["Install missing software"]="Fehlende Software installieren"
      translations["Missing software is not installed"]="Fehlende Software ist nicht installiert"
      translations["All"]="Alles"
      translations["Audio MP3"]="Audio MP3"
    ;;
    *)
    ;;
  esac
  echo "${translations[$msg]:-$msg}"
}

checkInstalledSoftware() {
  local notInstalledSoftwareApt=()

  if ! hash yad 2>/dev/null; then
    notInstalledSoftwareApt+=('yad')
  fi
  if ! hash yt-dlp 2>/dev/null; then
    notInstalledSoftwareApt+=('yt-dlp')
  fi

  if (( ${#notInstalledSoftwareApt[@]} != 0 )); then
    echo "${notInstalledSoftwareApt[@]}"
  fi
}

checkConfig() {
  if [ ! -d ~/.config/yt-dlp ]; then
    mkdir -p ~/.config/yt-dlp
  fi

  if [ ! -f ~/.config/yt-dlp/config ]; then
    cat << EOF | tee ~/.config/yt-dlp/config > /dev/null
# Config paths
# Linux: ~/.config/yt-dlp/config
# Windows: %APPDATA%\yt-dlp\config.conf

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
# -f bestvideo[ext=mkv]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
# -f bestvideo[ext=mkv]+bestaudio/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
# -f bestvideo[ext=mkv][height<=2160]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height<=2160]+bestaudio[ext=m4a]/best[ext=mp4][height<=2160]/best[height<=2160]
-f bestvideo[height<=2160]+bestaudio/best[height<=2160]/best

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
EOF
    fi
}

# Run elevated installation
if [[ "${1,,}" == "install" ]]; then
  if [[ $EUID -ne 0 ]]; then
    textColor 2 "$(translate 'Elevate script permission')..."
    exec pkexec --keep-cwd env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash "${0}" "$@";
  fi
  installSelf; exit 0
fi

# Check script requirements
packages="$(checkInstalledSoftware)"
if [ ! -z "$packages" ]; then
    echo "$(translate 'Error')! $(translate 'Missing software is not installed'): $packages"
    zenity --error --width=210 --title "$(translate 'Error')" --text="$(translate 'Error')! $(translate 'Missing software is not installed'): $packages"
    exit 1
fi
checkConfig

folderDestination="/home/${USER}/Downloads"
if [ ! -d "${folderDestination}" ]; then folderDestination="/home/${USER}"; fi

modeAll="$(translate 'All')"
modeAudioOnlyMp3="$(translate 'Audio MP3')"
result=$(yad --center --window-icon="gtk-ok" --on-top --width=500 --title="YT-Dlp: Youtube Downloader" \
  --form \
  --field="$(translate 'Website'):ENTRY" "" \
  --field="$(translate 'Save as'):DIR" "${folderDestination}" \
  --field="$(translate 'Mode')":CB "${modeAll}!${modeAudioOnlyMp3}" \
  --separator='|' --button=gtk-cancel:1 --button=gtk-ok:0 \
)

if [ $? -eq 0 ]; then
  IFS='|' read -r url folderDestination mode <<< "$result"
  url="$(echo $url | awk '{$1=$1;print}')"

  if [ ! -d "${folderDestination}" ]; then
    echo "$(translate 'Folder does not exists')!"
    zenity --error --width=210 --title "$(translate 'Error')" --text="$(translate 'Folder does not exists')!" &
    exit 1
  fi

  if [[ "${url}" == "" ]]; then
    echo "$(translate 'Website missing')!"
    zenity --error --width=210 --title "$(translate 'Error')" --text="$(translate 'Website missing')!" &
    exit 1
  fi

  argsList=()
  if [[ "${mode}" == "${modeAudioOnlyMp3}" ]]; then
    # Filename template: 01 Title (2023-01-21).extension
    argsList+=('--output "%(autonumber)02d %(title)s.%(ext)s"')

    argsList+=('--extract-audio -f bestaudio --audio-format mp3')
  elif [[ "${mode}" == "${modeAll}" ]]; then
    # Filename template: 01 Title [video-id]/01 Title (2023-01-21).extension
    argsList+=('--output "%(autonumber)02d %(title)s [%(id)s]/%(autonumber)02d %(title)s (%(upload_date>%Y-%m-%d)s).%(ext)s"')

    # Restrict filenames to only ASCII characters, and avoid "&" and spaces in filenames
    argsList+=('--restrict-filenames')

    # Do not overwrite any files
    argsList+=('--no-overwrites')

    # Select best format
    # -f bestvideo[ext=mkv]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
    # -f bestvideo[ext=mkv]+bestaudio/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best
    # -f bestvideo[ext=mkv][height<=2160]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height<=2160]+bestaudio[ext=m4a]/best[ext=mp4][height<=2160]/best[height<=2160]
    args+=' -f "bestvideo[height<=2160]+bestaudio/best[height<=2160]/best"'
    argsList+=('-f "bestvideo[height<=2160]+bestaudio/best[height<=2160]/best"')

    # Encode the video to another format if necessary
    argsList+=('--recode-video mkv')

    # If a merge is required, output to given container format. [mkv, mp4, ogg, webm, flv]
    argsList+=('--merge-output-format mkv')

    # Keep the video file on disk after the post-processing
    argsList+=('--keep-video')

    # Write video description to a .description file
    argsList+=('--write-description')

    # Embed metadata and chapters
    argsList+=('--embed-metadata')

    ################################################################################
    # Subtitles

    # Download all the available subtitles
    #argsList+=('--all-subs')

    # Languages of the subtitles
    argsList+=('--sub-lang en,de')

    # Convert the subtitles to other format [srt, ass, vtt, lrc]
    argsList+=('--convert-subs srt')

    # Write subtitle file
    argsList+=('--write-sub')

    # Write automatically generated subtitle file
    argsList+=('--write-auto-sub')

    # Embed subtitles in the video [mp4, webm, mkv]
    argsList+=('--embed-subs')
  fi

  textDone="$(translate 'Script done')";
  textDoneColor=$(textColor 2 "${textDone}")

  args="${argsList[@]}"
  exec gnome-terminal --working-directory="${folderDestination}" -- bash -c "yt-dlp ${args} \"${url}\"; echo -e \"${textDoneColor}\"; sleep 10"
fi
