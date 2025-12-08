#!/usr/bin/env bash

# Install
# sudo install ~/Sync/notes/System/Linux/Scripts/create-temporary-folder.sh /usr/local/bin/create-temporary-folder

# Desktop icon
# test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
# ln -s /usr/local/bin/create-temporary-folder ${XDG_DESKTOP_DIR:-${HOME}/Desktop}/create-temporary-folder

createLauncher() {
  if [ ! -f /usr/share/applications/create-temporary-folder.desktop ]; then
    cat <<EOF | sudo tee /usr/share/applications/create-temporary-folder.desktop > /dev/null
[Desktop Entry]
Name=Temporary folder
Comment=Create a temporary folder
Exec="/usr/local/bin/create-temporary-folder"
TryExec=/usr/local/bin/create-temporary-folder
Terminal=false
Type=Application
Icon=/usr/share/icons/Yaru-blue/256x256/actions/folder-new.png
#Icon=/usr/share/icons/elementary-xfce/actions/128/folder-new.png
Categories=Utility;
EOF
  fi
}

createTemporaryFolder() {
  local rootPath=${1}
  local prefix=${2}
  if [ ! -d "$rootPath" ]; then
    mkdir -p "$rootPath"
  fi

  folderName=$(zenity --entry --title='Temporary folder' --text='Folder name:')
  [ $? -eq 0 ] || exit 1

  local varDate=`date +%Y-%m-%d`; # date +%Y-%m-%d_%H-%M-%S

  if [ ! -z "$folderName" ]; then
    if [ ! -d "${rootPath}/${prefix}${varDate}_${folderName}" ]; then
      varFolder="${rootPath}/${prefix}${varDate}_${folderName}"
      mkdir "$varFolder"
    else
      varFolder=`mktemp -d "${rootPath}/${prefix}${varDate}_${folderName}_XXXXXXXX"`
    fi
  else
    folderName=`date +%H-%M`;
    varFolder=`mktemp -d "${rootPath}/${prefix}${varDate}_${folderName}_XXXXXXXX"`
  fi

  chmod 750 "${varFolder}"
}

createTemporaryFolder ~/Downloads 'tmp_'

xdg-open "${varFolder}" &
exit 0
