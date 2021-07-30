#!/usr/bin/env bash
set -e

# sudo install ~/Sync/notes/System/Linux/Scripts/create-ramdisk.sh /usr/local/bin/create-ramdisk
# test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
# ln -s /usr/local/bin/create-ramdisk ${XDG_DESKTOP_DIR:-${HOME}/Desktop}/create-ramdisk

ramDisk='/mnt/ramdisk'

createTempGenerated() {
  VAR_TIME=`date +%H-%M`
  ramDisk=`mktemp -d /tmp/${1}_${VAR_TIME}_XXXXXXXX`
  chmod og+r ${ramDisk}
}

guiSudo() {
  #command="${@:1}"
  #pkexec env DISPLAY=${DISPLAY} XAUTHORITY=${XAUTHORITY} sh -c '"'${command}'"'
  pkexec env DISPLAY=${DISPLAY} XAUTHORITY=${XAUTHORITY} sh -c "${@:1}"
}

checkGdialogInstalled() {
  if ! hash gdialog 2>/dev/null; then
    gdialog --title "RAM Disk" --width=200 --msgbox "GDialog is not installed!";
    guiSudo "apt install dialog"
  fi
  if ! hash gdialog 2>/dev/null; then
    gdialog --title "RAM Disk" --width=200 --msgbox "GDialog is not installed. Aborting!";
    exit 1;
  fi
}

isRamDiskMounted() {
  if grep -qs ${ramDisk} /proc/mounts; then
    return 0; # true
  else
    return 1; # false
  fi
}

checkIfNotMounted() {
  if isRamDiskMounted; then
    if zenity --title "RAM Disk" --width=210 --question --text="RAM Disk is already mounted!\nUnmount current RAM Disk?"; then
      guiSudo "umount ${ramDisk}"
      checkIfNotMounted
    else
      exit 1;
    fi
  fi
}

createRamDisk() {
  # Duplicate file descriptor 1 on descriptor 3
  exec 3>&1

  # Generate the dialog box
  set +e
  echo 1
  ramSize=$(gdialog --title "RAM Disk" --width=200 --inputbox "How much GB?" 2>&1 1>&3)
  set -e

  # Close file descriptor 3
  exec 3>&-

  # Act on the exit status
  if [[ $ramSize =~ ^-?[0-9]+$ ]] && [[ $ramSize > 0 ]]; then
    guiSudo "mkdir -p ${ramDisk} && mount -t tmpfs -o rw,size=${ramSize}G tmpfs ${ramDisk}"
  fi
}

#checkGdialogInstalled
#checkIfNotMounted
#createRamDisk
#xdg-open ${ramDisk} &

checkGdialogInstalled
createTempGenerated 'ram'
createRamDisk
xdg-open ${ramDisk} &
