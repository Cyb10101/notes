# Syncthing

* [Syncthing](https://syncthing.net/)
* [Configure Autostart](https://docs.syncthing.net/users/autostart.html)
* [Android FAQ](https://github.com/syncthing/syncthing-android/wiki/Frequently-Asked-Questions)

## Firewall

* Port  8384/TCP Remote Web GUI
* Port 22000/TCP (or the actual listening port if you have changed the Sync Protocol Listen Address setting.)
* Port 21027/UDP (for discovery broadcasts on IPv4 and multicasts on IPv6)

## Linux

```bash
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt update
sudo apt install syncthing

wget -O ~/.config/autostart/syncthing-start.desktop https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop
wget -O ~/.local/share/applications/syncthing-ui.desktop https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop
```

## Windows

Install via powershell or manually.

### Powershell method

Start `powershell`:

```powershell
# Add unzip function
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip {
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Download and extract files
mkdir C:\opt
Invoke-WebRequest https://github.com/syncthing/syncthing/releases/download/v1.6.1/syncthing-windows-amd64-v1.6.1.zip -OutFile C:\opt\syncthing.zip
Unzip "C:\opt\syncthing.zip" "C:\opt"
del C:\opt\syncthing.zip
ren C:\opt\syncthing-windows-amd64-v1.6.1 C:\opt\Syncthing

# Create shortcut (Startup)
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Startup\Start Syncthing.lnk");
$s.TargetPath="C:\opt\Syncthing\syncthing.exe";
$s.WorkingDirectory="C:\opt\Syncthing";
$s.Arguments="-no-console -no-browser";
$s.WindowStyle=7;
$s.Save();

# Create shortcut (Programs)
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Syncthing Web UI.lnk");
$s.TargetPath="C:\opt\Syncthing\syncthing.exe";
$s.WorkingDirectory="C:\opt\Syncthing";
$s.Arguments="-browser-only";
$s.WindowStyle=7;
$s.Save();
```

### Manually

Copy files to `C:\opt\Syncthing`.

Open autostart folder:

* [Windows] + [R]
* shell:startup

Create autostart shortcut:

* Name: Start Syncthing
* Target: "C:\opt\Syncthing\syncthing.exe" -no-console -no-browser
* Run in: "C:\opt\Syncthing"
* Run: Minimized

Open programm folder:

* [Windows] + [R]
* shell:programs

Create programm shortcut:

* Name: Syncthing Web UI
* Target: "C:\opt\Syncthing\syncthing.exe" -browser-only
* Run in: "C:\opt\Syncthing"
* Run: Minimized

## Android

SD card write support:

* Create own folder in Android
* Format the external SD Card as internal storage
* `/storage/014A-7323/Android/data/com.nutomic.syncthingandroid/files`
* Scannable by Android's Media Storage service: `/storage/014A-7323/Android/media/com.nutomic.syncthingandroid/music`

## Docker

```bash
# default
docker pull syncthing/syncthing:latest

# ARM Processor
docker pull linuxserver/syncthing:latest
```

* Web GUI: https://192.168.178.123:8384
* Sync Address: tcp://192.168.178.123
