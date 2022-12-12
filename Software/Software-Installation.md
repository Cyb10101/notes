# Software Installation

Requirements:

* [Ubuntu installation](../System/Linux/Ubuntu-Installation.md)
* [Windows installation](../System/Windows/Windows-Installation.md)
* [Mac OS X installation](../System/Mac-OS-X/Mac-OS-X-Installation.md)

## Essential

Compression tools:

* [7-Zip](http://7-zip.org/)
* [WinRAR](https://www.winrar.de/)

* [Rsync](https://rsync.samba.org/)
* [Zsync](https://wiki.ubuntuusers.de/zsync/)

Linux:

```bash
# Compression tools
sudo apt -y install p7zip-full p7zip-rar rar unrar-free

# Syncronisation tools
sudo apt -y install rsync zsync

# Example: http://cdimage.ubuntu.com/ubuntu/daily-live/current/
zsync http://cdimage.ubuntu.com/ubuntu/daily-live/current/kinetic-desktop-amd64.iso.zsync
```

Windows:

```shell
#choco install rsync
```

Configuration:

```text
Windows Scoop:
* 7-Zip > Tools > Options > System > Associate with 7-Zip
* 7-Zip > Tools > Options > Language > Language = German (Deutsch)
```

## General

* [Windows Terminal: Store](https://www.microsoft.com/de-de/p/windows-terminal/9n0dx20hk701) (Recommended)
* [Windows Terminal: Github](https://github.com/microsoft/terminal)

```shell
# choco install microsoft-windows-terminal
```

## Office

* [Mozilla Firefox](https://www.mozilla.org/firefox/)
* [Google Chrome](https://www.google.de/chrome/)

* [Mozilla Thunderbird](https://www.mozilla.org/thunderbird/)

* [LibreOffice](https://de.libreoffice.org/download/download/)
* [PDFsam](https://pdfsam.org/)

Linux:

```bash
sudo apt -y install firefox thunderbird

sudo add-apt-repository ppa:libreoffice/ppa
sudo apt -y install libreoffice libreoffice-base

sudo apt -y install pdfarranger
```

Configuration:

```text
LibreOffice: Change standard template: File > Templates > Save / Organize
```

## Reader: Fluent Reader (RSS)

* [Fluent Reader](https://hyliu.me/fluent-reader/)
* [Fluent Reader: Github](https://github.com/yang991178/fluent-reader)

Linux:

```bash
VERSION=$(curl -fsSL https://api.github.com/repos/yang991178/fluent-reader/releases/latest | jq -r '.tag_name' | sed -E 's/v([0-9]\.[0-9]\.[0-9])/\1/'); echo "${VERSION}"

aria2c --download-result=hide --dir=/tmp -o fluent-reader.AppImage "https://github.com/yang991178/fluent-reader/releases/download/v${VERSION}/Fluent.Reader.${VERSION}.AppImage"
sudo install /tmp/fluent-reader.AppImage /usr/local/bin/fluent-reader.AppImage

sudo mkdir -p /usr/local/share/icons
sudo aria2c --download-result=hide --dir=/usr/local/share/icons -o fluent-reader.png https://raw.githubusercontent.com/yang991178/fluent-reader/master/build/icon.png

cat <<EOF | sudo tee /usr/share/applications/fluent-reader.desktop
#!/bin/bash
[Desktop Entry]
Name=Fluent Reader
Comment=Modern desktop RSS reader built with Electron, React, and Fluent UI.
Exec="/usr/local/bin/fluent-reader.AppImage" %U
Terminal=false
Type=Application
Icon=/usr/local/share/icons/fluent-reader.png
StartupWMClass=fluent-reader
Categories=Utility;
TryExec=/usr/local/bin/fluent-reader.AppImage
EOF
```

## Reader: EBook Reader (epub)

* [Calibre](https://calibre-ebook.com/)

```bash
sudo apt -y install calibre
```

## Reader: Comic Book Reader (cbz, cbr)

* [YACReader](https://www.yacreader.com/downloads) (Recommended)

Repository not working, install [Debian package](https://software.opensuse.org/download.html?project=home%3Aselmf&package=yacreader)!

```bash
# Create a comic book
rar a -ma4 -ep1 'Comic Name.cbr' 'Pictures/'
# add to notes: ~/.local/share/nautilus/scripts
```

## Social

* [Discord](https://discord.com/)
* [Teamspeak](https://www.teamspeak.com/)

* [Threema](https://threema.ch/)
* [Wire](https://wire.com/)
* [Signal](https://signal.org/)

* [Telegram](https://telegram.org/)
* [WhatsApp](https://www.whatsapp.com/download/)

* [Slack](https://slack.com/)
* [Skype](https://www.skype.com/)

Linux:

```bash
# Discord
aria2c --download-result=hide --dir=/tmp -o discord.deb https://discord.com/api/download?platform=linux&format=deb
sudo dpkg -i /tmp/discord.deb
sudo apt -f install

# Signal
# sudo snap install signal-desktop
curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-desktop.list
sudo apt update && sudo apt -y install signal-desktop
# Autorun: signal-desktop --start-in-tray

# Telegram
# Problems with file permissions
#sudo snap install telegram-desktop
aria2c --download-result=hide --dir=/tmp -o telegram.tar.xz https://telegram.org/dl/desktop/linux
tar -C ~/opt -xf /tmp/telegram.tar.xz

# Other (Maybe append --classic)
sudo snap install slack
sudo snap install skype
```

## Signal

* Install PC Windows, Laptop Windows

```shell
curl -L -o "%LOCALAPPDATA%\Temp\signal.exe" "https://updates.signal.org/desktop/signal-desktop-win-1.34.3.exe"
"%LOCALAPPDATA%\Temp\signal.exe"
del "%LOCALAPPDATA%\Temp\signal.exe"
```

* Linux PC & Acer: kein Autostart?

sudo snap install signal-desktop
??? /snap/bin/signal-desktop --start-in-tray --use-tray-icon

## Social: Matrix - Element

* [Matrix](https://matrix.org/)
* [Element](https://element.io/)

Linux:

```bash
sudo apt -y install wget apt-transport-https
‍
sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
‍
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
‍
sudo apt update
‍
sudo apt install element-desktop
```

## Social: Linphone

* [Linphone](https://www.linphone.org/)
* [Linphone: Download](https://www.linphone.org/releases/linux/app/)

Linux:

```bash
LINPHONE_VERSION='4.4.1' && \
aria2c --download-result=hide --dir=/tmp -o Linphone.AppImage "https://www.linphone.org/releases/linux/app/Linphone-${LINPHONE_VERSION}.AppImage" && \
sudo install /tmp/Linphone.AppImage /usr/local/bin/Linphone.AppImage

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

Windows:

```shell
sudo scoop install linphone --global
#$tools.lazyInstall("Linphone", "https://www.linphone.org/releases/windows/app/Linphone-4.2.5-win32.exe", "Linphone.exe", "/S")
```

## Multimedia: Audio

* [Spotify](https://spotify.com/)
* [Audacity](https://www.audacityteam.org/download/)
* [fre:ac - Audio Converter](https://www.freac.org/downloads-mainmenu-33)

Linux:

```bash
sudo snap install spotify

sudo apt -y install audacity

sudo snap install freac
```

## Multimedia: Video

* [MPV](https://mpv.io/)
* [VLC](http://www.videolan.org/vlc/)
* [Kodi (XBMC)](https://kodi.tv/)

* [HandBrake](https://handbrake.fr/downloads.php)
* [Kdenlive](https://kdenlive.org/de/download-de/)
* [Flowblade](https://github.com/jliljebl/flowblade)
* [OpenShot](https://www.openshot.org/download/)
* [Pitivi](https://gitlab.gnome.org/GNOME/pitivi)

Linux:

```bash
sudo add-apt-repository ppa:kdenlive/kdenlive-stable
sudo apt -y install mpv vlc
sudo apt -y install kodi
sudo apt -y install handbrake kdenlive flowblade pitivi

@todo missing
sudo apt -y install openshot

# Video effects
sudo apt -y install frei0r-plugins
```

* [MkvToolNix](https://mkvtoolnix.download/downloads.html)

Linux:

```bash
# Optional: Updates
sudo wget -O /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ jammy main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list
echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ jammy main" | sudo tee -a /etc/apt/sources.list.d/mkvtoolnix.list

sudo apt update

# Install
sudo apt -y install mkvtoolnix mkvtoolnix-gui
```

## Multimedia: Graphic

* [Gwenview](https://userbase.kde.org/Gwenview/de)
* [XnView notes](XnView.md)
* [FastStone Image Viewer](https://www.faststone.org/FSViewerDetail.htm)

* [Gimp](https://www.gimp.org/downloads/)
* [Inkscape](https://inkscape.org/de/release/)

* [Czkawka - Duplicate image finder](https://github.com/qarmin/czkawka)

Linux:

```bash
sudo apt -y install gwenview gimp inkscape

VERSION=$(curl -fsSL https://api.github.com/repos/qarmin/czkawka/releases/latest | jq -r '.tag_name'); echo "${VERSION}"
curl -fsSL "https://github.com/qarmin/czkawka/releases/download/${VERSION}/linux_czkawka_gui" -o /tmp/czkawka-gui
sudo install /tmp/czkawka-gui /usr/local/bin/czkawka-gui
```

## Multimedia: Screenshot

* [Flameshot](https://github.com/flameshot-org/flameshot/releases/latest) (Recommended)
  * Einstellungen > Tab "Benutzeroberfläche" > Field "Knopfauswahl" (@todo German language)
    * Bild hochladen = false
    * Anwendungsstarter = false (Maybe Bug)
  * Einstellungen > Tab "Allgemein" > Automatisch starten = true
  * Einstellungen > Tab "Allgemein" > Zeige Willkommensnachricht beim Start = true
  * Einstellungen > Tab "Allgemein" > Speicherpfad = C:\Users\user\Downloads
* [Greenshot](https://getgreenshot.org/)
* [LightShot](https://app.prntscr.com/)

Linux:

```bash
# @bug Ubuntu 22.04 Flameshot not working on wayland https://github.com/flameshot-org/flameshot/issues/2199
echo "XDG_SESSION_TYPE = ${XDG_SESSION_TYPE} (fail if wayland)"
echo "QT_QPA_PLATFORM = ${QT_QPA_PLATFORM}"

#sudo snap install flameshot
sudo apt -y install flameshot
```

## Multimedia: Screencast

* [Vokoscreen](https://linuxecke.volkoh.de/vokoscreen/vokoscreen.html)
* [OBS - Open Broadcaster Software](https://obsproject.com/)
  * Einstellungen > Aufnahme > Modus Erweitert (@todo German language)
    * Tab "Aufnahme" > Aufnahmeeinstellungen > Aufnahmepfad = C:\Users\user\Downloads
    * Tab "Aufnahme" > Encodereinstellungen > Voreinstellung = Ununterscheidbare Aufnahme
* [OBS plugin: win-capture-audio](https://github.com/bozbez/win-capture-audio/releases/latest)
* [ffmpeg](https://www.ffmpeg.org/)

* [Peek](https://github.com/phw/peek)
* [ScreenToGif](http://screentogif.com/)

Linux:

```bash
sudo apt -y install vokoscreen

# Optional: sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio v4l2loopback-dkms ffmpeg

sudo apt -y install peek
```

## Multimedia: Other

* [MP3Tag](https://www.mp3tag.de/)

## Remote Desktop

* [TeamViewer](https://www.teamviewer.com/)
* [AnyDesk](https://anydesk.com/)
* [NoMachine](https://www.nomachine.com/)

Linux:

```bash
@todo German language
@bug: Schlüssel ist im veralteten Schlüsselbund trusted.gpg gespeichert (/etc/apt/trusted.gpg), siehe den Abschnitt MISSBILLIGUNG in apt-key(8) für Details.
aria2c --download-result=hide --dir=/tmp -o teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i /tmp/teamviewer.deb
sudo apt -f install

@todo German language
@bug: Schlüssel ist im veralteten Schlüsselbund trusted.gpg gespeichert (/etc/apt/trusted.gpg), siehe den Abschnitt MISSBILLIGUNG in apt-key(8) für Details.
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt -y install anydesk

# NoMachine Linux 64bit - https://www.nomachine.com/download/download&id=4
NOMACHINE_VERSION="7.9.2_1" && \
NOMACHINE_MD5="a24aa0b09543d207034e8198972cbd24" && \
NOMACHINE_OS="Linux" && NOMACHINE_ARCHITECTURE="amd64" && \
NOMACHINE_VERSION_SHORT=`echo ${NOMACHINE_VERSION} | cut -d. -f1-2` && \
curl -fsSL "https://download.nomachine.com/download/${NOMACHINE_VERSION_SHORT}/${NOMACHINE_OS}/nomachine_${NOMACHINE_VERSION}_${NOMACHINE_ARCHITECTURE}.deb" -o /tmp/nomachine.deb && \
echo "${NOMACHINE_MD5} /tmp/nomachine.deb" | md5sum -c - && \
sudo dpkg -i /tmp/nomachine.deb
```

## Burning tools

* [Balena Etcher](https://www.balena.io/etcher/)
* [Balena Etcher: Github](https://github.com/balena-io/etcher)
* [Rufus](https://rufus.akeo.ie/)

* [ImgBurn](https://www.imgburn.com/)
* [InfraRecorder](http://infrarecorder.org/)
* [CDBurnerXP](https://cdburnerxp.se/)
* [WinCDEmu](https://wincdemu.sysprogs.org/)

* [K3b](https://userbase.kde.org/K3b)
* [Xfburn](https://www.xfce.org/projects)
* [Brasero](https://wiki.gnome.org/Apps/Brasero)

Linux:

```bash
# @bug chmod file not found: /opt/balena-etcher-electron/chrome-sandbox
VERSION=$(curl -fsSL https://api.github.com/repos/balena-io/etcher/releases/latest | jq -r '.tag_name' | sed -r 's/v//g'); echo "${VERSION}"
curl -o /tmp/etcher.deb -fsSL "https://github.com/balena-io/etcher/releases/download/v${VERSION}/balena-etcher-electron_${VERSION}_amd64.deb"
sudo dpkg -i /tmp/etcher.deb
sudo apt install -f

# @bug: Schlüssel ist im veralteten Schlüsselbund trusted.gpg gespeichert (/etc/apt/trusted.gpg), siehe den Abschnitt MISSBILLIGUNG in apt-key(8) für Details.
curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' | sudo -E bash
sudo apt -y install balena-etcher-electron

sudo apt -y install k3b xfburn brasero
```

## Games

* [Steam Client](http://store.steampowered.com/)
* [Blizzard Battle.net Client](https://www.blizzard.com/de-de/apps/battle.net/desktop)

* [Amazon Games Client](https://www.amazongames.com/de-de/support/prime-gaming/articles/download-and-install-the-amazon-games-app)
* [Amazon - Prime Gaming](https://gaming.amazon.com/home)

* [Epic Games Client](https://www.epicgames.com/store/de/download)
* [EA (Electronic Arts) Client](https://www.ea.com/de-de/ea-app)
* [Itch Client](https://itch.io/app)

* [CurseForge Client](https://download.curseforge.com/)

```bash
sudo apt -y install steam
```

## File synchronization

* [Syncthing](Syncthing.md)

* [Dropbox](https://www.dropbox.com/)
* [Google Drive](https://drive.google.com/)

* [Rsync](https://rsync.samba.org/)
* [FreeFileSync](https://freefilesync.org/)
* [Synchredible](https://www.ascomp.de/de/products/synchredible/)

* [TeraCopy](https://www.codesector.com/teracopy)

Linux:

```bash
# @bug: Schlüssel ist im veralteten Schlüsselbund trusted.gpg gespeichert (/etc/apt/trusted.gpg), siehe den Abschnitt MISSBILLIGUNG in apt-key(8) für Details.
aria2c --download-result=hide --dir=/tmp -o dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
sudo apt -y install python3-gpg
sudo dpkg -i /tmp/dropbox.deb
sudo apt install -f
```

## Backup

* [Restic notes](../Software/Restic.md)
* [rdiff-backup notes](../Software/rdiff-backup.md)
* [ascomp - BackUp Maker](https://www.ascomp.de/de/products/backupmaker/)

Windows:

```shell
sudo scoop install restic --global

#$tools.lazyInstall("Backup Maker", "https://www.ascomp.de/de/download/bkmaker.exe", "bkmaker.exe", "/SILENT /NORESTART")
```

## File transfer

* [Croc](https://github.com/schollz/croc)
* [Aria2](https://aria2.github.io/)

* [JDownloader](https://jdownloader.org/download/index)
* [Deluge](https://www.deluge-torrent.org/)

* [Samba - Windows sharing](../../Software/Samba.md)

Linux:

```bash
curl https://getcroc.schollz.com | bash

sudo apt -y install aria2
sudo apt -y install deluge
```

Windows:

```shell
sudo scoop install aria2 croc --global

croc --relay "example.de:9009" send [filename]
```

Windows Bugfix:

```bash
# If Windows Port 9009 is blocked
croc send --no-local file.txt
croc send --ports "9010,9011,9012,9013" file.txt
```

## Security

Password Manager:

* [Bitwarden](https://bitwarden.com/)
* [KeePass](https://keepass.info/)
* [KeePassDroid](https://play.google.com/store/apps/details?id=com.android.keepass) (Android)
* [KeePassX](https://www.keepassx.org/)

VPN:

* [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)

Windows:

```shell
choco install keepass keepass-langfiles
```

## Text Editor / IDE

* [Atom](https://atom.io/)

Linux:

```bash
@bug crashed
VERSION=$(curl -fsSL https://api.github.com/repos/atom/atom/releases/latest | jq -r '.tag_name' | sed -r 's/v//g'); echo "${VERSION}"
curl -o /tmp/etcher.deb -fsSL "https://github.com/atom/atom/releases/download/v${VERSION}/atom-amd64.deb"
sudo dpkg -i /tmp/etcher.deb
sudo apt install -f

@bug: Schlüssel ist im veralteten Schlüsselbund trusted.gpg gespeichert (/etc/apt/trusted.gpg), siehe den Abschnitt MISSBILLIGUNG in apt-key(8) für Details.
@bug crashed
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt update
sudo apt -y install atom

#aria2c --download-result=hide --dir=/tmp -o atom.deb https://atom.io/download/deb
#sudo dpkg -i /tmp/atom.deb
#sudo apt -f install
```

## Development

* [Visual Studio Code](https://code.visualstudio.com/)
* [Notepad++](https://notepad-plus-plus.org/)

* [PhpStorm](https://www.jetbrains.com/phpstorm/)

* [Meld](http://meldmerge.org/)
* [LinkChecker](https://wummel.github.io/linkchecker/)
* [Poedit](https://poedit.net/)

Linux:

```bash
sudo snap install code --classic
sudo snap install phpstorm --classic

sudo apt -y install meld
```

Windows:

```powershell
#$tools.lazyInstall("Visual Studio Code", "https://update.code.visualstudio.com/latest/win32-x64-user/stable", "vscode.exe", "/verysilent /suppressmsgboxes /MERGETASKS=!runcode")
```

## Development: Languages & Tools

* [jq: JSON processor](https://stedolan.github.io/jq/)
* [yq, xq: YAML/XML processor](https://github.com/kislyuk/yq)

Linux:

```bash
sudo apt -y install jq python3 python3-pip
sudo pip3 install yq
```

* [Go-Lang](https://golang.org/)

Linux:

```bash
# Snap or Apt
sudo snap install go --classic
sudo apt install golang-go

# Or manually
# Uninstall: sudo rm -rf /usr/local/go
VERSION="1.17.7"
curl -o /tmp/golang.tar.gz -fsSL "https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf /tmp/golang.tar.gz
sudo sh -c 'echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile'
# sudo sh -c 'echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc'
```

## Tools

* [pkColorPicker](http://www.color-picker.de/)
* [ReNamer](https://www.den4b.com/products/renamer)
* [Fotosizer](http://www.fotosizer.com/)

Disk space analyser:

* [RidNacs](https://www.splashsoft.de/ridnacs-disk-space-usage-analyzer/)
* [TreeSize](https://www.jam-software.de/treesize_free/)
* [WizTree](https://www.diskanalyzer.com/download)
* [WinDirStat](https://windirstat.net/)

## Internet / Server

* [FileZilla Client](https://filezilla-project.org/download.php?type=client)

Linux:

```bash
sudo apt -y install filezilla
```

* [HeidiSQL](https://www.heidisql.com/download.php)

Linux with Wine:

```bash
mkdir -p ~/Dokumente/HeidiSQL
ln -s ../../Sync/notes/Programming/SQL ~/Dokumente/HeidiSQL/Snippets

aria2c --download-result=hide --dir=/tmp -o heidisql.exe https://www.heidisql.com/installers/HeidiSQL_12.0.0.6468_Setup.exe
wine /tmp/heidisql.exe

# Tools > Preferences > Application style = Windows10
# Private key file: Z:\home\username\.ssh\id_rsa.ppk
```

## SFTP Drive

* [NSoftware SFTP Drive](https://www.nsoftware.com/sftp/drive/order.aspx)
* [RaiDrive](https://www.raidrive.com/download)

## Ram Drive

* [Linux RamDisk](../System/Linux/RamDisk/ramdisk.md)
* [ImDiskTk](http://www.ltr-data.se/opencode.html/#ImDisk)
* [ImDiskTk Download](https://sourceforge.net/projects/imdisk-toolkit/)

```shell
choco install imdisk-toolkit
```

## TV Liste

* [ChanSort](https://github.com/PredatH0r/ChanSort/releases/latest) (Sort TV Channels)

```shell
choco install chansort
```

## Virtualisierung

* [Docker](../Server/Docker/Installation.md)
* [LXD/LXC](../Server/LXD-LXC.md)
* [VirtualBox](VirtualBox/Installation.md)

* [GNOME Boxes](https://wiki.gnome.org/Apps/Boxes)

```bash
flatpak install -y flathub org.gnome.Boxes
```

* [Disk2vhd](https://docs.microsoft.com/en-us/sysinternals/downloads/disk2vhd)

```shell
# choco install disk2vhd
```

## PlayOnLinux

```bash
sudo apt -y install playonlinux
```

* [Phoenicis PlayOnLinux 5 - in Development](https://www.phoenicis.org/)

```bash
flatpak install flathub org.phoenicis.playonlinux
```

## Windows terminal to Linux

* [WSL - Windows Subsystem for Linux](WSL/wsl-install.md) (Recommended)
* [Cygwin](https://cygwin.com/)

* [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* [WinSCP](https://winscp.net/)

Windows:

```shell
sudo scoop install putty --global
```

## Other

* [OpenJDK](http://openjdk.java.net/projects/jdk9/)
* [Oracle Java](https://www.java.com/)
