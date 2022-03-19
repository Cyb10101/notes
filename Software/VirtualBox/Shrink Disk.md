# Virtualbox: Shrink disk

## Defragment drives

Linux: Don't defragment ext4!

Windows: Defragment and optimize drives!

## Zero fill - Zero free

First, the free space that was previously filled with files must be filled with zeros.

Steps:

* Boot virtual machine with an Ubuntu Live CD
* Open terminal, become root, update package sources, install package zerofree
* Find out the hard drive and release it with zerofree memory
* Shut down virtual machine, eject live CD
* Next step shrink hard drive with Virtualbox

For Linux partitions (ext4):

```bash
sudo apt update
sudo apt install zerofree
sudo fdisk -l
sudo zerofree -v /dev/sda1
```

For Windows partitions (NTFS):

```bash
sudo apt install ntfswipe
sudo fdisk -l
sudo ntfswipe -a /dev/sda1
```

*Keywords: zerofill*

## VDI disks

In Linux:

```bash
vboxmanage modifyhd disk.vdi --compact
```

In Windows:

```bash
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyhd "C:\disk.vdi" --compact
```

## VDMK disks

* Convert from vdmk to vdi

In Linux:

```bash
vboxmanage clonehd disk.vmdk clone.vdi --format vdi
```

In Windows:

```bash
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonehd "C:\disk.vmdk" "D:\clone.vdi" --format vdi
```

* Open Virtualbox, File > Virtual Media Manager
* Release hard drive and it, including the VDMK file

* Convert from vdi to vmdk

In Linux:

```bash
vboxmanage clonehd clone.vdi disk.vmdk --format vdmk
```

In Windows:

```bash
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonehd "D:\clone.vdi" "C:\disk.vmdk" --format vmdk
```

* Virtualbox > Change virtual machine
* Mass storage > Mount existing VDMK hard disk
* Start virtual machine and delete old clone.vdi
