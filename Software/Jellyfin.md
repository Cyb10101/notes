# Jellyfin

* [Jellyfin](https://jellyfin.org/)

## Notes

If something doesn't play properly:

* Don't use live [transcoding](https://jellyfin.org/docs/general/post-install/transcoding/), expect your computer have enough power to handle that.
* Don't stream via a browser, since only a few codecs are supported. Use the apps/clients instead.
* Some apps must explicitly use another player app for playback like: ExoPlayer, [MPV](https://mpv.io/), [VLC](https://www.videolan.org/vlc/), ...
  * Android: Profile > Client-Settings > Videoplayer: Type of video player > Integrated (ExoPlayer) or external Player
* Try installing any missing codecs
* Try converting the video to a different codec

## Docker server

* [Jellyfin Test Videos](https://repo.jellyfin.org/test-videos/)

```bash
wget --mirror --no-parent --continue --wait 2 --reject '*.html,*.md5sum,*.sha1sum,*.sha256sum' 'https://repo.jellyfin.org/test-videos/'
wget --recursive --no-parent --spider --reject '*.html,*.md5sum,*.sha1sum,*.sha256sum' 'https://repo.jellyfin.org/test-videos/' 2>&1 | grep '^--' | awk '{ print $3 }' > download-list.txt
```

## Docker server

* [Jellyfin Container](https://jellyfin.org/docs/general/installation/container)

That might not be a good example. It’s not absolutely necessary to use Traefik; you can just run everything through ports.
Since it works and I have other things to do, I'll improve it later.

```yaml
# mkdir -p .docker/jellyfin/{cache,config}
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    restart: 'unless-stopped'
    #restart: always
    user: 1000:1000
    group_add: # Needed to provide permissions to the VAAPI Devices: getent group render video
      - '992'  # render
      - '44'   # video
    #network_mode: 'host' # Network mode of 'host' exposes the ports on the host. This is needed for DLNA access.
    ports:
      - 8096:8096/tcp
      - 7359:7359/udp
    volumes:
      - ./.docker/jellyfin/cache:/cache
      - ./.docker/jellyfin/config:/config
      - type: bind
        source: ./media
        target: /media
      - type: bind
        source: /mnt/storage/movies
        target: /movies
        read_only: true
      - type: bind
        source: /mnt/storage/series
        target: /series
        read_only: true
      # Optional - extra fonts to be used during transcoding with subtitle burn-in
      #- type: bind
      #  source: /path/to/fonts
      #  target: /usr/local/share/fonts/custom
      #  read_only: true
    environment:
      - LANG=de_DE.UTF-8
      - LANGUAGE=de_DE:de
      - LC_ALL=de_DE.UTF-8
      - JELLYFIN_PublishedServerUrl=https://jellyfin.dev.localhost
      #- JELLYFIN_PublishedServerUrl=http://192.168.178.21:8096
    labels:
      - traefik.enable=true
      - traefik.http.routers.dev_jellyfin.rule=Host(`jellyfin.dev.localhost`)
      - traefik.http.services.dev_jellyfin.loadbalancer.server.port=8096
      #- traefik.http.routers.dev_jellyfin.middlewares=redirect-www@file

      # TLS
      - traefik.http.routers.dev_jellyfin.entrypoints=websecure
      - traefik.http.routers.dev_jellyfin.tls=true
      #- traefik.http.routers.dev_jellyfin.tls.certresolver=letsEncrypt
    devices:
      # VAAPI Devices: ls -1d /dev/dri/*
      - /dev/dri/renderD128:/dev/dri/renderD128
      - /dev/dri/card1:/dev/dri/card1
      # ./start.sh exec -it app /usr/lib/jellyfin-ffmpeg/vainfo --display drm --device /dev/dri/renderD128
      # ./start.sh exec -it app /usr/lib/jellyfin-ffmpeg/ffmpeg -v debug -init_hw_device vulkan
    # Optional - may be necessary for docker healthcheck to pass if running in host network mode
    #extra_hosts:
    #  - 'host.docker.internal:host-gateway'

networks:
  default:
    external: true
    name: global
```

## Client on Linux/Ubuntu

```bash
sudo flatpak install flathub org.jellyfin.JellyfinDesktop
sudo apt install mpv

# Standard codecs + fonts + MP3/AAC, etc.
# sudo apt install ubuntu-restricted-extras

# Additional GStreamer plugins + FFmpeg
# sudo apt install gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ffmpeg

# Consumer Electronics Control (CEC) works only if the hardware supports it
sudo apt install libcec6 cec-utils
cec-client -l # Shows devices when CEC is enabled

# Useless for Gampad Support, install Jellyfin directly or wait for patch
#flatpak override --user --device=all org.jellyfin.JellyfinMediaPlayer
#flatpak override --user --filesystem=/run/udev:ro org.jellyfin.JellyfinMediaPlayer
# Potentially with Flatpak >= 1.15.6/1.16, flatpak --version
#flatpak override --user --device=input org.jellyfin.JellyfinMediaPlayer
```

## Client configuration

Louder audio via mpv config:

* Jellyfin Desktop > Profile > Client-Settings > Other: Manual MPV Configuration

```ini
volume-gain=10
```

## Client CSS Customization

[CSS Customization](https://jellyfin.org/docs/general/clients/css-customization/):

```css
/* Disable Image Carousel for Libraries */
@media all and (min-width: 50em) {
  .homePage .emby-scroller {
    margin-right: 0;
  }
  .homePage .emby-scrollbuttons {
    display: none;
  }
  .homePage .itemsContainer {
    flex-wrap: wrap;
  }
}

/* Size episode preview images in a more compact way */
.listItemImage.listItemImage-large.itemAction.lazy {
  height: 110px;
}
.listItem-content {
  height: 115px;
}
.secondary.listItem-overview.listItemBodyText {
  height: 61px;
  margin: 0;
}
```

## Kiosk (Cage)

Kiosk mode, media center, Home Theater Personal Computer (HTPC), or whatever you call it when you use a small computer as a TV player.

* Maybe you should not use a sandbox system like Flatpak.
* Use as few permissions as possible.
  * That means locking the app, for example using Cage.
  * Create a Linux user "tv/jellyfin" only to stream.
  * Optionally, create a "TV/Guest" account in Jellyfin so that other people can log in or stream using only the most basic permissions.
* Use a `cage-watchdog-jellyfin.sh` script to reload Jellyfin, if client lost connection to server.

Install and create cage-jellyfin.desktop:

```bash
sudo apt install cage
sudo vim /usr/share/wayland-sessions/cage-jellyfin.desktop
```

Contents of cage-jellyfin.desktop:

```ini
[Desktop Entry]
Name=Jellyfin Kiosk
Comment=Run Jellyfin in Cage
Exec=/usr/bin/cage -- /usr/local/bin/cage-watchdog-jellyfin.sh
#Exec=/usr/bin/cage -- env QT_QPA_PLATFORM=wayland QT_WAYLAND_DISABLE_WINDOWDECORATION=1 /usr/bin/flatpak run org.jellyfin.JellyfinDesktop --fullscreen --tv --disable-gpu
Type=Application
DesktopNames=Cage
```

*Note: Improved mouse movement using QT_QPA_PLATFORM=wayland QT_WAYLAND_DISABLE_WINDOWDECORATION=1*

Create cage-jellyfin.desktop:

```bash
sudo vim /usr/local/bin/cage-watchdog-jellyfin.sh
```

Contents of cage-watchdog-jellyfin.sh:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configure this
SERVER_URL="http://192.168.178.21:8096/health"
INITIAL_CHECK_SECONDS=10
RUNTIME_CHECK_SECONDS=180
FAILS_BEFORE_RESTART=3

# Jellyfin command
APP_ID="org.jellyfin.JellyfinDesktop"
APP_CMD=(/usr/bin/flatpak run "$APP_ID" --fullscreen --tv --disable-gpu)

# Wayland/QT
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

is_server_up() {
  /usr/bin/curl -fsS --max-time 3 "$SERVER_URL" > /dev/null 2>&1
}

# Flatpak signal not exists
kill_app_soft_kill() {
  # Ask nicely
  /usr/bin/flatpak kill --signal=TERM "$APP_ID" >/dev/null 2>&1 || true

  # Wait up to 30 seconds
  for _ in {1..30}; do
    if ! /usr/bin/flatpak ps | grep -q "$APP_ID"; then
      return
    fi
    sleep 1
  done

  # Force kill
  /usr/bin/flatpak kill --signal=KILL "$APP_ID" >/dev/null 2>&1 || true
}

kill_app() {
  /usr/bin/flatpak kill "$APP_ID" >/dev/null 2>&1 || true
}

while true; do
  # Wait until server is reachable
  until is_server_up; do sleep "$INITIAL_CHECK_SECONDS"; done

  # Start app
  "${APP_CMD[@]}" &
  APP_PID=$!

  # Monitor while app is running
  fails=0
  while kill -0 "$APP_PID" >/dev/null 2>&1; do
    sleep "$RUNTIME_CHECK_SECONDS"

    if is_server_up; then fails=0; continue; fi

    fails=$((fails + 1))
    if [ "$fails" -ge "$FAILS_BEFORE_RESTART" ]; then
      kill_app; break
    fi
  done
done
```

Make it executable and create service for a user:

```bash
sudo chmod 755 /usr/local/bin/cage-watchdog-jellyfin.sh
sudo vim /var/lib/AccountsService/users/tv
```

Contents of `/var/lib/AccountsService/users/tv`:

```ini
[User]
Session=cage-jellyfin
XSession=cage-jellyfin
```

Configure Audio device:

```bash
# Login as tv via another terminal (Ctrl-Alt-F3)
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0
```

## Kiosk on Raspberry Pi v2 (Deprecated)

This creates an Openbox session with a Firefox browser. You probably want to use a Cage session (Wayland) instead and not use a browser.

```bash
# sudo apt install x11-xserver-utils
# xrandr

sudo apt install pulseaudio-utils
sudo apt install picom

sudo apt install openbox feh gnome-backgrounds
sudo adduser tv

sudo vim /etc/gdm3/custom.conf
```

```ini
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=tv
```

```bash
sudo vim /var/lib/AccountsService/users/tv
```

```ini
[User]
Session=openbox
XSession=openbox
Icon=/var/lib/AccountsService/icons/tv
SystemAccount=false
```

Create openbox autostart file:

```bash
mkdir -p ~/.config/openbox
sudo -u tv vim /home/tv/.config/openbox/rc.xml
sudo -u tv vim /home/tv/.config/openbox/autostart
```

File `~/.config/openbox/rc.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <keyboard>
    <!-- Ctrl+Alt+Backspace: Terminate Openbox -->
    <keybind key="C-A-BackSpace">
      <action name="Exit">
        <prompt>no</prompt>
      </action>
    </keybind>

    <!-- Ctrl+Alt+T: Run terminal -->
    <keybind key="C-A-T">
      <action name="Execute">
        <command>gnome-terminal</command>
      </action>
    </keybind>
  </keyboard>
</openbox_config>
```

File `~/.config/openbox/autostart`:

```bash
# Disable any form of screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

# Allow quitting the X server with CTRL-ALT-Backspace
#setxkbmap -option terminate:ctrl_alt_bksp

# PipeWire
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0

# Lightweight compositor for X11
#picom --vsync &
picom --backend glx --vsync --unredir-if-possible --no-use-damage & # AMD (GLX + VSync)
#picom --backend xrender --vsync & # Wenn es mit GLX schlechter wird
#picom --backend glx --no-vsync &  # Doppeltes V-Sync vermeiden. Falls du TearFree in Xorg gesetzt hast (amdgpu-Option), kann TearFree + picom-vsync zusammen „zäh“ werden.

# Add a background
feh --borderless --bg-scale /usr/share/backgrounds/gnome/blobs-l.svg &

# Run a terminal
#stterm &
#gnome-terminal &

# Jellyfin
flatpak run org.jellyfin.JellyfinDesktop --fullscreen --tv &
```

Autostart desktop:

```bash
vim ~/.profile
```

File `~/.profile`:

```bash
argsStart=(
  -nocursor
)
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx -- "${argsStart[@]}"
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

[Install]de
WantedBy=default.target
```

Add start script:

```bash
sudo install -m 755 -o root -g root /dev/null /usr/local/bin/kiosk-browser-start
sudo vim /usr/local/bin/kiosk-browser-start
```

File `/usr/local/bin/kiosk-browser-start`:

```bash
#!/bin/bash

URLS=(
  http://192.168.178.21:8096/
)

# Wait until Openbox running
for i in {1..10}; do
  xprop -root _NET_DESKTOP_NAMES >/dev/null 2>&1 && break
  sleep 1
done

# Start Firefox in kiosk mode
exec firefox --kiosk "${URLS[@]}"

# Reset Chromium exited uncleanly
#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' 	~/.config/chromium/Default/Preferences

# Start Chromium in kiosk mode
# Disable kiosk and type url directly: 'chrome://gpu/'
# --incognito
exec chromium-browser --disable-infobars --noerrdialogs --check-for-update-interval=1 \
  --simulate-critical-update --autoplay-policy=no-user-gesture-required --kiosk "${URLS[@]}"
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

## Kiosk on Raspberry Pi v1 (Deprecated)

Another way to set up a media center using Kodi. You probably want to use a Cage session (Wayland) if supported.

```bash
# Install lightdm if missing
sudo apt install lightdm

# Select as default if prompted
# sudo dpkg-reconfigure lightdm

sudo vim /etc/lightdm/lightdm.conf.d/50-autologin.conf
```

```ini
[Seat:*]
autologin-user=tv
autologin-user-timeout=0
autologin-session=openbox
```

```bash
sudo adduser kodi

# optional passwortfreihe anmeldung
sudo usermod -a -G nopasswdlogin tv
sudo reboot

sudo apt install picom

#~/.config/openbox/autostart
/etc/xdg/openbox/autostart
# Lightweight compositor for X11
picom --vsync &
```
