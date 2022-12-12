# Backup and restore entire disk

**Note: If you only want a small backup of your data then look here: [Backup](../../Tutorial/Backup.md).**

Here the complete hard drive with all partitions is copied. A 1 to 1 copy of a real hard disk, so to speak.

The advantage is, if something went wrong after the backup, you can reset everything.

Another advantage is that you can virtualize the hard drive (Example: VirtualBox)

ETA means "estimated time of arrival". Simply put, if there is an ETA, you know how long it will take.

You should always compress the image to save storage space.

## Why not a paid Software

In my opinion, there is absolutely no need to choose paid software for this.

For example a free version of a paid backup software:

* The backup software is only for Windows (But it is possible to backup Linux partitions)
* To download the software you have to provide your email address or must register
* You get a download manager that downloads the installer (or other malware)
* When you install the software, you get a free license key that can be upgraded (Nobody needs that)
* It is only possible to create a restore ISO in the backup software (Downloading is not possible)
* The recovery ISO is a very stripped-down version like Windows PE (Useless apart from the backup software)
* For more functions, you have to pay for the software by taking out a subscription

Or you can take a free Linux CD that contains a functional live system and use the dd + gzip.

And the best thing is, in most cases an image is not necessary, just a data backup.

## Virtual Machine

If you want to create a virtual disk for a virtual machine.

* [VirtualBox](../../Software/VirtualBox/VirtualBox.md)

## Warning

Do not move or shrink Windows Partition with gparted!
In my test GParted crashed. Use a Windows tool:

**Note: You must disable hibernation in Windows with `powercfg.exe /h off`, see [Windows Shutdown](../Windows/Shutdown.md).**

* [RedoRescue](http://redorescue.com/)
* [MiniTool: Partition Wizard](https://www.minitool.com/partition-manager/partition-wizard-home.html)
* Terminal on a [Windows ISO](https://www.microsoft.com/de-de/software-download)
* Untested: [Macrium: Reflect](https://www.macrium.com/reflectfree)
* Untested: [Samsung: Magician](https://www.samsung.com/semiconductor/minisite/ssd/product/consumer/magician/)

## First steps

* Be sure you have a [Backup](../../Tutorial/Backup.md) if something fails (should not, but could)
* Maybe required: [Windows complete shutdown](../Windows/Shutdown.md)
* Optional: [Disk: Zero fill empty space](Disk-Zero-Fill-Empty-Space.md)
* Shrink disk with GParted (It is not nesseccary and be very carefull doing this)

Run a Linux live disc, for example [Ubuntu Desktop](https://ubuntu.com/download/desktop)

Find your device and unmount it, if already mounted. But don't unmount your backup storage.

```bash
sudo apt install hwinfo

# Via Desktop: Gnome Disk, Gparted
sudo hwinfo --short --disk
sudo blkid /dev/sd*
sudo lsblk /dev/sd?
sudo fdisk -l /dev/sda
```

## Backup/Clone with ddrescue (Safely and with continuation)

Rather no backup, more a cloning of the hard disk to a new disk or for data recovery.
No compression in image, better you use a real disk instead of a image.

* [GNU ddrescue](https://wiki.ubuntuusers.de/gddrescue/)

```bash
# Install
sudo add-apt-repository multiverse
sudo apt install gddrescue
sudo apt install ddrescueview # Optional: You can see the log file

# Backup/Clone: 1. Only safe blocks, then 2. corrupted blocks
sudo ddrescue -f -n /dev/sda /dev/sdb /tmp/ddrescue.log
sudo ddrescue -f -R /dev/sda /dev/sdb /tmp/ddrescue.log # Optional: -R Reverse direction (Maybe for corrupted disk)

# Restore: Only for images
sudo ddrescue -f image.img /dev/sda /tmp/restore.log
```

Open GParted and fix "Not all of space available" with "Repair".

Maybe you wan't expand partition after cloning with GParted. (Windows see above: Warning)

## Backup with PV and compression (ETA)

With progress bar.

```bash
sudo apt install pv

# Backup: Create a image
sudo pv /dev/sda | gzip > disk.img.gz

# Restore: Copy image to device
sudo sh -c "gzip -cd disk.img.gz | pv > /dev/sda"
```

## Backup with DD and compression (No ETA)

You can only see how much time or bytes have passed. If you know the size of the hard drive, you can calculate the ETA yourself.

```bash
# Backup: Create a image
sudo dd if=/dev/sda bs=64k status=progress | gzip > disk.img.gz
# If failed: sudo dd if=/dev/sda bs=64k conv=noerror,sync iflag=fullblock status=progress | gzip > disk.img.gz

# Restore: Copy image to device
gzip -cd disk.img.gz | sudo dd of=/dev/sda bs=64k status=progress
# If failed: gzip -cd disk.img.gz | sudo dd of=/dev/sda bs=64k conv=noerror,sync iflag=fullblock status=progress
```

## Backup with DD (No ETA)

Not recommended because it requires a lot of disk space.

```bash
# Backup: Create a image
sudo dd if=/dev/sda of=disk.img bs=64k status=progress
# If failed: sudo dd if=/dev/sda of=disk.img bs=64k conv=noerror,sync iflag=fullblock status=progress

# Restore: Copy image to device
sudo dd if=disk.img of=/dev/sda bs=64k status=progress
# If failed: sudo dd if=disk.img of=/dev/sda bs=64k conv=noerror,sync iflag=fullblock status=progress
```

## Clone Windows disk

Tested with Windows 10 and 11, Partition table msdos/gpt and secure boot.

```bash
# Install gddrescue
add-apt-repository multiverse
apt install gddrescue

# Get partition info
fdisk -l /dev/sda

# Create partition table (msdos/gpt)
parted /dev/sdb
mklabel gpt
q

# Clone partition table
# 2048 Sectors * 512 Bytes = 1048576 Bytes = 1 MB = 1M
dd if=/dev/sda of=/dev/sdb bs=1M count=1

# Clone unknown filesystem (EFI-System, Microsoft reserved)
ddrescue -f -n /dev/sda1 /dev/sdb1

# Clone NTFS filesystem (Microsoft Basic data, Windows Recovery environment)
ntfsclone --rescue --overwrite /dev/sdb2 /dev/sda2

# Image NTFS filesystem: backup & restore (untested)
ntfsclone --rescue --save-image --output - /dev/sdb2 | gzip > sdb2.img.gz
gzip -cd sdb2.img.gz | ntfsclone --restore-image --overwrite /dev/sdb2 -
```

Shutdown, remove source drive, boot up computer.
