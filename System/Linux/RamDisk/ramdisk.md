# RAM Disk / RAM Drive

Create a persistent RAM Disk.

## Installation

```bash
sudo mkdir -p /usr/lib/cyb
sudo cp ./ramdisk.sh /usr/lib/cyb/ramdisk.sh
sudo cp ./ramdisk.service /lib/systemd/system/ramdisk.service

# Adjust variables
sudo vim /usr/lib/cyb/ramdisk.sh
```

## Service

Enable RAM Disk service:

```bash
sudo systemctl enable ramdisk.service
sudo systemctl start ramdisk.service
sudo systemctl status ramdisk
```

Disable RAM Disk service:

```bash
sudo systemctl stop ramdisk.service
sudo systemctl disable ramdisk.service
sudo systemctl status ramdisk
```
