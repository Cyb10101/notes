# Proxmox

* [Proxmox](https://www.proxmox.com/)
* [Proxmox Virtal Environment Images](https://www.proxmox.com/en/downloads/category/iso-images-pve)

Default username: root

## VirtualBox

* Network > Adapter 1
  * Attached to = Networkbridge
  * Advanced > Promiscuous Mode = Allow All

## Adjust sources

Remove enterprise sources and add community sources.

```bash
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.disabled

echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-community.list

systemctl restart pveproxy.service
```

## Remove enterprise notice

```bash
echo 'DPkg::Post-Invoke { "/usr/local/sbin/dpkg_proxmox-fixes.sh"; }' > /etc/apt/apt.conf.d/99-proxmox-fixes

cat << EOF | tee /usr/local/sbin/dpkg_proxmox-fixes.sh
#!/bin/bash
removeSubscriptionNotice() {
    if [ -f /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js ]; then
        echo 'Removing Proxmox subscription notice from UI ...'
        sed -Ei "s/(\.data\.status(\.toLowerCase\(\))?) !== '[aA]ctive'/\1 === 'no-more-nagging'/" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
    fi
}

removeSubscriptionNotice
EOF

chmod 644 /etc/apt/apt.conf.d/99-proxmox-fixes
chmod 744 /usr/local/sbin/dpkg_proxmox-fixes.sh

/usr/local/sbin/dpkg_proxmox-fixes.sh
apt --reinstall install proxmox-widget-toolkit
```

## Create Container

* General > Set Password
* Network
  * Name = eth0
  * Bridge = vmbr0
  * Firewall = true
  * IPv4 & IPv6 = DHCP

## Transfer files with between Proxmox

```bash
wget -O - https://getcroc.schollz.com | bash

# Container dump/backup
cd /var/lib/vz/dump/
croc send *
```

Add new templates:

* Server View: Datacenter/pve/local/Container Templates (or CT Templates)

Create CT (Create a Container by Container Template):

* General > Set Password
* Template > Use Backup file
* Network
  * Name = eth0
  * Bridge = vmbr0
  * Firewall = true
  * IPv4 & IPv6 = DHCP

Restore notes:

* Datacenter/pve/100 (CT100) > Summary > Edit Notes
