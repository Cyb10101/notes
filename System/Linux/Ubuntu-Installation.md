# Ubuntu installation

Based on Ubuntu 22.04.

## Prepare system

Remove unused software, activate multiverse repository and perform system update.

```bash
sudo apt -y remove aisleriot gnome-mahjongg gnome-mines gnome-sudoku gnome-todo transmission-gtk
sudo apt -y remove rhythmbox shotwell thunderbird totem
sudo apt -y auto-remove

sudo add-apt-repository multiverse

sudo apt update && sudo apt full-upgrade

mkdir ~/opt
```

* Install: Additional drivers

## Virtual machine

```bash
# No password for sudo
sudo sh -c "echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Set permissions (Virtualbox)
sudo usermod -a -G vboxsf ${USER}
```

## Snap

* [Snapcraft Store](https://snapcraft.io/store)

## Flatpak

* [Flatpak](https://flatpak.org/setup/)
* [Flathub](https://flathub.org/apps)

```bash
sudo apt -y install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Restart system: reboot
```

## Wine

* [Wine HQ](https://winehq.org/)
* [Wine HQ: Apps](https://appdb.winehq.org/objectManager.php?sClass=application)

Linux:

```bash
sudo apt -y install wine

winecfg
# Application > Windows-Version = Windows 10
```

## Essential

* [Software installation](../../Software/Software-Installation.md)
* [Zsh notes](Zsh/Zsh.md)

```bash
sudo apt -y install diffutils git htop inxi aria2 curl iputils-ping whois vim jq exa
sudo update-alternatives --set editor /usr/bin/vim.basic

sudo apt -y install openssh-server

# File system tools
sudo apt -y install cifs-utils nfs-common sshfs ncdu

# Prettier list filesystem
sudo apt -y install exa

# Recover files
sudo apt -y install testdisk extundelete

# Compression tools
sudo apt -y install p7zip-full p7zip-rar rar unrar-free

# Desktop tools
sudo apt -y install conky-all

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

Gnome extensions:

* [Sound Input & Output Device Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)
* [Notification Banner Reloaded](https://extensions.gnome.org/extension/4651/notification-banner-reloaded/) (Recommended)
* [Notification Banner Position](https://extensions.gnome.org/extension/4105/notification-banner-position/)

```bash
sudo apt install gnome-shell-extension-manager
```

Gnome tweaks:

```bash
sudo apt -y install gnome-tweaks
```

* [Variety - Background changer](https://peterlevi.com/variety/)

```bash
sudo add-apt-repository ppa:variety/stable
sudo apt -y install variety variety-slideshow
```

## Software installation

* [Software installation](../../Software/Software-Installation.md)

## Development

```bash
sudo apt -y install mariadb-client
```

## Tor Browser

* [Tor Browser](https://www.torproject.org/)

```bash
source ~/Downloads/install-scripts.sh
aptUpdate
installTorBrowser
```

## Additional

* [HTTrack](../../Software/HTTrack.md)

* [Synergy](https://members.symless.com/synergy/downloads/list/s1)

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
# Blue Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'

# General
@todo original: '#023c88'
#gsettings set org.gnome.desktop.background primary-color '#000000'

@todo original: '#5789ca'
#gsettings set org.gnome.desktop.background secondary-color '#000000'

gsettings set org.gnome.desktop.background picture-options 'scaled'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'owner', 'group', 'permissions']"
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'never'

# Desktop icons
gsettings set org.gnome.shell.extensions.ding start-corner 'top-left'
gsettings set org.gnome.shell.extensions.ding icon-size 'small'

# Workspaces on all monitors
gsettings set org.gnome.mutter workspaces-only-on-primary false

# Dock position
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
```

### Keyboard Binding

```bash
# Unset default screenshot tool
gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'

# Set Keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['.org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot: Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'
```

### Grub: Remove Boot Splash Screen

```bash
sudo vim /etc/default/grub

# Remove "quiet splash"
GRUB_CMDLINE_LINUX_DEFAULT=""

sudo update-grub
```
