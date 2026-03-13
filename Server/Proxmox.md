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
    if [ -f /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.min.js ]; then
        echo 'Overwrite Proxmox library minimized JavaScript ...'
        cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.min.js
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

## Add Samba in Proxmox

Go into Proxmox VE Shell.

Enter LXC Container and check permissions:

```bash
pct enter 102

# Get username from running application
ps aux | grep -Ei 'USER|application'
# USER   PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# app    234  0.0 10.9 273362324 230064 ?    Ssl  20:18   0:03 /usr/bin/application ...

# Get user and group id
id app
# uid=107(app) gid=110(app)

# Logout to Proxmox shell
exit
pct shutdown 102
```

Test Samba connection:

```bash
# apt install cifs-utils smbclient
smbclient -U share-username -L 192.168.178.21
```

Add folder and edit fstab:

```bash
mkdir /mnt/nas
nano /etc/fstab
```

Add to fstab:

```conf
# Samba (uid/gid=100<app user/group id>)
# <file system>                <mount point>  <type> <options> <dump> <pass>
//192.168.178.21/share/files   /mnt/nas       cifs   uid=100107,gid=100110,username=share-username,password=share-password 0 0
```

Restard daemon and mount share:

```bash
systemctl daemon-reload
mount /mnt/nas
```

Edit container configuration:

```bash
nano /etc/pve/lxc/102.conf
```

Add mount point:

```conf
# Default
mp0: /mnt/nas,mp=/mnt/nas,backup=0

# Read-only
mp0: /mnt/nas,mp=/mnt/nas,backup=0,ro=1
```

Start Container and check file permissions:

```bash
pct start 102
pct enter 102
ls -l /mnt/nas
```
