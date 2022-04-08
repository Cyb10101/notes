#!/bin/bash

# Connect Wifi
read -p 'Connect Wifi? [y/N] ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nmtui
    #nmcli dev wifi connect "${SSID}" --ask
    #nmcli dev wifi connect "${SSID}" password "${PASSWORD}"
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

# Background
mkdir -p ~/opt
if [ -f 'deploy/background.jpg' ]; then
    cp 'deploy/background.jpg' ~/opt/background.jpg
    gsettings set org.gnome.desktop.background picture-uri "file://${HOME}/opt/background.jpg"
fi

# General ( dconf watch / )
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

# Energy: Disable suspend
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

# Set locale
LANG=de_DE.UTF-8
sudo locale-gen ${LANG}
sudo update-locale LANG=${LANG}
sudo dpkg-reconfigure --frontend=noninteractive locales
sudo dpkg-reconfigure --frontend=noninteractive keyboard-configuration

# Set timezone
sudo timedatectl set-timezone Europe/Berlin

# Update package lists
sudo add-apt-repository -y multiverse
sudo apt update

# Remove software
sudo apt -y remove ubiquity thunderbird
sudo apt -y remove aisleriot gnome-mahjongg gnome-mines gnome-sudoku
sudo apt -y remove gnome-todo transmission*
sudo apt -y remove libreoffice*

if [ -f ~/Desktop/ubiquity.desktop ]; then
    rm ~/Desktop/ubiquity.desktop
fi

# Install software
sudo apt -y install p7zip-full p7zip-rar rar unrar-free
sudo apt -y install gedit vim ncdu
sudo apt -y install novnc x11vnc net-tools

# Package cleanup
sudo apt -y autoremove
sudo apt clean

# Add VNC Script
cp deploy/vnc.sh ~/Desktop/vnc.sh
chmod +x ~/Desktop/vnc.sh

# Set favorite apps
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop']"

# Update system
sudo apt -y full-upgrade
