# Shrink VHD/VHDX

Open `PowerShell` as administrator.

Check file size:

```powershell
wsl -d Ubuntu -e bash -c "du -h `$(wslpath -a '$env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx')"
dir $env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx
```

Stop Docker & WSL:

```powershell
net stop com.docker.service
taskkill /IM "docker.exe" /F
taskkill /IM "Docker Desktop.exe" /F
wsl --shutdown
```

Compact virtual disk:

```powershell
## Variante 1: Maybe not official released or in windows version [untestet]
Optimize-VHD -Path $env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx -Mode Full

## Variante 2
diskpart
select vdisk file="%LOCALAPPDATA%\Docker\wsl\data\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit
```

Start Docker & WSL:

```powershell
wsl
exit

net start com.docker.service
# Run Docker Desktop
```
