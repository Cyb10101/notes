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

# Variant 1 - Date and time
createTempDateTime() {
  VAR_DATE=`date +%Y-%m-%d_%H-%M-%S`
  VAR_FOLDER=`/tmp/${1}_${VAR_DATE}`
  mkdir -p ${VAR_FOLDER}
  chmod 750 ${VAR_FOLDER}
}

# Variant 2 - Generated
createTempGenerated() {
  VAR_TIME=`date +%H-%M`
  VAR_FOLDER=`mktemp -d /tmp/${1}_${VAR_TIME}_XXXXXXXX`
  chmod 750 ${VAR_FOLDER}
}

# Variant 3 - Generated in user folder
createTempGeneratedUser() {
  if [ ! -d ~/tmp ]; then mkdir ~/tmp; fi
  VAR_DATE=`date +%Y-%m-%d_%H-%M`
  VAR_FOLDER=`mktemp -d ~/tmp/${VAR_DATE}_XXXXXXXX`
  chmod 750 ${VAR_FOLDER}
}

#createTempDateTime "${USER}"
#createTempGenerated "${USER}"
createTempGeneratedUser

xdg-open ${VAR_FOLDER} &
exit 0;
