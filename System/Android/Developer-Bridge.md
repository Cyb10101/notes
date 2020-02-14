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
sudo adb devices

# Restart ADB Server
sudo adb kill-server; sudo adb start-server

# From local to device
sudo adb push local.zip /sdcard/to-device.zip

# From device to local
adb pull /sdcard/from-device.zip

# Reboot
sudo adb reboot
sudo adb reboot bootloader
sudo adb reboot recovery

# Backup
adb backup -f backup.ab -apk -shared –all

# Restore
adb restore backup.ab
```
