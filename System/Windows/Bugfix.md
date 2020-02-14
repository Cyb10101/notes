# Windows: Bugfix

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
