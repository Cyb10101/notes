# Virtualbox: Expand disk

First the "container" has to be enlarged and then the "partition" in the container must be enlarged.

## Enlarge container: VDI disks

Enlarging hard disk in MB.

In Linux:

```bash
vboxmanage modifymedium disk disk.vdi --resize 1000000
```

In Windows:

```bash
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifymedium disk "D:\VM\disk.vdi" --resize 1000000
```

## Enlarge container: VHD disks (Windows 10)

*Note: In Linux you have to convert the VHD to VDI and then enlarge it!*

Run Command as administrator: Start > cmd (Ctrl + Shift + Left click)

```bash
diskpart
select vdisk file="D:\VM\disk.vhd"

# Just for display
list vdisk

# Enlarging the hard disk in MB
expand vdisk maximum=1000000
exit
```

## Enlarge partition: ext4

After the container of the disk has been enlarged, the partition itself must be enlarged.

* VirtualBox > Machine > change > Mass storage > Add disk drive > Insert Ubuntu Live Disk (Delete after enlarging)
* Boot > Try Ubuntu
* Start > GParted Partition Editor
* Delete Linux swap & extended partition
* Enlarge / move partition (leave about 4 GB space for swap partition)
* Create partition
  - Create as: Extended partition
* Create the swap partition in "Extended Partition"
  - Create as: Logical partition
  - File system: linux-swap
* Perform GParted operations
