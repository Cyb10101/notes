# Hibernate

* [UbuntuHandbook: Enable Hibernate Function](https://ubuntuhandbook.org/index.php/2021/08/enable-hibernate-ubuntu-21-10/)
* [UbuntuUsers: Ruhezustand](https://wiki.ubuntuusers.de/Ruhezustand/)

To ensure that hibernation works properly with secure boot, the whole thing should run via TPM.
For a hardcore version, you can also edit the kernel yourself. In my opinion, my life is too short for that.

Do you want to use Hibernate without secure boot, with or without LUKS encryption? Have fun!

## Requirements

Check Secure Boot status:

```bash
mokutil --sb-state
sudo dmesg | grep -i lockdown
```

If `SecureBoot enabled` or `hibernation is restricted` appears, then kernel lockdown is most likely active and hibernation is blocked. You need to disable secure boot.


Check whether S4 (Hibernate) is offered by the kernel:

```bash
cat /sys/power/state
# freeze mem disk

sudo dmesg | grep -i "ACPI.*PM:.*supports"
# ACPI: PM: (supports S0 S3 S4 S5)
# S0 = Normal operation (PC on)
# S3 = Standby / Sleep (Energy saving mode)
# S4 = Hibernate
# S5 = Shutdown (PC off)
```

If `disk` is missing, then secure boot or kernel parameters are blocking hibernation.
If `S4` is missing in ACPI, then hibernation is not supported. Check BIOS.

## Preparation of the swap (Swapfile)

Swap should be at least as large as the RAM.

Check RAM and swap:

```bash
free -h
swapon --show
```

Recreate swap file:

```bash
sudo swapoff /swap.img
sudo rm /swap.img

# Create 16 GB swap file
sudo fallocate -l 16G /swap.img

# Alternative method to create swap file
# sudo dd if=/dev/zero of=/swap.img bs=1M count=16384 status=progress

sudo chmod 600 /swap.img
sudo mkswap /swap.img
sudo swapon /swap.img
```

Read the first `physical_offset` from extent 0 and note the `resume_offset=140578816`:

```bash
sudo filefrag -v /swap.img
# ext: logical_offset: physical_offset:       length: expected: flags:
# 0:   0.. 0:          140578816.. 140578816: 1:
```


## Determine root UUID

Determine root UUID for `resume=3f7b326b-ae9e-4171-9979-650db45a1161`:

```bash
findmnt -no SOURCE /
# /dev/nvme0n1p2

blkid $(findmnt -no SOURCE /)
# /dev/nvme0n1p2: UUID="3f7b326b-ae9e-4171-9979-650db45a1161"
```

## 4. GRUB & Initramfs konfigurieren

Edit Grub:

```bash
sudo nano /etc/default/grub
```

Add resume & resume_offset for Grub:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=32472d7a-51e7-413a-afd8-60dd612dd505 resume_offset=140578816"
```

Add resume & resume_offset for Initramfs:

```bash
echo "resume=UUID=32472d7a-51e7-413a-afd8-60dd612dd505 resume_offset=140578816" | sudo tee /etc/initramfs-tools/conf.d/resume
```

Update Grub & Initramfs:

```bash
sudo update-grub
sudo update-initramfs -u
```

## Add hibernate button to power menu

Finally, add hibernate to the power menu.


Create polkit rule file:

```bash
sudo nano /etc/polkit-1/rules.d/10-enable-hibernate.rules
```

Add the following:

```bash
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.hibernate" ||
        action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
        action.id == "org.freedesktop.upower.hibernate" ||
        action.id == "org.freedesktop.login1.handle-hibernate-key" ||
        action.id == "org.freedesktop.login1.hibernate-ignore-inhibit")
    {
        return polkit.Result.YES;
    }
});
```

Additionally, install the extension for Gnome Desktop:

* [Gnome: Hibernate Status Button](https://extensions.gnome.org/extension/755/hibernate-status-button/)


## Functional test

Finally, restart the computer.

If the previous steps were performed correctly, the "Hibernate" option should appear in the power menu.

You can test this manually:

```bash
sudo systemctl hibernate
```
