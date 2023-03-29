# Android

* [Scrcpy - Screen copy](Scrcpy.md)
* [Android Debug Bridge](Android-Debug-Bridge.md)

## Application

Store:

* [F-Droid Store](https://f-droid.org/)
* [F-Droid: Aurora Store](https://f-droid.org/de/packages/com.aurora.store/)
* [Aurora Store](https://auroraoss.com/)

Launcher:

* [Nova Launcher](https://play.google.com/store/apps/details?id=com.teslacoilsw.launcher)

Hardware/Software Info:

* [Root Checker](https://play.google.com/store/apps/details?id=com.joeykrim.rootcheck)
* [DiskInfo](https://play.google.com/store/apps/details?id=com.drhowdydoo.diskinfo)
* [DRM Info](https://play.google.com/store/apps/details?id=com.androidfung.drminfo)
* [Device Info HW](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw)

Media:

* [F-Stop - Picture Gallery](https://play.google.com/store/apps/details?id=com.fstop.photo)
* [Google - Gallery](https://play.google.com/store/apps/details?id=com.google.android.apps.photosgo)
* [Pulsar - Music Player](https://play.google.com/store/apps/details?id=com.rhmsoft.pulsar)

Files & Transfer:

* [FX File Explorer](https://play.google.com/store/apps/details?id=nextapp.fx)
* [Nearby Share](https://support.google.com/files/answer/10514188)
* [Google Files](https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.files)
* [LocalSend](https://localsend.org/#/download)
* [Wormhole William](https://play.google.com/store/apps/details?id=io.sanford.wormhole_william)
* [Warpinator (Github)](https://github.com/linuxmint/warpinator)

Security:

* [Aegis Authenticator)](https://getaegis.app/)
* [Bitwarden](https://bitwarden.com/download/)

Office:

* [LibreOffice Viewer](https://f-droid.org/packages/org.documentfoundation.libreoffice/)

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
