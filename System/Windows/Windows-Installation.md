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

## Software installation

* [Software installation](../../Software/Software-Installation.md)

## Tools

* [JDownloader](http://jdownloader.org/)
* [pkColorPicker](http://www.color-picker.de/)
* [ReNamer](https://www.den4b.com/products/renamer)
* [Fotosizer](http://www.fotosizer.com/)
* [TreeSize](https://www.jam-software.de/treesize_free/)
* [WinDirStat](https://windirstat.net/)

## Internet / Server

* [FileZilla Client](https://filezilla-project.org/download.php?type=client)
* [HeidiSQL](https://www.heidisql.com/)

## Sonstiges

* [VirtualBox](https://www.virtualbox.org/)

## Ram Drive

* [ImDiskTk](http://www.ltr-data.se/opencode.html/#ImDisk)
* [ImDiskTk Download](https://sourceforge.net/projects/imdisk-toolkit/)

```shell
choco install imdisk-toolkit
```

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

```shell
choco install chansort

choco install rsync
```
