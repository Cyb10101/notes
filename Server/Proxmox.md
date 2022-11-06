# Proxmox

* [Proxmox](https://www.proxmox.com/)
* [Proxmox Virtal Environment Images](https://www.proxmox.com/en/downloads/category/iso-images-pve)

VirtualBox:

* Network > Networkbridge 1 > Extended (German: Erweitert) > Promiscuous-Modus = erlauben für allen VMs und den Host

Default username: root

```bash
# Remove enterprise notice by apt
echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data.status/{s/\!//;s/Active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" > /etc/apt/apt.conf.d/no-nag-script
apt --reinstall install proxmox-widget-toolkit
# apt update && apt -y dist-upgrade
# [ -f /var/run/reboot-required ] && sudo reboot -f
```

```bash
# Remove enterprise sources, add community sources
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.disabled
echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-community.list

# @todo Maybe not needed
# Remove enterprise notice 7.1
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# @todo Maybe not needed
# Remove enterprise notice 7.2 - Line 512: nano -c /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -Ezi.bak "s/res === null \|\| res === undefined \|\| \!res \|\| res\s+\.data\.status(\.toLowerCase\(\))? \!== '[Aa]ctive'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# @todo Maybe not needed
# Restart service
systemctl restart pveproxy.service
```

## Create Container

Network:

* Name = eth0
* Bridge = vmbr0
* Firewall = true
* IPv4 & IPv6 = DHCP

## Transfer files with croc

wget -O - https://getcroc.schollz.com | bash

cd /var/lib/vz/dump/

* Add templates: /pve/local/Container Templates
