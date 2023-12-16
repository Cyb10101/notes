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

Bypass Windows 11 requirements in Ubuntu.

* Boot Windows Setup ISO
* Select language
* Launch Command: Shift + F10
* Run: regedit
* Add Keys: BypassTPMCheck, BypassSecureBootCheck, BypassRAMCheck
* Click on "Install now"

```powershell
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC]
#"UpgradeEligibility"=dword:00000001

[HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
#"BypassRAMCheck"=dword:00000001
#"BypassStorageCheck"=dword:00000001
#"BypassCPUCheck"=dword:00000001
#"BypassDiskCheck"=dword:00000001
```

Bypass Windows 11 internet requirements:

* Go though setup until you reach page: "Let's connect you to a network"
* Open Command promt with: Shift + F10
* Run: C:\Windows\System\oobe\BypassNRO.cmd
* Reboot and click on "I don't have internet"

File `C:\Windows\System32\oobe\BypassNRO.cmd` or `C:\Windows\System\oobe\BypassNRO.cmd`:

```shell
@echo off
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f
shutdown /r /t 0
```

## Bugfix: Failed to start VirtualBox Linux kernel module

```bash
#sudo systemctl status vboxdrv.service
#sudo journalctl -xeu vboxdrv.service
sudo apt install virtualbox-dkms

# Error: VirtualBox - Kernel driver not installed (rc=-1908)
sudo dpkg-reconfigure virtualbox-dkms
sudo modprobe vboxdrv
# No restart needed
```
