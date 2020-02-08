# Linux: VPN

Install VPN plugins:

```bash
sudo apt install openvpn bridge-utils network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp network-manager-pptp-gnome network-manager-vpnc network-manager-vpnc-gnome network-manager-openconnect network-manager-openconnect-gnome

sudo service network-manager restart
```

## Import OpenVPN settings

```bash
sudo nmcli connection import type openvpn file ~/opt/vpn/open-vpn.ovpn
```

## Autostart VPN

Configure password for all users:

* Network Manager > Configure VPN > Identity > Password icon > Save password for all users

Automatic connect VPN with Network:

* Open `nm-connection-editor﻿﻿` (Network Connections - it's part of NetworkManager)
* Choose your WiFi or LAN connection
* Edit > "General" tab > Automatically connect to VPN when using this connection = true
* Choose VPN connection

## Cyberghost

Currently only use network manager.

### App installation

If UEFI/Secure Boot is activated, this must be installed first before installing Cyberghost:

```bash
sudo apt install wireguard
```

Then install Cyberghost.

@todo 2019-02-04 Cyberghost can not be installed:

```bash
# Also run in the Cyberghost installation script:
sudo cyberghostvpn --setup

Do you want to override the original configuration file? [Y/n]: y
Setup account ...
Enter CyberGhost username and press [ENTER]: **********
Enter CyberGhost password and press [ENTER]: **********
Traceback (most recent call last):
File "cyberghostvpn.py", line 761, in <module>
File "cyberghostvpn.py", line 370, in main
File "cyberghostvpn.py", line 233, in setup
File "cyberghostvpn.py", line 84, in createAccount
File "libs/config.py", line 90, in getConfig
Exception: The section "account" is missing configuration file!
```
