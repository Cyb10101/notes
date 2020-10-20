# Ubuntu installation

Based on Ubuntu 20.04.

## Prepare system

Remove unused software, activate multiverse repository and perform system update.

```bash
sudo apt -y remove aisleriot gnome-mahjongg gnome-mines gnome-sudoku gnome-todo transmission-gtk totem
sudo apt -y auto-remove

sudo add-apt-repository multiverse

sudo apt update && sudo apt full-upgrade
```

* Install: Additional drivers

## Virtual machine

```bash
# No password for sudo
sudo sh -c "echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Set permissions
sudo usermod -a -G vboxsf ${USER}
```

## Snap

* [Snapcraft Store](https://snapcraft.io/store)

# Flatpak

* [Flathub](https://flathub.org/apps)

```bash
sudo apt -y install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Bugfix GPG key
cat /var/lib/flatpak/repo/flathub.trustedkeys.gpg | sudo apt-key add -
```

## Essential

```bash
sudo apt -y install diffutils git htop inxi zsh aria2 curl iputils-ping whois vim
sudo update-alternatives --set editor /usr/bin/vim.basic

sudo apt -y install openssh-server

# File system tools
sudo apt -y install cifs-utils nfs-common sshfs ncdu

# Recover files
sudo apt -y install testdisk extundelete

# Compression tools
sudo apt -y install p7zip-full p7zip-rar rar unrar-free

# Desktop tools
sudo apt -y install conky-all flameshot

# System
sudo apt -y install gparted
```

## FSTAB (File system table)

Create folder, find drive with UUID:

```bash
sudo mkdir -p /mnt/linux-ext4
sudo blkid /dev/sd*
```

Edit `/etc/fstab`:

```bash
# Linux ext4
UUID=ec1e223d-b680-44f4-87de-4bba9fdf47e0	/mnt/linux-ext4	ext4	errors=remount-ro	0	1

# Windows ntfs
/dev/sdb1	/mnt/windows	ntfs	rw,user,auto,uid=1000,gid=1000,umask=0077	0	0
```

### FSTAB: SSH

Create folder and make sure that ssh connection work as root:

```bash
sudo mkdir -p /mnt/ssh/server
sudo ssh -i /home/username/.ssh/id_rsa admin@192.168.178.21
```

Edit `/etc/fstab`:

```bash
admin@192.168.178.21:/share/folder	/mnt/ssh/server		fuse.sshfs	defaults,auto,delay_connect,default_permissions,allow_other,reconnect,_netdev,uid=1000,gid=1000,umask=0077,IdentityFile=/home/username/.ssh/id_rsa	0	0
```

## Driver & Codecs

```bash
sudo apt -y install ubuntu-restricted-extras
sudo apt -y install ffmpeg faac faad flac lame libmad0 libmpcdec6 mppenc vorbis-tools wavpack

# DVD Libdvdcss
sudo apt -y install libdvd-pkg
sudo dpkg-reconfigure libdvd-pkg
```

## Tweaks / Design

Gnome tweaks:

```bash
sudo apt -y install gnome-tweaks
```

* [Variety - Background changer](https://peterlevi.com/variety/)

```bash
sudo add-apt-repository ppa:peterlevi/ppa
sudo apt -y install variety
```

## Office

* [Tor Browser](https://www.torproject.org/)

```bash
sudo apt -y install firefox thunderbird
sudo apt -y install libreoffice libreoffice-base
sudo apt -y install pdfarranger
```

LibreOffice: Change standard template
* File > Templates > Save / Organize

# Internet
sudo apt -y install mariadb-client
sudo apt -y install filezilla


## Media

* [Kodi (XBMC)](https://kodi.tv/)
* [Handbrake](https://handbrake.fr/)
* [OBS - Open Broadcaster Software](https://obsproject.com/)

```bash
# Audio: Snap no emoji support, Debian package offline
sudo snap install spotify

# Audio
sudo apt -y install audacity

# Graphic
sudo apt -y install gwenview gimp inkscape

# Video
sudo apt -y install mpv vlc
sudo apt -y install kodi
sudo apt -y install handbrake kdenlive flowblade openshot pitivi
sudo apt -y install peek

# Screencast
sudo apt -y install obs-studio ffmpeg
sudo apt -y install vokoscreen
```

* [XnView](https://www.xnview.com/)

```bash
aria2c --download-result=hide --dir=/tmp -o XnViewMP.deb https://download.xnview.com/XnViewMP-linux-x64.deb
sudo dpkg -i /tmp/XnViewMP.deb
```

* [MkvToolNix](https://mkvtoolnix.download/)

```bash
# Optional: Updates
wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | sudo apt-key add -
sudo sh -c 'echo "deb https://mkvtoolnix.download/ubuntu/ focal main" > /etc/apt/sources.list.d/mkvtoolnix.list'
sudo sh -c 'echo "deb-src https://mkvtoolnix.download/ubuntu/ focal main" >> /etc/apt/sources.list.d/mkvtoolnix.list'

# Install
sudo apt -y install mkvtoolnix mkvtoolnix-gui
```

## Burning USB: Balena Etcher

* [Balena Etcher](https://www.balena.io/etcher/)

```bash
aria2c --download-result=hide --dir=/tmp -o etcher.zip https://github.com/balena-io/etcher/releases/download/v1.5.109/balena-etcher-electron-1.5.109-linux-x64.zip
unzip /tmp/etcher.zip -d /tmp/etcher
sudo mv /tmp/etcher/balenaEtcher-*-x64.AppImage /usr/local/bin/balenaEtcher.AppImage

sudo mkdir -p /usr/local/share/icons
sudo aria2c --download-result=hide --dir=/usr/local/share/icons -o balenaEtcher.png https://github.com/balena-io/etcher/raw/master/assets/icon.png

cat <<EOF | sudo tee /usr/share/applications/balenaEtcher.desktop
#!/bin/bash
[Desktop Entry]
Name=Balena Etcher
Comment=Flash OS images to SD cards and USB drives, safely and easily.
Exec="/usr/local/bin/balenaEtcher.AppImage" %U
Terminal=false
Type=Application
Icon=/usr/local/share/icons/balenaEtcher.png
StartupWMClass=balenaEtcher
Categories=Utility;
TryExec=/usr/local/bin/balenaEtcher.AppImage
EOF
```

## Burning

```bash
sudo apt -y install k3b xfburn brasero
```

## Social

* [Telegram](https://telegram.org/)
* [Signal](https://signal.org/)
* [Slack](https://slack.com/)
* [Skype](https://www.skype.com/)
* [Discord](https://discordapp.com/)

```bash
sudo snap install signal-desktop
sudo snap install slack --classic
sudo snap install skype --classic

# Problems with file permissions
#sudo snap install telegram-desktop
aria2c --download-result=hide --dir=/tmp -o telegram.tar.xz https://telegram.org/dl/desktop/linux
tar -C ~/opt -xf /tmp/telegram.tar.xz

aria2c --download-result=hide --dir=/tmp -o discord.deb https://dl.discordapp.net/apps/linux/0.0.10/discord-0.0.10.deb
sudo dpkg -i /tmp/discord.deb
sudo apt -f install
```

## Linphone

* [Linphone](https://www.linphone.org/)

```bash
sudo aria2c --download-result=hide --dir=/usr/local/bin -o Linphone.AppImage https://www.linphone.org/releases/linux/app/Linphone-4.2.3.AppImage

sudo mkdir -p /usr/local/share/icons
sudo aria2c --download-result=hide --dir=/usr/local/share/icons -o linphone.png https://github.com/BelledonneCommunications/linphone-desktop/raw/master/linphone-app/assets/icons/hicolor/64x64/apps/icon.png

cat <<EOF | sudo tee /usr/share/applications/Linphone.desktop
#!/bin/bash
[Desktop Entry]
Name=Linphone
Comment=Linphone is an open source SIP phone for voice/video calls and instant messaging.
Exec="/usr/local/bin/Linphone.AppImage"
Terminal=false
Type=Application
#Icon=/usr/share/icons/Yaru/scalable/actions/call-start-symbolic.svg
Icon=/usr/local/share/icons/linphone.png
StartupWMClass=linphone
Categories=Utility;
TryExec=/usr/local/bin/Linphone.AppImage
EOF
```

# Games

```bash
sudo apt -y install steam
sudo apt -y install dosbox
```

## PlayOnLinux

```bash
sudo apt -y install playonlinux
```

* [Phoenicis PlayOnLinux 5 - in Development](https://www.phoenicis.org/)

```bash
sudo flatpak install flathub org.phoenicis.playonlinux
```

## Remote Desktop

* [TeamViewer](https://www.teamviewer.com/)
* [Anydesk](https://anydesk.com/)
* [NoMachine](https://www.nomachine.com/)

```bash
aria2c --download-result=hide --dir=/tmp -o teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i /tmp/teamviewer.deb
sudo apt -f install

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo sh -c 'echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list'
sudo apt update
sudo apt install anydesk

aria2c --download-result=hide --dir=/tmp -o nomachine.deb https://download.nomachine.com/download/6.9/Linux/nomachine_6.9.2_1_amd64.deb
sudo dpkg -i /tmp/nomachine.deb
```

## Development

* [Atom](https://atom.io/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [PhpStorm](https://www.jetbrains.com/phpstorm/)

```bash
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt update
sudo apt install atom

#aria2c --download-result=hide --dir=/tmp -o atom.deb https://atom.io/download/deb
#sudo dpkg -i /tmp/atom.deb
#sudo apt -f install

sudo snap install code --classic
sudo snap install phpstorm --classic

sudo apt -y install meld
```

* [Go-Lang](https://golang.org/)

```bash
# Snap or Apt
sudo snap install go --classic
sudo apt install golang-go

# Or manually
# Uninstall: sudo rm -rf /usr/local/go
aria2c --download-result=hide --dir=/tmp -o golang.tar.gz https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /tmp/golang.tar.gz
sudo sh -c 'echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile'
```

# Configure date

Linux use local time instead UTC.

```bash
timedatectl set-local-rtc 1 --adjust-system-clock
```

# Download

* [JDownloader](https://jdownloader.org/download/index)

```bash
sudo apt -y install deluge
```

# Download

* [Dropbox](../../Software/Syncthing.md)

```bash
aria2c --download-result=hide --dir=/tmp -o dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
sudo dpkg -i /tmp/dropbox.deb
```

## Additional

* [VirtualBox](../../Software/VirtualBox/Installation.md)
* [Docker](../../Server/Docker/Installation.md)
* [HTTrack](../../Software/HTTrack.md)

* [Google Chrome](https://www.google.com/intl/de_de/chrome/)

* [Syncthing](../../Software/Syncthing.md)
* [Samba - Windows sharing](../../Software/Samba.md)

* [Insync](https://www.insynchq.com/downloads)
* [Synergy](https://members.symless.com/synergy/downloads/list/s1)

## Wine

```bash
sudo apt install wine
```

### HeidiSQL

[HeidiSQL](https://www.heidisql.com/)

```bash
mkdir -p ~/Dokumente/HeidiSQL
ln -s ../../Schreibtisch/notes/Programming/SQL ~/Dokumente/HeidiSQL/Snippets

aria2c --download-result=hide --dir=/tmp -o heidisql.exe https://www.heidisql.com/installers/HeidiSQL_11.0.0.5919_Setup.exe
wine /tmp/heidisql.exe
```

Private key file: Z:\home\username\.ssh\id_rsa.ppk

### PuTTY

[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

```bash
aria2c --download-result=hide --dir=/tmp -o putty.zip https://the.earth.li/~sgtatham/putty/latest/w32/putty.zip
mkdir -p ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
unzip /tmp/putty.zip -d ~/.wine/drive_c/Program\ Files\ \(x86\)/PuTTY
```

## Sync files

```bash
# User folders
rsync -av ./Schreibtisch/ ~/Schreibtisch/
rsync -av ./Bilder/ ~/Bilder/
rsync -av ./Dokumente/ ~/Dokumente/
rsync -av ./Musik/ ~/Musik/
rsync -av ./Vorlagen/ ~/Vorlagen/
rsync -av ./Downloads/ ~/Downloads/

# Software
rsync -av ./.mozilla/ ~/.mozilla/
rsync -av ./.thunderbird/ ~/.thunderbird/
rsync -av ./.oh-my-zsh/ ~/.oh-my-zsh/

rsync -av ./.config/filezilla/ ~/.config/filezilla/
rsync -av ./.config/spotify/ ~/.config/spotify/
rsync -av ./.config/variety/ ~/.config/variety/
rsync -av ./.config/VirtualBox/ ~/.config/VirtualBox/
rsync -av ./.config/vlc/ ~/.config/vlc/
rsync -av ./.config/xnviewmp/ ~/.config/xnviewmp/

rsync -av ./.atom/ ~/.atom/
rsync -av ./.config/Atom/ ~/.config/Atom/

rsync -av ./.config/JetBrains/ ~/.config/JetBrains/
rsync -av ./.local/share/JetBrains/ ~/.local/share/JetBrains/

# NoMachine
rsync -av ./.nx/config/ ~/.nx/config/
```

## Configuration

Install dconf and watch configuration changes:

```bash
sudo apt -y install dconf-editor
dconf watch /
```

### Apply configuration

```bash
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
```

### Keyboard Binding

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Shutdown'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-session-quit --power-off'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>F12'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command '/usr/bin/flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'Print'
```

### Grub: Remove Boot Splash Screen

```bash
sudo vim /etc/default/grub

# Remove "quiet splash"
GRUB_CMDLINE_LINUX_DEFAULT=""

sudo update-grub
```
