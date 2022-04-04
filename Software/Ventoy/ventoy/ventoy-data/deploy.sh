#!/bin/bash

# Connect Wifi
read -p 'Connect Wifi? [y/N] ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nmcli dev wifi connect 'SSID' password 'PASSWORD'
    sleep 3
fi

# Mount Ventoy-Data
read -p 'Mount Ventoy-Data? [y/N] ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    UUID=$(lsblk -o uuid $(blkid --label 'ventoy-data' -o value) | tail -1)
    fstabNtfs="UUID=${UUID} /media/ventoy-data ntfs rw,user,auto,uid=$(id -u),gid=$(id -g),umask=0077 0 0"
    sudo mkdir -p /media/ventoy-data
    echo "${fstabNtfs}" | sudo tee --append /etc/fstab
fi

# General
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.background picture-options 'scaled'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'owner', 'group', 'permissions']"
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'

gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'never'

# Workspaces on all monitors
gsettings set org.gnome.mutter workspaces-only-on-primary false

# Dock position
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true

# Update system
sudo apt update
sudo add-apt-repository -y multiverse
sudo apt -y remove ubiquity thunderbird
sudo apt -y install p7zip-full p7zip-rar rar unrar-free
sudo apt -y install novnc x11vnc net-tools

# Add VNC Script
cp deploy/vnc.sh ~/Desktop/vnc.sh
chmod +x ~/Desktop/vnc.sh
