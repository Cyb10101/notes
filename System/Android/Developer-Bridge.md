# Android: Developer bridge

## Install ADB

Install in Ubuntu:

```bash
sudo apt install android-tools-adb android-tools-fastboot
```

Activate developer options:

```text
Android 8 > Settings > System > About the mobile > Tap 7x on "Build number"
Android ? > Settings > Info > Software information > More > Tap 7x on "Build number"
```

Enable USB-Debugging:

```text
Android 8 > Settings > System > Developer options > Debugging > USB-Debugging = true
```

## Commands

```bash
# Device list
adb devices
# Note: Maybe set to PTP-Mode (Picture Transfer Protocol)

# Restart ADB Server
sudo adb kill-server; sudo adb start-server

# From local to device
sudo adb push local.zip /sdcard/to-device.zip

# From device to local
adb pull /sdcard/from-device.zip

# Reboot
adb reboot
adb reboot bootloader
adb reboot recovery
```

## Backup

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

## Extract content of adb backup file

```bash
dd if=backup.ab bs=24 skip=1 | openssl zlib -d > backup.tar

sudo apt -y install qpdf
dd if=backup.ab bs=24 skip=1 | zlib-flate -uncompress | tar xf -
```

## Fetch application APK

To get the list of your installed applications:

```bash
adb shell pm list packages -f -3
```

If you want to fetch all apk of your installed apps:

```bash
for APP in $(adb shell pm list packages -3 -f | sed "s/^package://g; s/base.apk=/base.apk /g"); do
  adb pull echo ${APP}.apk
done
```

To fetch only one application, based of listed packages results:

```bash
adb pull /data/app/~~p3JH...GV6g==/com.google.android.diskusage-m5dd...0AuA==/base.apk com.google.android.diskusage.apk
```
