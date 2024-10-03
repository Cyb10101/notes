# Ventoy

* [Ventoy](https://www.ventoy.net/)
* [Ventoy: Github](https://github.com/ventoy/Ventoy/releases/latest)
* [Ventoy: Persistence images](https://github.com/ventoy/backend/releases)

* [Original Theme](https://github.com/vinceliuice/grub2-themes)
* [Distribution Icons](https://github.com/AdisonCavani/distro-grub-themes/tree/master/assets/icons)

Install or upgrade:

```bash
VERSION=$(curl -fsSL https://api.github.com/repos/ventoy/Ventoy/releases/latest | jq -r '.tag_name' | sed -r 's/v//g'); echo "${VERSION}"
curl -o /tmp/ventoy.tar.gz -fsSL "https://github.com/ventoy/Ventoy/releases/download/v${VERSION}/ventoy-${VERSION}-linux.tar.gz"
if [ -d ~/opt/ventoy ]; then gio trash ~/opt/ventoy; fi
tar -C ~/opt -xf /tmp/ventoy.tar.gz
mv ~/opt/ventoy-${VERSION} ~/opt/ventoy
```

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

Create a image for persistent storage:

```bash
mkdir -p /media/cyb10101/Ventoy/persistence

# Much faster
diskSizeGB=16
cd ~/opt/ventoy && sudo ./CreatePersistentImg.sh -s $((${diskSizeGB} * 1024)) -t ext4 -l 'casper-rw' -o /tmp/persistence-${diskSizeGB}gb.dat
cp /tmp/persistence-${diskSizeGB}gb.dat /media/cyb10101/Ventoy/persistence/ubuntu-24.04-desktop-${diskSizeGB}gb.dat && sync

# Note: If you want more than 16-32 GB persistent storage space, you may be doing something wrong.
#       Why not installing Linux on a external drive?
#       Why not attach a external drive to your live CD?
#       Why not create you own live CD?

# Direct
cd ~/opt/ventoy && sudo bash -c "./CreatePersistentImg.sh -s 4096 -t ext4 -l 'casper-rw' -o /media/cyb10101/Ventoy/persistence/ubuntu-24.04-desktop.dat; sync"
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

## Test with QEmu

```bash
lsblk
sudo apt install qemu-system spice-vdagent
sudo kvm -m 4G \
  -enable-kvm -smp $(nproc) -k de \
  -device intel-hda -device hda-duplex \
  -device virtio-net,netdev=vmnic -netdev user,id=vmnic \
  -chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on \
    -device virtio-serial-pci \
    -device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0 \
  -hda /dev/sdx
```