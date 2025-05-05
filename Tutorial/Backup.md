# Backup

In most cases there is no need to make a full backup of a hard drive. More under [Backup Entire Disk](../System/Linux/Backup-Entire-Disk.md).

But what you want is as simple a tool as possible to back up the most important and personal files.

* Another example: [Linux backup manually](../System/Linux/Backup-Manually.md)

## Inexperienced users

For most inexperienced users, it is a good choice.

* [ascomp - BackUp Maker](https://www.ascomp.de/de/products/backupmaker/)

## Experienced users

For the experienced users who can handle a terminal, this choice will be better.

Rsync and exclude folder & files on Windows:

```bash
# --log-file="/mnt/rsync-backup-log.txt"

rsync -rtPhv --no-p --no-g --chmod=ugo=rwX --delete \
  --exclude "**/NTUSER.DAT" \
  --exclude "**/ntuser.dat.*" \
  --exclude "**/AppData/Local/Comms" \
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/**/LOCK" \
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/lockfile" \
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/Default/Cache" \
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/GrShaderCache/GPUCache" \
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/ShaderCache/GPUCache" \
  --exclude "**/AppData/Local/Microsoft/Internet Explorer/CacheStorage" \
  --exclude "**/AppData/Local/Microsoft/Windows/Notifications" \
  --exclude "**/AppData/Local/Microsoft/Windows/UsrClass.dat*" \
  --exclude "**/AppData/Local/Microsoft/Windows/WebCache" \
  --exclude "**/AppData/Local/Microsoft/Windows/WebCacheLock.dat" \
  --exclude "**/AppData/Local/Microsoft/WindowsApps" \
  --exclude "**/AppData/Local/Packages" \
  --exclude "**/AppData/Local/Temp" \
  --exclude "**/AppData/Roaming/ASCOMP Software/BackUp Maker" \
  /mnt/c/Users/username/ /media/backup/
```

Backup:

* [Restic](../Software/Restic/Restic.md)
* [rdiff-backup](../Software/rdiff-backup.md)

Syncronisation:

* [Syncthing](../Software/Syncthing.md)
