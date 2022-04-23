# Syncthing

* [Syncthing](https://syncthing.net/)
* [Github latest release](https://github.com/syncthing/syncthing/releases/latest)
* [Configure Autostart](https://docs.syncthing.net/users/autostart.html)
* [Android FAQ](https://github.com/syncthing/syncthing-android/wiki/Frequently-Asked-Questions)

## Antivirus

Maybe you want to exclude your Syncthing paths in your Antivirus Software.

* Windows Security > Virus & threat protection > Virus & threat protection settings > Manage settings > Exclusions > Add or remove exclusions > Add exclusion > Select folder (Translated from german)

* German: Windows-Sicherheit > Viren & Bedrohungsschutz > Einstellungen für Viren- & Bedrohungsschutz > Einstellungen verwalten > Ausschlüsse > Ausschlüsse hinzufügen oder entfernen > Ausschluss hinzufügen > Ordner wählen

## Firewall

* Port  8384/TCP Remote Web GUI
* Port 22000/TCP (or the actual listening port if you have changed the Sync Protocol Listen Address setting.)
* Port 21027/UDP (for discovery broadcasts on IPv4 and multicasts on IPv6)

## Linux

```bash
sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

sudo apt update
sudo apt install syncthing

wget -O ~/.config/autostart/syncthing-start.desktop https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop
wget -O ~/.local/share/applications/syncthing-ui.desktop https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop
```

## Windows: Via Powershell

Start `powershell` as administrator:

```powershell
# Add unzip function
# Add-Type -AssemblyName System.IO.Compression.FileSystem
# function Unzip([string]$zipfile, [string]$outpath) {[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath);}

# Download and extract files
$version = "1.18.1"
mkdir C:\opt
Invoke-WebRequest "https://github.com/syncthing/syncthing/releases/download/v$($version)/syncthing-windows-amd64-v$($version).zip" -OutFile C:\opt\syncthing.zip

# Unzip via Powershell function
# Unzip "C:\opt\syncthing.zip" "C:\opt"

# Unzip via Powershell
Expand-Archive -Force "C:\opt\syncthing.zip" "C:\opt"

# Unzip via 7-Zip
# Start-Process -Wait -FilePath "7z.exe" -ArgumentList "x -o`"C:\opt`" `"C:\opt\syncthing.zip`""

del C:\opt\syncthing.zip
ren "C:\opt\syncthing-windows-amd64-v$($version)" C:\opt\Syncthing

# Create shortcut in startup folder (explorer "shell:startup")
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Startup\Start Syncthing.lnk");
$s.TargetPath="C:\opt\Syncthing\syncthing.exe";
$s.WorkingDirectory="C:\opt\Syncthing";
$s.Arguments="-no-console -no-browser";
$s.WindowStyle=7;
$s.Save();

# Create shortcut in program folder (explorer "shell:programs")
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Syncthing Web UI.lnk");
$s.TargetPath="C:\opt\Syncthing\syncthing.exe";
$s.WorkingDirectory="C:\opt\Syncthing";
$s.Arguments="-browser-only";
$s.WindowStyle=7;
$s.Save();
```

* Reboot or run "Start Syncthing" in "shell:startup"
* Run: Start > Syncthing Web UI ( http://127.0.0.1:8384/ )

*Note: Syncthing updates itself.*

## Windows: Manually

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

* Web GUI: https://192.168.178.123:8384
* Sync Address: tcp://192.168.178.123

docker-compose.yml:

```yaml
version: "3.8"

services:
  syncthing:
    image: syncthing/syncthing:latest
    #restart: unless-stopped
    restart: always
    container_name: syncthing
    hostname: syncthing
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
      - UMASK_SET=022
    volumes:
      - ./.docker/syncthing:/var/syncthing
    ports:
      - "8384:8384"
      - "22000:22000/tcp"
      - "22000:22000/udp"
      #- "21027:21027/udp"
```

Run with:

```bash
docker-compose up -d
```
