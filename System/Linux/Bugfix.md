# Linux: Bugfix

## Fixing an corrupted Windows NTFS partition

```bash
sudo apt-get install ntfs-3g ntfsprogs
sudo fdisk -l
sudo ntfsfix /dev/<device>
```

For newer Ubuntus You can use -b and -d option together.

* -b tries to fix bad clusters
* -d to fix dirty states.

```bash
sudo ntfsfix -b -d /dev/sda1
```

## Rescue an NTFS partition

```bash
sudo blkid
sudo mkdir /mnt
sudo ntfs-3g -o force,rw /dev/sda1 /mnt
```

## Fixing an corrupt Master Boot Record (untested)

```bash
sudo apt install lilo
sudo fdisk -l
sudo lilo -M /dev/ mbr
```

## Time difference in Windows and Linux

Same time for Windows and Linux.

```bash
# Status
timedatectl

# Linux use local time instead UTC
timedatectl set-local-rtc 1 --adjust-system-clock
```
