# VirtualBox

Definition:

* VM: Virtual machine
* Host: Your real computer
* Guest: Your virtual machine

* [VirtualBox installation](Installation.md)
* Maybe required: [Secure Boot](../../System/Linux/Secure-Boot/Secure-Boot.md)

## Configuration

Linux host USB pass through to Windows guest, reboot host:

```bash
sudo usermod -aG vboxusers ${USER}
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
fs0:
cd EFI
cd ubuntu
grubx64.efi
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
