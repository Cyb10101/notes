# Linux: Bugfix

## Fixing an corrupted Windows NTFS partition

```bash
sudo apt-get install ntfs-3g ntfsprogs
sudo fdisk -l
sudo ntfsfix /dev/<device>
```

For newer Ubuntus You can use -b and -d option together.

* -b tries to fix bad clusters
* -d to fix dirty states.

```bash
sudo ntfsfix -b -d /dev/sda1
```

## Rescue an NTFS partition

```bash
sudo blkid
sudo mkdir /mnt
sudo ntfs-3g -o force,rw /dev/sda1 /mnt
```

## Fixing an corrupt Master Boot Record (untested)

```bash
sudo apt install lilo
sudo fdisk -l
sudo lilo -M /dev/ mbr
```

## Time difference in Windows 11 and Linux

Set Windows 11 Time to UTC.

Run Command in as Administrator:

```shell
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```

Type `Windows + R` and run `ms-settings:dateandtime` (Settings > Time & Language > Date & Time).
Toogle off and on "Set time automatically".

*Keyword: linux*

## Time difference in Windows 10 and Linux

Set Linux Time to RTC.

Run Terminal in Linux:

```bash
# Status
timedatectl

# Linux use local time instead UTC
timedatectl set-local-rtc 1 --adjust-system-clock

# Update time by internet
timedatectl set-ntp 0
timedatectl set-ntp 1
```

*Tags: Windows timezone, Same time for Windows and Linux*
