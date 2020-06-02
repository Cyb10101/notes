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

wget -O ~/.config/autostart/syncthing-start.desktop https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-desktop/syncthing-start.desktop
wget -O ~/.local/share/applications/syncthing-ui.desktop https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-desktop/syncthing-ui.desktop
```

## Windows

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

* Name: Syncthing GUI
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
