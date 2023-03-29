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

## Time difference in Windows 10 and Linux

* See new: [Windows Bugfix](../Windows/Bugfix.md#time-difference-in-windows-11-and-linux)

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

*Tags: Timezone, Same time for Windows and Linux*

## Rules - AMD GPU - Invalid operator for GROUP

Error: /etc/udev/rules.d/70-amdgpu.rules:1 Invalid operator for GROUP.

Edit `/etc/udev/rules.d/70-amdgpu.rules`:

* Change `GROUP=="video"` to `GROUP="video"`
* Example: KERNEL=="kfd", GROUP="video", MODE="0660"

## Rules - AMD GPU - Invalid operator for GROUP

Error: /etc/udev/rules.d/60-brother-libsane-type1.rules:17 Invalid key 'SYSFS'
Error: /etc/udev/rules.d/60-brother-brscan4-libsane-type1.rules:9 Invalid key 'SYSFS'

Edit `/etc/udev/rules.d/60-brother-libsane-type1.rules`:
Edit `/etc/udev/rules.d/60-brother-brscan4-libsane-type1.rules`:

* Remove or comment out `SYSFS` line, if `ATTRS` works
* ... or ignore it
* Example: # SYSFS{idVendor}=="04f9", GOTO="brother_mfp_udev_2"

## PulseAudio

PulseAudio can suspend sinks after a period of inactivity (Pops when starting and stopping playback).
This can make an audible noise (like a crack/pop/scratch).
Sometimes even when move the slider volume, or open and close windows (KDE4).

You must include Gnome desktop manager default pulse audio file or you get bluetooth hardware error:
`GetManagedObjects() failed: org.freedesktop.DBus.Error.TimedOut: Failed to activate service 'org.bluez': timed out (service_start_timeout=25000ms)`

Edit `~/.config/pulse/default.pa`:

```bash
# Include default pulse audio
#.include /etc/pulse/default.pa
.include /usr/share/gdm/default.pa

# Do not suspend sinks
.nofail
unload-module module-suspend-on-idle
.fail

# If you don't have this file: /usr/share/gdm/default.pa
# Unload driver modules for Bluetooth hardware
#.ifexists module-bluetooth-policy.so
#  unload-module module-bluetooth-policy
#.endif
#.ifexists module-bluetooth-discover.so
#  unload-module module-bluetooth-discover
#.endif
```

```bash
shutdown -r
```

## Pulseaudio: Crackling [S/PDIF | SPDIF | TosLink]

Edit `~/.pulse/config/daemon.conf`:

```bash
#resample-method = speex-float-0
default-sample-rate = 48000
```

```bash
# sudo killall pulseaudio
# pulseaudio &

pulseaudio --check && pulseaudio --kill; pulseaudio --start

#Finally, start pulseaudio again as a daemon:
pulseaudio -D

shutdown -r
```
