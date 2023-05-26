# Proxmox

* [Proxmox](https://www.proxmox.com/)
* [Proxmox Virtal Environment Images](https://www.proxmox.com/en/downloads/category/iso-images-pve)

Default username: root

## VirtualBox

* Network > Adapter 1
  * Attached to = Bridget Adapter / Networkbridge
  * Advanced > Promiscuous Mode = Allow All (VMs and Host)

## Installation

* Mail = mail@example.com

Adjust sources:

* Server View: Datacenter/pve > Shell

```bash
# Remove enterprise sources
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.disabled

# Add community sources
echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-community.list

# Restart Proxmox
systemctl restart pveproxy.service
```

Remove enterprise notice:

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

## Add templates

* Server View: Datacenter/pve/local > CT Templates (or Container Templates)
* Templates
* Download Ubuntu 22.04

## Create Container

* General > Set Password
* Template > Use container template or backup file
* Network
  * Name = eth0
  * Bridge = vmbr0
  * Firewall = true
  * IPv4 & IPv6 = DHCP

Restore notes:

* Datacenter/pve/100 (CT100) > Summary > Edit Notes

## Transfer files with between Proxmox

Configure SSH:

```bash
# Allow root login via SSH
sed -i -r 's/^#?(PermitRootLogin).*$/\1 yes/g' /etc/ssh/sshd_config && systemctl restart ssh

# Allow root login via SSH, but only ssh keys
sed -i -r 's/^#?(PermitRootLogin).*$/\1 prohibit-password/g' /etc/ssh/sshd_config && systemctl restart ssh

# Disallow root login via SSH
sed -i -r 's/^#?(PermitRootLogin).*$/\1 no/g' /etc/ssh/sshd_config && systemctl restart ssh
```

Use Croc:

```bash
wget -O - https://getcroc.schollz.com | bash

# Container dump/backup
cd /var/lib/vz/dump/
croc send *
```
