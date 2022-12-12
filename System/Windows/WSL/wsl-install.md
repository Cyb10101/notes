# WSL (Windows Subsystem for Linux)

* [Installation Guide for Windows 10](https://docs.microsoft.com/en-gb/windows/wsl/install-win10)

## Test: Install Windows Subsystem for Linux (after build 20262)

Install Windows Subsystem for Linux in PowerShell as Administrator:

```powershell
# Install WSL
wsl --install

# Install Linux
wsl --list --online
wsl --install -d Ubuntu-22.04

# Update Kernel
wsl --status
wsl --update
wsl --shutdown
```

## Bugfix

Check if someting blocking port 53 (Error 0xffffffff) via powershell:

```powershell
Get-Process -Id (Get-NetUDPEndpoint -LocalPort 53).OwningProcess
```

## Install Windows Subsystem for Linux

Install Windows Subsystem for Linux in PowerShell as Administrator:

```powershell
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

dism.exe /Online /Enable-Feature /featurename:VirtualMachinePlatform /All /NoRestart
dism.exe /Online /Enable-Feature /featurename:Microsoft-Windows-Subsystem-Linux /All /NoRestart
wsl --set-default-version 2
```

* Recommended: Reboot

Install Linux via Windows Store:

* [Ubuntu 20.04](https://apps.microsoft.com/store/detail/ubuntu-22041-lts/9PN20MSR04DW)
* [Ubuntu 20.04](https://www.microsoft.com/store/apps/9nblggh4msv6)
* [Ubuntu 18.04](https://www.microsoft.com/store/apps/9N9TNGVNDL3Q)
* [Microsoft Store](https://aka.ms/wslstore)

Start Linux and configure it.

* [Updating the WSL 2 Linux kernel](https://docs.microsoft.com/en-GB/windows/wsl/wsl2-kernel)

```bash
wsl --list -v
wsl --set-version Ubuntu 2
wsl --set-default Ubuntu-22.04
```

Open Explorer:

* Path: `\\wsl$`
* Path: `\\wsl$\Ubuntu\home\username`
* Or in Linux `explorer.exe .`

## Configure WSL

* [wsl-install.sh](wsl-install.sh)

```bash
bash /mnt/c/Users/Cyb10101/Sync/notes/System/Windows/WSL/wsl-install.sh
```

## Uninstall or move Distribution

```bash
wsl --list -v
wsl --set-default Ubuntu-22.04
# Uninstall via Settings: ms-settings:appsfeatures
```

## Docker

* [Docker Desktop: WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/)
* [Download: Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)

* Enable WSL 2 Windows Features = true
* Restart Windows

* Start Docker Desktop
* Settings > General > Use the WSL 2 based engine = true
* Settings > General > Use Docker Compose V2 = true
* Settings > Resources > WSL Integration > Enable integration with my default WSL distro = true
* Settings > Resources > WSL Integration > Enable integration with additional distro = Ubuntu
* Apply & Restart
