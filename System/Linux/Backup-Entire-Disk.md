# Backup and restore entire disk

Here the complete hard drive with all partitions is copied. A 1 to 1 copy of a real hard disk, so to speak.

The advantage is, if something went wrong after the backup, you can reset everything.

Another advantage is that you can virtualize the hard drive (Example: VirtualBox)

ETA means "estimated time of arrival". Simply put, if there is an ETA, you know how long it will take.

In these examples the image file is compressed sofot to save storage space.

## First steps

* Maybe required: [Windows complete shutdown](../Windows/Shutdown.md)
* Optional: [Disk: Zero fill empty space](Disk-Zero-Fill-Empty-Space.md)

Run a Ubuntu live disc.

Find your device and unmount it, if already mounted. But don't unmount your backup storage.

```bash
sudo blkid /dev/sd*
```

## Backup with PV and compression (ETA)

Recommended variant, as you can see here how long it takes and often faster than dd.

*Note: Some say that it may not be certain that it will work.*

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
sudo dd if=/dev/sda status=progress | gzip > disk.img.gz

# Restore: Copy image to device
gzip -cd disk.img.gz | sudo dd of=/dev/sda status=progress
```

## Backup with DD (No ETA)

Not recommended because it requires a lot of disk space.

```bash
# Backup: Create a image
sudo dd if=/dev/sda of=disk.img status=progress

# Restore: Copy image to device
sudo dd if=disk.img of=/dev/sda status=progress
```
