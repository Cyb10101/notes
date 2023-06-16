# Scrcpy (screen copy)

* [scrcpy](https://github.com/Genymobile/scrcpy)

```bash
sudo apt -y install scrcpy

# Default
scrcpy --push-target=/storage/emulated/0/Download --shortcut-mod=lalt --show-touches --stay-awake

# With serial id
scrcpy -s 192.168.178.21:42047 --push-target=/storage/emulated/0/Download --shortcut-mod=lalt --show-touches --stay-awake

# Turn screen off
scrcpy --push-target=/storage/emulated/0/Download --shortcut-mod=lalt --show-touches --stay-awake --turn-screen-off
```

* [Shortcuts](https://github.com/Genymobile/scrcpy#shortcuts)

| Action                  | Shortcut                |
| ----------------------- | ----------------------- |
| Turn screen off         | MOD + O                 |
| Turn screen on          | MOD + Shift + O         |
| Rotate device screen    | MOD + R                 |
| Rotate display left     | MOD + Left              |
| Rotate display right    | MOD + Right             |
| Switch fullscreen       | MOD + F                 |
| Click on HOME           | MOD + H or Middle-click |
| Click on BACK           | MOD + B or Right-click  |
| Click on APP_SWITCH     | MOD + S or 4th-click    |
| Notification Bar        |         or 5th-click    |
| Pinch-to-zoom           | Ctrl + click-and-move   |
