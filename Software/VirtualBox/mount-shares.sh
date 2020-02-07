#!/usr/bin/env bash

colorRed='\033[0;31m'
colorGreen='\033[0;32m'
colorYellow='\033[0;33m'
colorReset='\033[0m'

checkGroup() {
  if getent group vboxsf | grep -q "\b${USER}\b"; then
    echo -e "${colorGreen}Virtualbox group already added${colorReset}"
  else
    sudo usermod -a -G vboxsf ${USER}
    echo -e "${colorGreen}Virtualbox group added${colorReset}"
    echo -e "${colorYellow}You need to logout or reboot!${colorReset}"
  fi
}

mountShare() {
  share=${1}
  if mountpoint -q "/media/sf_${share}"; then
    echo -e "${colorYellow}Virtualbox folder already mounted!${colorReset}"
  else
    sudo mkdir -p /media/sf_${share}
    sudo mount -t vboxsf ${share} /media/sf_${share}
  fi
}

openInNautilus() {
  nautilus /media/sf_${1} &
}

checkGroup
mountShare "public"
openInNautilus "public"
