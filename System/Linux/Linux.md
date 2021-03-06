# Linux

## Speedtest

[Windows IPerv 2 files](https://sourceforge.net/projects/iperf2/files/)

```bash
sudo apt install iperf
iperf -s
iperf -c 192.168.178.21
```

Activate speedtest on router: http://192.168.178.1/support.lua

Fritz!Box Support > Durchsatzmessungen > Messpunkt für einen Iperf-Client im Heimnetz aktivieren, Port 4711 für TCP und UDP = true

## Change Terminal window size

```bash
# height=24, width=98
echo -e "\033[8;24;98t"
```

## Sudo without password

sudo visudo

```bash
user    ALL=(ALL:ALL) NOPASSWD:ALL      # For a user
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL      # For a group
```

## Folder icons

```bash
# Get icon file
gio info -a metadata::custom-icon ${HOME}/folder

# Set icon file
gio set ${HOME}/folder metadata::custom-icon file:///usr/share/icons/Yaru/256x256/emblems/emblem-favorite.png

# Set icon to standard
gio set ${HOME}/folder -t unset metadata::custom-icon
```

## Convert files

```bash
# Resize all images in the current directory
mogrify -resize 800x600 ./*.JPG

# Convert all images in the current directory to PNG
mogrify -format png ./*

# Convert pretty much any format to any other as losslessly as possible
ffmpeg -i infile.ext -pass 2 -sameq outfile.ext

# Sound converter
sudo apt install soundconverter gstreamer0.10-plugins-ugly gstreamer0.10-ffmpeg gstreamer0.10-plugins-bad-multiverse
```

## Restore deleted files

Photorec: FAT, NTFS, Ext filesystem:

```bash
sudo apt install testdisk
sudo photorec -d /restored-files/ /dev/sda
```

Ext filesystem:

```bash
sudo extundelete --restore-file '/home/user/logo.png' /dev/sda1
sudo extundelete --restore-directory '/home/user/icons' /dev/sda1
```

### Create ISO from live disk (CD, DVD, Bluray)

```bash
sudo umount /dev/sr0
sudo dd if=/dev/sr0 of=image.iso bs=1M
sudo sync
```

### Generate a file

```bash
# 1 MB
sudo dd if=/dev/zero of=/tmp/fileZero bs=1M count=1

# 1 GB
sudo dd if=/dev/zero of=/tmp/fileZero bs=1M count=1024
```

## Datum/Zeit synchonizieren

```bash
sudo apt install ntpdate
sudo ntptime -s time.nist.gov
date
```

## Graphic card: ATI

Switch off underscan:

```bash
sudo aticonfig --set-pcs-val=MCIL,DigitalHDTVDefaultUnderscan,0
```

## Macro

Better use macro with go lang: [Macro Go-Lang](../../Programming/Binary/go-lang/macro/Macro.md)

```bash
sudo apt install xmacro
xmacrorec2 > /tmp/xmacro.txt
xmacroplay -d 50 < /tmp/xmacro.txt
```

## Set Date & Time

```bash
sudo ntpdate time.nist.gov
sudo ntpdate pool.ntp.org
```

## Ubuntu 16.04

### NumLock bei Login

```bash
sudo apt-get install numlockx
sudo gedit /etc/lightdm/lightdm.conf
```

» greeter-setup-script=/usr/bin/numlockx on

### NumLock nach Login

Systemeinstellungen > Tastatur > Belegungseinstellungen > Optionen > Verschiedene Optionen zur Kompatibilität
{Aktiv} Vorgegebene Nummernblocktasten

## Old: Konfiguration - Console

Set the keyboard to German.

```bash
apt-get install language-pack-de

vim /etc/environment
# LANG="de_DE.UTF-8"

vim /etc/default/locale
# LANG="de_DE.UTF-8"

# Set the keyboard to German
apt-get install console-data
dpkg-reconfigure console-data
dpkg-reconfigure console-setup
```
