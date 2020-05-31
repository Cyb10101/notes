# Syncthing

* [Syncthing](https://syncthing.net/)
* [Configure Autostart](https://docs.syncthing.net/users/autostart.html)

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

Copy files to `C:\Users\Cyb10101\opt\Syncthing`.

Open Autostart folder:

* [Windows] + [R]
* shell:startup

Create shortcut:

```bash
# Start Syncthing
C:\Users\Cyb10101\opt\Syncthing\syncthing.exe -no-console -no-browser

# Syncthing GUI
C:\Users\Cyb10101\opt\Syncthing\syncthing.exe -browser-only
```

* Run > Minimized

## Docker

```bash
# default
docker pull syncthing/syncthing:latest

# ARM Processor
docker pull linuxserver/syncthing:latest
```

* Web GUI: https://192.168.178.123:8384
* Sync Address: tcp://192.168.178.123
