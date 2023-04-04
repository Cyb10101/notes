# Root: Samsung Galaxy S7 (SM-G930F)

* [Samsung Android USB Driver (Latest, 1.7.56.0)](https://developer.samsung.com/android-usb-driver)
* [Samsung Odin (Latest, 3.14.4, 3.12.3)](https://odindownload.com/download/)
* [TWRP: Samsung Galaxy S7 (Latest, 3.6.2 9-0)](https://twrp.me/samsung/samsunggalaxys7.html)
* [SuperSu (Latest, 2.82-SR5)](http://download.chainfire.eu/supersu)
* [no-verity-opt-encrypt (Latest, 6.1)](https://build.nethunter.com/android-tools/no-verity-opt-encrypt/)

| Action                | ADB Command           | Shortcut                          |
| --------------------- | --------------------- | --------------------------------- |
| Odin/Download mode    | adb reboot download   | [Volume Down] + [Home] + [Power]  |
| Recovery              | adb reboot recovery   | [Volume Up] + [Home] + [Power]    | 

1. Enable Developer options
   1. Settings > Phone info > Software information > Tap 7 times on Build number
   2. Settings > Developer options > USB-Debugging = true
   3. Settings > Developer options > OEM unlock = true
2. Prepare System
   1. Install: Samsung Mobile Phone Drivers
   2. Download TWRP.tar for herolte (Do not extract)
3. Reboot device into Odin/Download mode
   1. `adb reboot download` or reboot device from the power menu and hold the [Volume Down] + [Home] + [Power]
   3. Download mode warning screen: Press [Volume Up] to continue
4. Run Samsung Odin on computer
   1. Check if ID:COM is connectet with "0:[COM?]"
   2. Tab "Options" > Auto Reboot = false
   3. Get back to tab "Log"
   4. Click on "AP" and select TWRP.tar file
   5. Click on "Start" and wait until pass
   6. Reset device and go to recovery: Press [Volume Down] + [Home] + [Power] until it goes blank then [Volume Up] + [Home] + [Power]
5. Prepare USB-Stick for OTG Transfer
   1. Format USB Stick to FAT32 (Note: Windows 11 can only format to FAT32 if USB Stick ist lower than 32 GB)
   2. Copy SuperSu.zip and no-verity-opt-encrypt.zip to USB-Drive and eject it
6. Backup with TWRP Recovery
   1. Swipe right to allow system modifications
   2. (Settings > Vibrations > Button Vibration = 0)
   3. Mount > USB OTG = true
   4. Backup > Select "Boot, System, Data" > Select Storage "USB OTG" > Swipe to Backup
   5. Go back to main menu
7. Wipe Data with TWRP Recovery
   1. Wipe > Format Data > Type "yes"
   2. Go back to main menu
8. Install "no-verity-opt-encrypt" with TWRP Recovery (only want a bootable system partition, maybe not needed or after SuperSu?)
   1. Install > Select Storage "USB OTG"
   2. Click on "no-verity-opt-encrypt.zip" > Swipe to confirm Flash
   3. Reboot System and go back to Recovery with [Volume Up] + [Home] + [Power]
9. Install SuperSu with TWRP Recovery (to be rooted with SuperSU)
   1. Install > Select Storage "USB OTG"
   2. Click on "SuperSu.zip" > Swipe to confirm Flash
   3. Reboot System and go back to Recovery with [Volume Up] + [Home] + [Power]
10. Wait 2-5 minutes for your device to finish setting itself up.
11. Check Root with SuperSu

## Flash TWRP as recovery

```bash
adb reboot download
heimdall flash --RECOVERY twrp.img --no-reboot
```

## Flash e.OS

* [/e/OS](https://e.foundation/e-os/)
* [Install /e/OS on a Samsung Galaxy S7 - herolte](https://doc.e.foundation/devices/herolte/install)

* `adb reboot recovery`
* TWRP > Wipe > Format Data > Type "yes"
* TWRP > Wipe > Advanced Wipe > Select: System, Cache > Swipe to Wipe
* TWRP > Advanced > ADB Sideload
* `adb sideload filename.zip`
* Reboot

## Install Open GApps

* `adb reboot recovery`
* TWRP > Advanced > ADB Sideload
* `adb sideload open_gapps.zip`

