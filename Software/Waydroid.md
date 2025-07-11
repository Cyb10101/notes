# Waydroid

*Note: Needs Wayland display server.*

* [Waydroid](https://waydro.id/)
* [Documentation](https://docs.waydro.id/)

Install:

```bash
sudo apt -y install curl ca-certificates
curl https://repo.waydro.id | sudo bash

sudo apt -y install waydroid
sudo systemctl enable --now waydroid-container

sudo waydroid init \
    --rom_type lineage \
    --system_type VANILLA
```

* Run Waydroid
* Disable On-Screen Keyboard:
  * Settings > System > Languages & input > Physical keyboard > Use on-screen keyboard = false

```bash
waydroid prop set persist.waydroid.multi_windows true
waydroid prop set persist.waydroid.width 2880
waydroid prop set persist.waydroid.height 1538
waydroid session stop
```

Run Waydroid and install F-Droid:

```bash
wget -O /tmp/F-Droid.apk https://f-droid.org/F-Droid.apk
waydroid app install /tmp/F-Droid.apk
```

* [Aurora Store](https://f-droid.org/en/packages/com.aurora.store/)

@todo https://docs.waydro.id/faq/setting-up-a-shared-folder
@todo https://docs.waydro.id/faq/backup-restore-apps-and-data

## Upgrade

```bash
sudo waydroid upgrade
```

## Status & Logs

```bash
waydroid status
waydroid log
```

## Google Play Certification

* [Google Play Certification](https://docs.waydro.id/faq/google-play-certification)

```bash
sudo waydroid shell

ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";"
```

Use the string of numbers printed by the command to register the device on your Google Account at 

* [Google Android Uncertified](https://www.google.com/android/uncertified)

Give the Google services some minutes to reflect the change, then restart waydroid.

## Uninstall/Reinstalling Waydroid

```bash
waydroid session stop
sudo waydroid container stop
sudo apt remove waydroid

sudo rm -rf \
  /var/lib/waydroid \
  /home/.waydroid \
  ~/waydroid \
  ~/.share/waydroid \
  ~/.local/share/applications/waydroid* \
  ~/.local/share/waydroid
#~/.local/share/applications/*aydroid* \

sudo rm /etc/apt/sources.list.d/waydroid.list
```
