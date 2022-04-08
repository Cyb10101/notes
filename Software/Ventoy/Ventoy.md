# Ventoy

* [Ventoy](https://github.com/ventoy/Ventoy/releases)
* [Ventoy: Persistence images](https://github.com/ventoy/backend/releases)

* [Original Theme](https://github.com/vinceliuice/grub2-themes)
* [Distribution Icons](https://github.com/AdisonCavani/distro-grub-themes/tree/master/assets/icons)

Format USB with Ventoy GUI:

* Options > Secure Boot Support = true
* Partition Style > GPT
* Partition Configuration > Preserve some space at the end of the disk = 4 GB (Optional: Just for a data bin)

```bash
cd ~/opt/ventoy && sudo ./VentoyGUI.x86_64
```

* Optional: Use `gparted` to create a NTFS partition with name and description `ventoy-data` for the data bin
* Copy ISO Images to `/media/cyb10101/Ventoy`

Configure plugins:

```bash
lsblk /dev/sd?
cd ~/opt/ventoy && sudo ./VentoyPlugson.sh /dev/sdx
```

Create a 4 GB persistent image:

```bash
mkdir -p /media/cyb10101/Ventoy/persistence

# Much faster 4 GB
cd ~/opt/ventoy && sudo ./CreatePersistentImg.sh -s 4096 -t ext4 -l 'casper-rw' -o /tmp/persistence-4gb.dat
cp /tmp/persistence-4gb.dat /media/cyb10101/Ventoy/persistence/ubuntu-20.04.4-desktop-4gb.dat && sync

# Much faster 8 GB (Recommended for deploy script)
cd ~/opt/ventoy && sudo ./CreatePersistentImg.sh -s 8192 -t ext4 -l 'casper-rw' -o /tmp/persistence-8gb.dat
cp /tmp/persistence-8gb.dat /media/cyb10101/Ventoy/persistence/ubuntu-20.04.4-desktop-8gb.dat && sync

# Much faster 16 GB
cd ~/opt/ventoy && sudo ./CreatePersistentImg.sh -s 16384 -t ext4 -l 'casper-rw' -o /tmp/persistence-16gb.dat
cp /tmp/persistence-16gb.dat /media/cyb10101/Ventoy/persistence/ubuntu-20.04.4-desktop-16gb.dat && sync

# Direct
cd ~/opt/ventoy && sudo bash -c "./CreatePersistentImg.sh -s 4096 -t ext4 -l 'casper-rw' -o /media/cyb10101/Ventoy/persistence/ubuntu-20.04.4-desktop.dat; sync"
```

## Grub Theme

* JPEG not progressive!

Generate fonts:

```bash
# Default-Range=0x0-0x7f German-Range=0x0-0x257f
grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/Ubuntu_Regular_36.pf2 \
    --size=36 /usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf | grep -oP '(?<=Font name: ).*'

grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/Ubuntu_Regular_16.pf2 \
    --size=16 /usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf | grep -oP '(?<=Font name: ).*'

grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/Ubuntu_Mono_Regular_14.pf2 \
    --size=14 /usr/share/fonts/truetype/ubuntu/UbuntuMono-R.ttf | grep -oP '(?<=Font name: ).*'

grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/DejaVu_Sans_Regular_36.pf2 \
    --size=36 /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf | grep -oP '(?<=Font name: ).*'

grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/DejaVu_Sans_Regular_16.pf2 \
    --size=16 /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf | grep -oP '(?<=Font name: ).*'

grub-mkfont -v -r 0x0-0x257f -o ./themes/cyb/DejaVu_Sans_Mono_Regular_14.pf2 \
    --size=14 /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf | grep -oP '(?<=Font name: ).*'
```

Test theme:

```bash
sudo apt update && sudo apt -y install python3-pip qemu-system xorriso
pip install --user grub2-theme-preview
~/.local/bin/grub2-theme-preview /media/sf_public/grub-themes/cyb
```

*Note: Release mouse in QEmu with: Ctrl + Alt + G*
