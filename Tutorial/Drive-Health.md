# Drive health

The larger the HDD disk, the more likely it is that the disk will fail.
As a rule of thumb, a hard drive should be replaced every 5-10 years.
Larger hard drives, from around 8 TB, can also fail earlier, within 3 years.

SSD hard drives last longer. Nevertheless, I would recommend everyone to create a backup of their most important data.

Windows alone will not display a message when a hard drive fails.
You can install CrystalDiskInfo for this.

## CrystalDiskInfo (GUI)

For Windows users.

* [Crystalmark: CrystalDiskInfo](https://crystalmark.info/en/download/#CrystalDiskInfo)

Configure:

* Function (German: Optionen)
  * Resident (German: Im Infobereich anzeigen) = true
  * Startup (German: Mit Windows starten) = true

Toolbar in taskbar (German: Symbolleiste in Taskleiste):

* CrystalDiskInfo
  * Collective Setting (German: Gemeinsame Einstellungen)
    * Hide all temperature icons (German: Alle Temperatursymbole ausblenden)

## GSmartControl (GUI)

* [GSmartControl](https://gsmartcontrol.sourceforge.io/home/)
* [GSmartControl (Redirected)](https://gsmartcontrol.shaduri.dev/)

For Linux users.

```bash
sudo apt install gsmartcontrol
```

## Smart monitor tools (CLI)

* [SmartMonTools - Windows package](https://www.smartmontools.org/wiki/Download#InstalltheWindowspackage)

```bash
for drive in /dev/sd[a-z]; do echo "$drive"; sudo smartctl -H $drive | grep --color=never '^SMART overall'; done

sudo apt install smartmontools
sudo systemctl status smartd
sudo update-smart-drivedb

# Enable smart on disk
sudo smartctl -s on /dev/sda

# Get information
sudo smartctl -i /dev/sda

smartctl --scan

# Print all information
sudo smartctl -a /dev/sda

# Print health status
sudo smartctl -H /dev/sda
```
