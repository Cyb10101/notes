# VirtualBox

Definition:

* VM: Virtual machine
* Host: Your real computer
* Guest: Your virtual machine

* [VirtualBox installation](Installation.md)
* Maybe required: [Secure Boot](../../System/Linux/Secure-Boot/Secure-Boot.md)

## Install missing bzip2

```bash
sudo apt -y install bzip2
```

## Configuration

Linux host USB pass through to Windows guest, reboot host:

```bash
#sudo usermod -aG vboxusers ${USER}
sudo usermod -aG vboxsf ${USER}
```

## Convert Raw Disk to VDI

Before converting:

* Remove the graphics driver from Ubuntu.
* [Backup Entire Disk](../../System/Linux/Backup-Entire-Disk.md)

```bash
# Convert from raw disk
sudo VBoxManage convertfromraw /dev/sda disk.vdi

# Convert from raw image
sudo VBoxManage convertfromraw disk.img disk.vdi

# Convert from compressed image with progress (stupid as fuck)
sudo apt install pv
SOURCE=disk.img.gz
gzip -cd ${SOURCE} | pv | VBoxManage convertfromraw stdin disk.vdi $(gzip -cd ${SOURCE} | wc -c)
```

## UEFI Secure Boot

### Reboot from Ubuntu to EFI Shell

```bash
sudo efibootmgr -v
sudo efibootmgr --bootnext 0004
reboot
```

### Virtualbox EFI Startup

Mount EFI and add startup for Virtualbox EFI Shell.

```bash
sudo mount /dev/sda1 /mnt
sudo echo '\EFI\ubuntu\grubx64.efi' > /mnt/startup.nsh
```

### Virtualbox EFI Shell navigate and run

* Ubuntu: grubx64.efi
* Windows: bootmgfw.efi

```bash
# List devices
map

# Boot efi
FS0:
cd EFI
cd ubuntu
grubx64.efi

# Boot Linux
FS0:\EFI\ubuntu\grubx64.efi

# Boot Windows
FS0:\EFI\Microsoft\Boot\bootmgfw.efi
FS0:\EFI\BOOT\BOOTX64.EFI

# Reboot
reset
```

## Ubuntu: Don't show a dialog box on automatic shutdown

Add at the beginning of the script:

File `/etc/acpi/powerbtn.sh`:

```bash
/sbin/shutdown -h now 'Power button pressed' && exit 0
```

## VM shutdown command

For Linux hosts:

```bash
vboxmanage controlvm "DEV-VM" acpipowerbutton
```

For Windows hosts:

```bash
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "DEV-VM" acpipowerbutton
```

## Windows 11 in Virtualbox

* [Bypass setup requirements](../../System/Windows/bypass-setup-requirements/)

## Bugfix: Failed to start VirtualBox Linux kernel module

***Maybe that's enough: [Secure-Boot: Import machine owner key](../../System/Linux/Secure-Boot/Secure-Boot.md)***

```bash
#sudo systemctl status vboxdrv.service
#sudo journalctl -xeu vboxdrv.service
sudo apt install virtualbox-dkms

# Error: VirtualBox - Kernel driver not installed (rc=-1908)
sudo dpkg-reconfigure virtualbox-dkms
sudo modprobe vboxdrv
# No restart needed
```

## Bugfix: Virtualbox conflict with kvm modules loaded in kernel

*Message:* VirtualBox can't enable the AMD-V extension. Please disable the KVM kernel extension, recompile your kernel and reboot (VERR_SVM_IN_USE).

```bash
# List used modules
lsmod | grep kvm

# Disable temporary
sudo rmmod kvm_amd
#sudo rmmod kvm

# Blacklist modules permanently
echo "blacklist kvm_amd" | sudo tee /etc/modprobe.d/disable-kvm.conf
#echo -e "blacklist kvm_amd\nblacklist kvm" | sudo tee /etc/modprobe.d/disable-kvm.conf
```
