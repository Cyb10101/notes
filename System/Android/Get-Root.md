# Android: Get Root

See: [Android Debug Bridge](Android-Debug-Bridge.md)

## TWRP - Team Win Recovery Project (No Root Required)

Find device, download TWRP and flash device.

https://twrp.me/Devices/

```bash
# Go in fastboot
adb reboot bootloader

# Image flashen
sudo fastboot devices
sudo fastboot flash recovery twrp.img
sudo fastboot reboot
```

## Cyanogenmod Build

Download better release because Nightly is a beta.
Format and install Zip.

http://download.cyanogenmod.org/?device=m7&type=snapshot

```bash
adb push SuperSU.zip /sdcard/
adb reboot recovery
```

## Install SuperSU

Download and install Zip.

http://download.chainfire.eu/supersu

```bash
adb push SuperSU.zip /sdcard/
adb reboot recovery
```

## Install Open GApps

Download and install Zip.

http://opengapps.org/?api=6.0&variant=super

```bash
adb push opengapps.zip /sdcard/
adb reboot recovery
```
