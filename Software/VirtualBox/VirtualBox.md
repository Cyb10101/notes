# VirtualBox

Definition:

* VM: Virtual machine
* Host: Your real computer
* Guest: Your virtual machine

## Configuration

```bash
# Linux host USB pass through to Windows guest, reboot host
sudo usermod -aG vboxusers ${USER}
```

## Convert Raw Disk to VDI

Before converting:

* Remove the graphics driver from Ubuntu.
* "Zero fill" disk (Makes the image smaller)

```bash
sudo zerofree -v /dev/sda1
sudo dd if=/dev/sda of=sda.img
sudo VBoxManage convertfromraw sda.img sda.vdi

# @todo direct untestet:
#sudo dd if=/dev/sda | VBoxManage convertfromraw stdin sda.vdi

# @todo direct untestet:
##sudo dd if=/dev/sda count=1000000 | VBoxManage convertfromraw stdin myimage.vdi 512000000
##sudo dd .... | VBoxManage convertfromraw stdin outf 40000000 --variant Fixed
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
