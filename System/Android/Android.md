# Android

* [Scrcpy - Screen copy](Scrcpy.md)
* [Android Debug Bridge](Android-Debug-Bridge.md)

## Application

* [F-Droid Store](https://f-droid.org/)

* [F-Droid: Aurora Store](https://f-droid.org/de/packages/com.aurora.store/)
* [Aurora Store](https://auroraoss.com/)

* [Root Checker](https://play.google.com/store/apps/details?id=com.joeykrim.rootcheck)

## Root

* [TWRP: Devices](https://twrp.me/Devices/)
* [SuperSu](http://download.chainfire.eu/supersu) [SuperSu (Redirect)](https://download.chainfire.eu/1021/SuperSU/)
* [Root Checker](https://play.google.com/store/apps/details?id=com.joeykrim.rootcheck)

Root Devices:

* [Samsung Galaxy S7](Root_Samsung-Galaxy-S7.md)

## Prepare SD card (carefull)

May not be recommended as Android is a bit strange.

**Important: Backup!**

```bash
# Open shell
adb shell

# List disks
sm list-disks

# List disks: lists "adoptable" SD cards
sm list-disks adoptable

# Partition 50% "internal storage" 50% "external / mobile storage"
sm partition disk:179,64 mixed 50

# Example: Partition only "internal storage"
# sm partition disk:179,64 private

# Example: Partition 70% "internal storage" 30% "external / mobile storage"
sm partition disk:179,64 mixed 30
```

Now if you want to use the adopted storage as such, you also have to migrate the apps and data:

* Android 7 > Settings > Data and memory > Details > SD card > Hamburger menu > Migrate data