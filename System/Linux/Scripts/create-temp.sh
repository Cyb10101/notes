#!/usr/bin/env bash

# sudo install ~/Sync/notes/System/Linux/Scripts/create-temp.sh /usr/local/bin/create-temp
# test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
# ln -s /usr/local/bin/create-temp ${XDG_DESKTOP_DIR:-${HOME}/Desktop}/create-temp

# Variant 1 - Date and time
createTempDateTime() {
  VAR_DATE=`date +%F`
  VAR_TIME=`date +%H-%M-%S`
  VAR_FOLDER='/tmp/'${1}'_'${VAR_DATE}'_'${VAR_TIME}
  mkdir -p ${VAR_FOLDER}
  chmod 750 ${VAR_FOLDER}
}

# Variant 2 - Generated
createTempGenerated() {
  VAR_TIME=`date +%H-%M`
  VAR_FOLDER=`mktemp -d /tmp/${1}_${VAR_TIME}_XXXXXXXX`
  chmod 750 ${VAR_FOLDER}
}

#createTempDateTime "${USER}"
createTempGenerated "${USER}"

xdg-open ${VAR_FOLDER} &
exit 0;
