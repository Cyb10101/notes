# Putty

## Configuration

```text
Terminal > Keyboard > The function keys and keypad > Linux
Terminal > Features > Disable Application Keypad mode > aktivieren

Window > Translation > Remote character Set > UTF-8
Connection > Data > Terminal-type string > linux
```

## Export configuration

```bash
regedit /e "%userprofile%\desktop\putty-sessions.reg" HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions
regedit /e "%userprofile%\desktop\putty.reg" HKEY_CURRENT_USER\Software\SimonTatham
```

## Import configuration

```bash
regedit "%userprofile%\desktop\putty-sessions.reg"
regedit "%userprofile%\desktop\putty.reg
```
