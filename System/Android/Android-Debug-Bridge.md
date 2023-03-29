# Android Debug Bridge

* [Android Debug Bridge (adb)](https://developer.android.com/studio/command-line/adb)
* [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)

## Install ADB

Install in Ubuntu:

```bash
sudo apt -y install android-tools-adb android-tools-fastboot
```

Activate developer options:

```text
Android 12 > Settings > About Device > Version > Tap 7x on "Build number"
Android 8 > Settings > System > About the mobile > Tap 7x on "Build number"
Android ? > Settings > Info > Software information > More > Tap 7x on "Build number"
```

Enable USB-Debugging:

```text
Android 12 > Settings > System > Developer options > Debugging: USB-Debugging = true
Android 8 > Settings > System > Developer options > Debugging > USB-Debugging = true
```

## Commands

```bash
# Device list
adb devices
# Note: Maybe set to PTP-Mode (Picture Transfer Protocol)

# Restart ADB Server (Not necessary)
# adb kill-server; adb start-server

# Shell
adb shell

# From local to device
adb push local.zip /storage/emulated/0/Download/

# From device to local
adb pull /storage/emulated/0/Download/from-device.zip

# Reboot
adb reboot
adb reboot bootloader
adb reboot recovery

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

## Backup (not recommended)

```bash
# Backup
adb backup -apk -shared -all -f "$(date +%F)_backup_all.ab"

# Full Backup
adb backup -apk -shared -all -nosystem -f "$(date +%F)_backup.ab"

# Restore
adb restore backup.ab

# Backup packages
for APP in $(adb shell pm list packages -3 | sed "s/^package://g" | sort -u); do adb backup -f ${APP}.backup ${APP}; done
```

## Extract content of adb backup file (not recommended/not good)

```bash
dd if=backup.ab bs=24 skip=1 | openssl zlib -d > backup.tar

sudo apt -y install qpdf
dd if=backup.ab bs=24 skip=1 | zlib-flate -uncompress | tar xf -
```

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
for APP in $(adb shell pm list packages -3 -f | sed "s/^package://g; s/base.apk=/base.apk /g"); do \
  adb pull echo ${APP}.apk; \
done
```

To fetch only one application, based of listed packages results:

```bash
adb pull /data/app/~~p3JH...GV6g==/com.google.android.diskusage-m5dd...0AuA==/base.apk com.google.android.diskusage.apk
```
