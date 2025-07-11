# Android

## Applications

* [Android Installation](Android-Installation.md)
* [Scrcpy (Screen copy)](Scrcpy.md)

## Android debug bridge

If you must connect your device via Android debug bridge (ADB), you should install adb and fastboot. These are the most common methods.

Samsung, on the other hand, requires Odin3 or alternatively Heimdall, see below.

* [Android Debug Bridge (adb)](https://developer.android.com/tools/adb)
* [SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools)


```bash
sudo apt -y install android-tools-adb android-tools-fastboot
```

In order to be able to use the ADB, you must first activate the "developer options" it in your smartphone. Each Smartphone operating system could vary.

* Activate developer options
  * Settings > About Device > Version > Tap 7x on "Build number"
* Enable USB-Debugging
  * Settings > System > Developer options > Debugging: USB-Debugging = true

*Note: Last tested on Android 12.*

### ADB Commands

```bash
# List devices
adb devices
# Note: Maybe set to PTP-Mode (Picture Transfer Protocol)

# Restart ADB Server (Not necessary)
# adb kill-server; adb start-server

# Shell
adb shell

# Copy file from local to device
adb push local.zip /storage/emulated/0/Download/

# Copy file from device to local
adb pull /storage/emulated/0/Download/from-device.zip

# Reboot
adb reboot              # Just reboot
adb reboot bootloader   # Reboot into bootloader
adb reboot fastboot     # Reboot into fastboot
adb reboot download     # For Samsung devices into Odin downloader
adb reboot recovery     # Reboot into recovery

# Screenshot
adb shell screencap /storage/emulated/0/Download/example.jpg
adb shell screencap -p /storage/emulated/0/Download/example.png

# Screen record
adb shell screenrecord /storage/emulated/0/Download/example.mp4

# List 3rd party installed applications
adb shell pm list packages -3 | sed "s/^package:/* /g" | sort -u;

# Install application
wget -O /tmp/F-Droid.apk https://f-droid.org/F-Droid.apk
adb push /tmp/F-Droid.apk /storage/emulated/0/Download/
adb shell pm install /storage/emulated/0/Download/F-Droid.apk

# Uninstall application
adb shell pm uninstall org.fdroid.fdroid
```

### Copy files

```bash
# List storages
adb shell ls /storage

# New internal storage path
adb shell ls -a /storage/self/primary
adb pull -a /storage/self/primary/ ./storage/

# Old internal storage path
adb pull -a /storage/emulated/0/ ./storage/

# SD Card example
adb pull -a /storage/2A90-4222/ ./sdcard/
```

### Fastboot Commands

```bash
# List devices
fastboot devices

# Temporary boot a image
fastboot boot twrp.img
```

### Samsung

Samsung devices use Odin or Heimdall instead of fastboot. They use the Odin3 protocol.

* [Heimdall](https://www.glassechidna.com.au/heimdall/)

```bash
sudo apt -y install heimdall-flash
# optional a GUI: heimdall-flash-frontend
```

## Root devices

**Attention! In order for you to be able to root your device, you need to do things that could erase and also destroy your device. You have been warned!**

See devices:

* [Samsung Galaxy S7](devices/Samsung-Galaxy-S7.md)

### TWRP Recovery (Recommended)

TWRP - Team Win Recovery Project (No root required).

Find device, download TWRP and flash device.

* [TeamWin - TWRP: Devices](https://twrp.me/Devices/)

```bash
# Boot into fastboot/bootloader/download
adb reboot bootloader

# Image flashen
fastboot flash recovery twrp.img
fastboot reboot

adb reboot recovery
```

*Note: /storage/emulated/0 is mounted on /data/media/0*

### Install SuperSU and Root Checker

Download and install Zip.

* [Chainfire: SuperSu](https://download.chainfire.eu/supersu)
* [Chainfire: SuperSu (Redirect)](https://download.chainfire.eu/1220/SuperSU/SR5-SuperSU-v2.82-SR5-20171001224502.zip)

* `adb reboot recovery`
* TWRP > Advanced > ADB Sideload
* `adb sideload supersu.zip`

* [Root Checker](https://play.google.com/store/apps/details?id=com.joeykrim.rootcheck)

### Install OpenGApps

Download and install Zip.

* [OpenGApps](http://opengapps.org/?api=10.0&variant=super)

* `adb reboot recovery`
* TWRP > Advanced > ADB Sideload
* `adb sideload open_gapps.zip`

## Fetch application APK (not recommended)

To get the list of your 3rd party installed applications:

```bash
# List 3rd party installed applications
adb shell pm list packages -3 | sed "s/^package:/* /g" | sort -u;

# List 3rd party installed applications with associated file
adb shell pm list packages -3 -f
```

If you want to fetch all apk of your installed apps:

```bash
for APP in $(adb shell pm list packages -3 -f | sed "s|^package:||; s|base.apk=|base.apk\||"); do \
  IFS='|' read -r source target <<< "$APP"; \
  adb pull "${source}" "${target}.apk"; \
done
```

To fetch only one application, based of listed packages results:

```bash
adb pull /data/app/~~p3JH...GV6g==/com.google.android.diskusage-m5dd...0AuA==/base.apk com.google.android.diskusage.apk
```
