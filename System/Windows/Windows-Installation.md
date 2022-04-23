# Windows Installation

```powershell
# PowerShell Version
$PSVersionTable
```

## Package Manager: Scoop

*Note: Only english installations, if not handled in Software.*

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

## Software installation

Update all package manger with packages, run `powershell` as administrator:

See script: [update-system.ps1](Scripts/update-system.ps1)

```powershell
# Create symlink
New-Item -Path "$env:userprofile\Desktop\update-system.ps1" -ItemType SymbolicLink -Value "$env:userprofile\Sync\notes\System\Windows\Scripts\update-system.ps1"
```

## Bugfix Scoop

```shell
cd %USERPROFILE%\scoop\buckets\extras
git fetch && git reset --hard origin/master
```

* [Software installation](../../Software/Software-Installation.md)
