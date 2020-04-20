# Disk: Zero fill empty space

When a file is deleted, leftovers remain on the hard disk. These file remains are automatically overwritten when new files are created or edited.

If an image is to be created from the hard disk, then the rest of the file is also copied and causes unnecessary storage space in the image.

Simply explained, depending on the procedure, `existing files`, `deleted files` and `free space` are copied into an image.

Some methods do not copy the free space and intelligent methods do not copy deleted files. So it is not always necessary to overwrite the deleted memory with zeros.

## First steps

* Required for Windows disks: [Windows complete shutdown](../Windows/Shutdown.md)

Run a Ubuntu live disc.

Find your device and unmount it, if already mounted.

```bash
sudo blkid /dev/sd*
```

## Linux partitions (ext4):

```bash
sudo apt install zerofree
sudo zerofree -v /dev/sda1
```

## Windows partitions (NTFS):

```bash
sudo apt install ntfswipe
sudo ntfswipe -a /dev/sda1
```
