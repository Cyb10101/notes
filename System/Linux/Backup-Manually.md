# Linux backup manually

A example how to backup a Linux system manually.

## Backup

You should already have a backup of your important files.
Even if a backup is made here, something can always go wrong.

## Cleanup Space

```bash
# Remove Docker images, build cache
docker system df
docker image prune -a
docker builder prune -a

# Remove Snap Snapshots
sudo snap saved
sudo snap forget <id/groupId>

# Remove old Snaps
LANG=C sudo snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
    sudo snap remove "$snapname" --revision="$revision"
done
```

## Backup partition table

```bash
# Check devices
sudo lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT,MODEL /dev/sd?
sudo lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT,MODEL /dev/sda

# Check if partition type is gpt or other
LANG=C sudo fdisk -l /dev/sda

# Save device info
sudo lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT,MODEL /dev/sda >> device-info_sda.txt
echo '' >> device-info_sda.txt
LANG=C sudo fdisk -l /dev/sda >> device-info_sda.txt

# Backup partition table for non-gpt partitions
sudo sfdisk --dump /dev/sda > sfdisk_sda.txt

# Backup partition table for gpt partitions
sudo sgdisk -b sgdisk_sda.img /dev/sda
```

## Backup your other partitions

```bash
sudo dd if=/dev/sda1 bs=64k status=progress | gzip > sda1.img.gz
sudo dd if=/dev/sda2 bs=64k status=progress | gzip > sda2.img.gz
```

## Backup your system

Backup with tar (recommended):

```bash
# Create a variable for excludes
defaultExcludes=(
    --exclude '/dev/*'
    --exclude '/home/*/.local/share/Trash'
    --exclude '/lost+found/*'
    --exclude '/media/*'
    --exclude '/mnt/*'
    --exclude '/proc/*'
    --exclude '/run/*'
    --exclude '/sys/*'
    --exclude '/tmp/*'
    --exclude '/**/cache'
    --exclude '/**/Cache'
    --exclude '/**/.cache'
    --exclude '/**/.Cache'
    --exclude '/**/.trash-*'
    --exclude '/**/.Trash-*'
)
userExcludes=(
    --exclude '/home/*/Downloads/*'
    --exclude '/home/*/Sync'
    --exclude '/home/*/Sync Mobile'
    --exclude '/home/*/projects'
    --exclude '/home/*/snap/bitcoin-core'
    --exclude '/home/*/snap/spotify'
    --exclude '/home/*/Games'
    --exclude '/home/*/Steam'
    --exclude '/home/*/VirtualBox'
    --exclude '/home/*/.config/itch'
    --exclude '/home/*/.config/xnviewmp/Thumb.db'
    --exclude '/home/*/.config/xnviewmp/XnView.db'
    --exclude '/home/*/.local/share/lutris'
    --exclude '/home/*/.local/share/TelegramDesktop'
    --exclude '/home/*/.steam'
    --exclude '/home/*/.var/app/com.usebottles.bottles'
    --exclude '/home/*/.var/app/net.lutris.Lutris'
    --exclude '/home/*/.var/app/org.gnome.Boxes'
    --exclude '/home/*/.PlayOnLinux'
    --exclude '/home/*/.mozilla'
    --exclude '/home/*/.config/variety/Downloaded'
    --exclude '/home/*/Android'
    --exclude '/home/*/.android/avd'
    --exclude '/home/*/Google Drive'
    --exclude '/var/lib/docker'
)

# Install NCDU - NCurses Disk Usage
sudo apt install ncdu

# Check disk usage
sudo ncdu "${defaultExcludes[@]}" "${userExcludes[@]}" /

# Create a backup (Lower compression, but higher speed)
sudo tar -I 'gzip -1' -cf /tmp/backup_$(date +%Y-%m-%d).tar.gz "${defaultExcludes[@]}" "${userExcludes[@]}" /
sudo chown cyb10101:cyb10101 /tmp/backup_*.tar.gz
```

Backup with fsarchiver:

```bash
sudo add-apt-repository multiverse
sudo apt -y install fsarchiver
sudo fsarchiver -j4 -A savefs sda3.fsa /dev/sda3
```

## Destroy disk

sudo dd if=/dev/random /dev/sda bs=512 count=200

## Restore

Boot in a live system.

```bash
efibootmgr
sudo efibootmgr --bootnext 0001
```

## Restore partition table

```bash
sudo fdisk -l /dev/sda

# Restore partition table for non-gpt partitions
sudo sfdisk /dev/sda < sfdisk_sda.txt

# Restore partition table for gpt partitions
sudo sgdisk -o -l sgdisk_sda.img /dev/sda

# Restore partition table for gpt partitions, delete partition 2, create a new partition
sudo sgdisk -o -l sgdisk_sda.img -d 2 -n 2:0:0 /dev/sda
```

## Restore your other partitions

```bash
gzip -cd sda1.img.gz | sudo dd of=/dev/sda1 bs=64k status=progress
gzip -cd sda2.img.gz | sudo dd of=/dev/sda2 bs=64k status=progress
```

## Restore your system partition

Backup with tar (recommended):

```bash
# Create filesystem
sudo mkfs.ext4 /dev/sda3

# Mount and restore data
sudo mount /dev/sda3 /mnt
sudo tar -C /mnt -xf backup.tar.gz
```

Restore with fsarchiver:

```bash
sudo add-apt-repository multiverse
sudo apt -y install fsarchiver
sudo fsarchiver -j4 restorefs sda3.fsa /dev/sda3
```

## Restore Grub

Install Grub:

```bash
# Mount partition
sudo mount /dev/sda3 /mnt

# Mount efi partition
sudo mount /dev/sda2 /mnt/boot/efi 

# Mount filesystem
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done

# Chroot in filesystem
sudo chroot /mnt
blkid /dev/sda?
# Update UUID in fstab
sudo vim /etc/fstab
update-grub

# If boot in efi fail, reinstall grub or simply just do it
mount -t efivarfs none /sys/firmware/efi/efivars
grub-install

# Exit chroot
exit

reboot
```

## Restore on a direfferent system

If you restore it on a different system you might stop, change or remove your syncronisation.

Keep in mind these things:

* Browsers: Firefox Sync
* File syncronisation: Syncthing, Dropbox, Google Drive
* Messegner

```bash

    --exclude '/home/*/Sync'
    --exclude '/home/*/Sync Mobile'
    --exclude '/home/*/.local/share/TelegramDesktop'
    --exclude '/home/*/.steam'
    --exclude '/home/*/.var/app/com.usebottles.bottles'
    --exclude '/home/*/.var/app/net.lutris.Lutris'
    --exclude '/home/*/.var/app/org.gnome.Boxes'
    --exclude '/home/*/.PlayOnLinux'
    --exclude '/home/*/.mozilla'
    --exclude '/home/*/Google Drive'

)
```
