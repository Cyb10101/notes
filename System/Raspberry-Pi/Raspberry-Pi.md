# Raspberry Pi

*Based on Raspberry Pi 4*

* [Raspberry Pi OS](https://www.raspberrypi.com/software/)

Run "Raspberry Pi Imager", download "Raspberry Pi OS Lite (64 bit)" without Desktop, add custom settings and install it.

```bash
sudo apt -y install rpi-imager
```

* Check if system is old

```bash
sudo rpi-eeprom-update

# Update if current date is older than 2020-09-03
sudo rpi-eeprom-update -a
sudo reboot
```

* Install Raspberry PI OS Lite (64 Bit) on SSD/SATA Card

* Install system

```bash
sudo passwd root
sudo raspi-config
# 6 Advanced Options > A1 Expand Filesystem (Deprecated, not needed)
# 1 System Options > S4 Hostname = pi (Custom image config)
# 3 Interface Options > I2 SSH (Custom image config)
# 3 Interface Options > I3 VNC
# 5 Localisation Options > L1 Locale

sudo apt update
sudo apt full-upgrade

sudo apt -y install curl jq vim inxi duf
sudo update-alternatives --set editor /usr/bin/vim.basic

# For desktop:
# sudo apt -y install rpd-wallpaper-4k
sudo apt -y install firefox-esr
sudo apt -y install kodi
```

Edit `/boot/firmware/config.txt`:

```conf
# This prevents a CEC-enabled TV from coming out of standby and channel-switching when you are rebooting your Raspberry Pi
hdmi_ignore_cec_init=1
```

Add user snippets:

```bash
cat << EOF | sudo tee -a ~/.bashrc > /dev/null

# User: Alias
alias l='ls -vC --color=auto --group-directories-first'
alias la='ls -vA --color=auto --group-directories-first'
alias ll='ls -vahl --color=auto --group-directories-first'
alias ls='ls -v --color=auto --group-directories-first'
EOF
```

Configure swap:

```bash
sudo dphys-swapfile swapoff
sudo rm /var/swap

sudo vim /etc/dphys-swapfile
# 2 GB = 2048, 4 GB = 4096, 8 GB = 8192, 16 GB = 16384 (Maybe not a good idea to exceed this)
CONF_SWAPFILE=/mnt/storage/swapfile
#CONF_SWAPSIZE=2048
CONF_MAXSWAP=4096

sudo reboot

# Not needed?!
#sudo dphys-swapfile swapon
```

Install Docker:

```bash
sudo apt -y install docker.io
sudo usermod -aG docker ${USER}

# https://docs.docker.com/compose/
getGithubReleaseLatest() { \
    local usernameRepository="${1}"; \
    local VERSION=$(curl -fsSL https://api.github.com/repos/${usernameRepository}/releases/latest | jq -r '.tag_name' | sed -r 's/v//g'); \
    echo "${VERSION}"; \
}

usernameRepository='docker/compose'
VERSION=$(getGithubReleaseLatest "${usernameRepository}"); echo $VERSION
curl --progress-bar -o /tmp/docker-compose -fL "https://github.com/${usernameRepository}/releases/download/v${VERSION}/docker-compose-$(uname -s)-$(uname -m)"
sudo install /tmp/docker-compose /usr/local/bin/docker-compose
```

Configure VNC:

```bash
sudo vncpasswd -service
sudo nano /root/.vnc/config.d/vncserver-x11
# Add: Authentication=VncAuth
sudo systemctl restart vncserver-x11-serviced
```

Get temperature:

```bash
sudo nano /usr/local/bin/pi-temp
sudo chmod +x /usr/local/bin/pi-temp
```

Script pi-temp:

```bash
cat << EOF | sudo tee /usr/local/bin/pi-temp
#!/usr/bin/env bash
cpu=\$(</sys/class/thermal/thermal_zone0/temp)
echo "CPU: \$((cpu/1000)) °C"
echo "GPU: \$(/usr/bin/vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*') °C"
EOF
```

Argon case:

* [Argon ONE M.2 Case](https://www.argon40.com/products/argon-one-m-2-case-for-raspberry-pi-4)
* [Argon Remote](https://www.argon40.com/products/argon-remote)

```bash
# Configure Argon case
curl -fsSL https://download.argon40.com/argon1.sh | bash
argonone-config

# /etc/argononed.conf
# Argon Fan Speed Configuration CPU
# Min Temp=Fan Speed
55=33
60=66
65=100

# Configure Fan, Adjust to temperatures, Temperature 55C = 33, 60C = 66, 65C = 100

# Add drive
sudo lsblk -o name,fstype,size,uuid,mountpoint,label,model | grep -v 'loop'
sudo vim /etc/fstab
# UUID=359ec60a-994c-4f66-b66c-5f9bbaab785d /mnt/storage  ext4   errors=remount-ro 0 1

# Configure Argon infrared remote
# @todo Infrared missing???
argonone-ir
# Continue > 1. Configure Remote ON/OFF Button > Continue > 1. Use Argon Remote ON/OFF Button
# ??? sudo systemctl restart lircd.service
reboot
argonone-ir
# Continue > 2 Configure Other Remote Buttons > Continue > 1. Use Argon Remote Buttons

# Add Kodi addon
curl -o /tmp/argon-remote.zip -fsSL "https://download.argon40.com/ArgonRemote.zip"
unzip /tmp/argon-remote.zip -d ~/.kodi/addons
# ~/.kodi/addons/script.service.argonforty-device
# Kodi > Settings > Addons > Install from Repository > Program addons
# less /etc/lirc/lircd.conf.d/argon.lircd.conf
```

File `~/.kodi/???.xml`:
File `~/.kodi/userdata/argon.xml`:

```xml
<lircmap>
    <remote device="argon">
        <left>KEY_LEFT</left>
        <right>KEY_RIGHT</right>
        <up>KEY_UP</up>
        <down>KEY_DOWN</down>
        <select>KEY_OK</select>
        <start>KEY_HOME</start>
        <back>KEY_BACK</back>
        <menu>KEY_MENUBACK</menu>
        <volumeplus>KEY_VOLUMEUP</volumeplus>
        <volumeminus>KEY_VOLUMEDOWN</volumeminus>
    </remote>
</lircmap>
```

## Update Raspbery Pi OS

* [Upgrade your operating system to a new major version](https://www.raspberrypi.com/documentation/computers/os.html#upgrade-your-operating-system-to-a-new-major-version)

> To update the operating system to a new major release on your Raspberry Pi, image a second SD card with the new release. Use a USB SD card reader or network storage to copy files and configuration from your current installation to the new SD card. Then, swap the new SD card into the slot on your Raspberry Pi, and boot.

* [Backup-Entire-Disk](../notes/System/Linux/Backup-Entire-Disk.md)

```bash
# Backup SD-Card
sudo dd if=/dev/sdx of=pi-sdcard.img bs=64k status=progress
sudo chown 1000:1000 pi-sdcard.img

# Mount SD-Card (Use system to mount disks)
sudo losetup -Pf --show pi-sdcard.img

# Do not modify: /home/pi

# Modify files
# - /etc/fstab
# - /home/user/.ssh
# - /home/user/.bashrc

# Detach SD-Card
sudo losetup -d /dev/loop21
```

## Uptime Script

```bash
sudo apt install smartmontools bc
sudo vim /usr/local/sbin/pi-status
sudo chmod +x /usr/local/sbin/pi-status
```

File `pi-status`:

```bash
#!/bin/bash
# sudo apt install smartmontools bc
# sudo crontab -e
# */5 * * * * /usr/local/sbin/pi-status
# sudo journalctl -f -u cron

urlencode() {
  local data
  data=$(echo -n "$1" | od -An -tx1 | tr ' ' % | tr -d '\n')
  echo "$data"
}

STATUS="up"
MSG=""

# Get system temperature (for Raspberry Pi)
sysTempMax=70
sysTemp=$(cat /sys/class/thermal/thermal_zone0/temp)
sysTemp=$(echo "$sysTemp / 1000" | bc)
if [[ -z "$sysTemp" ]] || (( $sysTemp > $sysTempMax )); then
  STATUS="down"
  if [ ! -z "${MSG}" ]; then MSG+=" | "; fi
  MSG+="System Temp: ${sysTemp}/${sysTempMax}°C"
fi

# Check status /dev/sda
devSdaTempMax=50
devSdaTemp=$(sudo smartctl -A /dev/sda | grep -i "Temperature_Celsius" | awk '{print $10}')
devSdaSmartStatus=$(sudo smartctl -H /dev/sda | grep -i "test result" | awk '{print $NF}')
if [[ $devSdaSmartStatus != "PASSED" ]]; then
  STATUS="down"
  if [ ! -z "${MSG}" ]; then MSG+=" | "; fi
  MSG+="SDA Smart: ${devSdaSmartStatus}"
fi
if [[ -z "$devSdaTemp" ]] || (( $devSdaTemp > $devSdaTempMax )); then
  STATUS="down"
  if [ ! -z "${MSG}" ]; then MSG+=" | "; fi
  MSG+="SDA Temp: ${devSdaTemp}/${devSdaTempMax}°C"
fi

# Send to Uptime Kuma
uptimeKumaToken
curl --get "https://example.com/api/push/${uptimeKumaToken}" --data "status=$STATUS&msg=$(urlencode "${MSG}")&ping=0"
```

## Install Desktop

```bash
sudo tasksel
sudo systemctl set-default graphical.target
sudo raspi-config
# 1 System Options > S5 Boot > B1 Console
# 1 System Options > S6 Auto Login = False
```

## Install Kiosk

```bash
sudo apt -y install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox stterm feh gnome-backgrounds
#sudo apt -y install pipewire pulseaudio
sudo apt -y install firefox
sudo apt -y install chromium-browser

# Remove text to speech (TTS)
sudo apt-get remove orca

sudo raspi-config
# 1 System Options > S1 Audio > 72 vc4-hdmi-0
# 1 System Options > S5 Boot > B1 Console
# 1 System Options > S6 Auto Login = True
```

Create openbox autostart file:

```bash
sudo vim /etc/xdg/openbox/autostart
```

File `/etc/xdg/openbox/autostart`:

```bash
# Disable any form of screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

# Allow quitting the X server with CTRL-ALT-Backspace
setxkbmap -option terminate:ctrl_alt_bksp

# Add a background
feh --borderless --bg-scale /usr/share/backgrounds/gnome/blobs-l.svg &

# Run a terminal
#stterm &
```

Autostart desktop:

```bash
vim ~/.profile
```

File `~/.profile`:

```text
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx -- -nocursor
```

Autostart browser:

```bash
mkdir -p ~/.config/systemd/user
vim ~/.config/systemd/user/kiosk-browser.service
```

File `~/.config/systemd/user/kiosk-browser.service`:

```ini
[Unit]
Description=Kiosk Browser
After=openbox.target
Wants=openbox.target

[Service]
ExecStart=/usr/local/bin/kiosk-browser-start
Restart=always
ExecStop=/usr/bin/pkill -15 firefox
#ExecStop=/usr/bin/pkill -15 chromium-browser
TimeoutStopSec=10
KillSignal=SIGTERM

[Install]
WantedBy=default.target
```

Add start script:

```bash
sudo touch /usr/local/bin/kiosk-browser-start
sudo chmod 755 /usr/local/bin/kiosk-browser-start
sudo chown root:root /usr/local/bin/kiosk-browser-start
sudo vim /usr/local/bin/kiosk-browser-start
```

File `/usr/local/bin/kiosk-browser-start`:

```bash
#!/bin/bash
# Wait until Openbox running
for i in {1..10}; do
    xprop -root _NET_DESKTOP_NAMES >/dev/null 2>&1 && break
    sleep 1
done

# Start Firefox in kiosk mode
exec firefox --kiosk 'https://example.com/'

# Reset Chromium exited uncleanly
#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' 	~/.config/chromium/Default/Preferences

# Start Chromium in kiosk mode
# Disable kiosk and type url directly: 'chrome://gpu/'
# --incognito
exec chromium-browser --disable-infobars --noerrdialogs --check-for-update-interval=1 \
  --simulate-critical-update --autoplay-policy=no-user-gesture-required --kiosk \
  'https://example.com/'
```

Add Firefox user configuration to profile:

```bash
# In best cases open in browser: about:profiles
vim ~/.mozilla/firefox/profile/user.js
```

File `~/.mozilla/firefox/profile/user.js`:

```javascript
// Autoplay media
user_pref("media.autoplay.default", 0); // Allow autoplay
user_pref("media.autoplay.blocking_policy", 0);
user_pref("media.autoplay.allow-extension-background-pages", true);
user_pref("media.autoplay.enabled", true);

// Deactivate "Set default browser"-Dialog
user_pref("browser.shell.checkDefaultBrowser", false);

// Disable "Welcome page / What is new"
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");

// Disable telemetry or tips
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
```

Enable service:

```bash
systemctl --user daemon-reload
systemctl --user enable kiosk-browser.service
systemctl --user start kiosk-browser.service
```

Disable service:

```bash
systemctl --user stop kiosk-browser.service
systemctl --user disable kiosk-browser.service
```

## Other

* [DAKboard](https://dakboard.com/)
* [How to use a Raspberry Pi in kiosk mode](https://www.raspberrypi.com/tutorials/how-to-use-a-raspberry-pi-in-kiosk-mode/)
