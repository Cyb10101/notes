# Windows Installation

```powershell
# PowerShell Version
$PSVersionTable
```

## Package Manager: Scoop

***Note: Only english installations, if not handled in Software.***

* [Scoop: Website](https://scoop.sh)
* [Scoop: Github](https://github.com/lukesampson/scoop)
* [Scoop: Buckets](https://github.com/lukesampson/scoop#known-application-buckets)

Install as administrator (Website recommed as user):

```powershell
# Allow execution of unsigned scripts (Scoop script is not signed)
Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Confirm:$False -Force

Set-ExecutionPolicy Bypass -Scope Process -Force;
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install aria2 7zip git sudo --global; scoop bucket add extras
```

Close terminal and open a new terminal with elevated privileges:

```shell
scoop list
scoop status && scoop update && scoop update *
```

## Package Manager: Chocolatey

Multilingual installation.

* [Chocolatey](https://chocolatey.org/)
* [Chocolatey: Packages](https://chocolatey.org/packages)

Run `powershell` as administrator.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); choco feature enable -n allowGlobalConfirmation
```

Close powershell and run `choco` in `cmd` or `powershell` as administrator.

```shell
choco list --localonly
choco outdated && choco upgrade all
```

## Package Manager: WinGet

Currently in development.

* [WinGet: Store](https://www.microsoft.com/de-de/p/app-installer/9nblggh4nns1) (Recommended)
* [WinGet: Github](https://github.com/microsoft/winget-cli)

## General

* [Windows Terminal: Store](https://www.microsoft.com/de-de/p/windows-terminal/9n0dx20hk701) (Recommended)
* [Windows Terminal: Github](https://github.com/microsoft/terminal)

```shell
# choco install microsoft-windows-terminal
```

* [7-Zip](https://www.7-zip.org/) (Required by Scoop installation)
* [Aria2](https://aria2.github.io/) (Required by Scoop installation)
* [Croc](https://github.com/schollz/croc) (File transfer)
* [Restic](https://github.com/restic/restic) (Backup)

* 7-Zip > Tools > Options > System > Associate with 7-Zip
* 7-Zip > Tools > Options > Language > Language = German (Deutsch)

```shell
sudo scoop install aria2 7zip croc restic --global
```

## Office

* [Mozilla Firefox](https://www.mozilla.org/firefox/)
* [Mozilla Thunderbird](https://www.mozilla.org/thunderbird/)
* [Google Chrome](https://www.google.de/chrome/)
* [LibreOffice](https://de.libreoffice.org/download/download/)
* [PDFsam](https://pdfsam.org/)

## Text Editor / IDE

* [Atom](https://atom.io/)
* [Geany](https://www.geany.org/)
* [Notepad++](https://notepad-plus-plus.org/)
* [Visual Studio Code](https://code.visualstudio.com/)

```powershell
#$tools.lazyInstall("Visual Studio Code", "https://update.code.visualstudio.com/latest/win32-x64-user/stable", "vscode.exe", "/verysilent /suppressmsgboxes /MERGETASKS=!runcode")
```

## Multimedia

* [Spotify](https://spotify.com/)
* [VLC](http://www.videolan.org/vlc/)
* [Kodi](https://kodi.tv/)
* [HandBrake](https://handbrake.fr/downloads.php)
* [fre:ac](https://www.freac.org/)

## Grafik / Video

* [XnView](https://www.xnview.com/)
* [FastStone Image Viewer](https://www.faststone.org/FSViewerDetail.htm)

* [Gimp](https://www.gimp.org/)
* [Inkscape](https://inkscape.org/)

* [Flameshot](https://github.com/lupoDharkael/flameshot) (Recommended)
* [Greenshot](https://getgreenshot.org/)
* [LightShot](https://app.prntscr.com/)

* [ScreenToGif](http://screentogif.com/)

* [MP3Tag](https://www.mp3tag.de/)

* [OBS Studio](https://obsproject.com/)
* [MkvToolNix](https://mkvtoolnix.download/)
* [ffmpeg](https://www.ffmpeg.org/)

## Brenntools

* [Etcher](https://www.balena.io/etcher/)
* [Rufus](https://rufus.akeo.ie/)
* [ImgBurn](http://www.imgburn.com/)
* [InfraRecorder](http://infrarecorder.org/)
* [CDBurnerXP](https://cdburnerxp.se/)
* [WinCDEmu](https://wincdemu.sysprogs.org/)

## Komprimierungstools

* [7-Zip](http://7-zip.org/)
* [WinRAR](https://www.winrar.de/)

## Entwicklung

* [PhpStorm](https://www.jetbrains.com/phpstorm/)
* [Meld](http://meldmerge.org/)
* [LinkChecker](https://wummel.github.io/linkchecker/)
* [Poedit](https://poedit.net/)

## Tools

* [JDownloader](http://jdownloader.org/)
* [pkColorPicker](http://www.color-picker.de/)
* [ReNamer](https://www.den4b.com/products/renamer)
* [Fotosizer](http://www.fotosizer.com/)
* [TreeSize](https://www.jam-software.de/treesize_free/)
* [WinDirStat](https://windirstat.net/)

* [FreeFileSync](https://freefilesync.org/)
* [Synchredible](https://www.ascomp.de/de/products/synchredible/)

## Instant Messenger / Voice Over IP

* [Discord](https://discordapp.com/)
* [Teamspeak](https://www.teamspeak.com/)

* [Threema](https://threema.ch/)
* [Wire](https://wire.com/)
* [Signal](https://signal.org/)

* [Telegram](https://telegram.org/)
* [WhatsApp](https://www.whatsapp.com/download/)

## Internet / Cloud

* [Dropbox](https://www.dropbox.com/)
* [Google Drive](https://drive.google.com/)
* [Seafile](https://www.seafile.com/)

## Internet / Server

* [FileZilla Client](https://filezilla-project.org/download.php?type=client)
* [HeidiSQL](https://www.heidisql.com/)

## Sonstiges

* [VirtualBox](https://www.virtualbox.org/)

* [TeamViewer](https://www.teamviewer.com/)
* [AnyDesk](https://anydesk.com/)

## Ram Drive

* [ImDiskTk](http://www.ltr-data.se/opencode.html/#ImDisk)
* [ImDiskTk Download](https://sourceforge.net/projects/imdisk-toolkit/)

```shell
choco install imdisk-toolkit
```

## Sicherheit

* [Bitwarden](https://bitwarden.com/)
* [KeePass](https://keepass.info/)
* [KeePassDroid](https://play.google.com/store/apps/details?id=com.android.keepass)
* [KeePassX](https://www.keepassx.org/)


```shell
choco install keepass keepass-langfiles
```

## Spiele Clients & Software

* [Steam Client](http://store.steampowered.com/)
* [DOSBox](https://www.dosbox.com/)
* [Twitch](https://www.twitch.tv/)

## System (Windows zu Linux)

* [WSL - Windows Subsystem for Linux](WSL/wsl-install.md)
* [Cygwin](https://cygwin.com/)

* [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)
* [WinSCP](https://winscp.net/)

```shell
sudo scoop install putty --global
```

## System (Windows)

* [Disk2vhd](https://docs.microsoft.com/en-us/sysinternals/downloads/disk2vhd)

```shell
# choco install disk2vhd
```

## Rest

* [Adobe Flash Player](https://get.adobe.com/flashplayer/)
* [OpenJDK](http://openjdk.java.net/projects/jdk9/)
* [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)
* [Oracle Java](https://www.java.com/)

* [ChanSort](https://github.com/PredatH0r/ChanSort/releases/latest) (Sort TV Channels)
* [Linphone](https://www.linphone.org/)
* [BackUp Maker](https://www.ascomp.de/de/products/backupmaker/)
* [Synchredible](https://www.ascomp.de/de/products/synchredible/)

```shell
choco install chansort

sudo scoop install linphone --global
#$tools.lazyInstall("Linphone", "https://www.linphone.org/releases/windows/app/Linphone-4.2.5-win32.exe", "Linphone.exe", "/S")

#$tools.lazyInstall("Backup Maker", "https://www.ascomp.de/de/download/bkmaker.exe", "bkmaker.exe", "/SILENT /NORESTART")

choco install rsync
```
