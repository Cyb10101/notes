#!/usr/bin/env bash

# sudo install ~/Sync/notes/System/Linux/Scripts/create-temp.sh /usr/local/bin/create-temp
# test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
# ln -s /usr/local/bin/create-temp ${XDG_DESKTOP_DIR:-${HOME}/Desktop}/create-temp

createLauncher() {
  if [ ! -f /usr/share/applications/create-temp.desktop ]; then
    cat <<EOF | sudo tee /usr/share/applications/create-temp.desktop > /dev/null
[Desktop Entry]
Name=Temporary Directory
Comment=Create a temporary Directory
Exec="/usr/local/bin/create-temp"
TryExec=/usr/local/bin/create-temp
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

  varDate=`date +%Y-%m-%d_%H-%M`; # date +%Y-%m-%d_%H-%M-%S
  varFolder=`mktemp -d "${rootPath}/${prefix}${varDate}_XXXXXXXX"`
  chmod 750 "${varFolder}"
}

createTemporaryFolder ~/Downloads 'tmp_'

xdg-open ${varFolder} &
exit 0
