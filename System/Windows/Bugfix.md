# Windows: Bugfix

## Time difference in Windows 11 and Linux

* See old: [Linux Bugfix](../Linux/Bugfix.md#time-difference-in-windows-10-and-linux)

Set Windows 11 Time to UTC.

Run Command in as Administrator:

```shell
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```

Type `Windows + R` and run `ms-settings:dateandtime` (Settings > Time & Language > Date & Time).
Toogle off and on "Set time automatically".

*Keyword: Timezone, Same time for Windows and Linux*

## Delete Windows folders and files with trailing spaces

```bash
rmdir "\\?\d:\MyFolder "
```

## Delete network drive

Delete network drive, cannot be connected, permissions are missing...

* (does not have to) Restart PC without LAN/WLAN (Cable out/Flight mode)
* (Not necessary) There may be a folder or a connected folder (But is not connected in the data carrier management)
* Open `cmd` as administrator
* Go to drive Z: and type dir, then a hard drive should appear, back to drive C:

```bash
mountvol Z: /D
```

* Possibly restart
