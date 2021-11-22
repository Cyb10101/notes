# Rdiff Backup

* [rdiff-backup](https://rdiff-backup.net/)

Incremental backup creation.

Linux:

```bash
sudo apt install rdiff-backup
```

## Backup

Linux:

```bash
rdiff-backup -b /tmp/data/ /tmp/backup/
rdiff-backup -b user@localhost::/tmp/data/ /tmp/backup/

# rdiff-backup -bv5 \
rdiff-backup -b -v5 \
  --exclude /var/www/vhosts/website_www/.git \
  --exclude /var/www/vhosts/website_www/var \
  --exclude /var/www/vhosts/website_www/public/tmp \
  server::/var/www/vhosts/website_www/ /backup/website_www/
```

Windows:

*Note: If you don't use --no-acls then the GUID from old user is stored.*

``` shell
# --no-acls = No permissions (Shows: Warning: Windows Access Control List file not found.)
C:\Users\username\Desktop\rdiff-backup -b -v5 --no-acls ^
  --exclude "**/NTUSER.DAT" ^
  --exclude "**/ntuser.dat.*" ^
  --exclude "**/AppData/Local/Comms" ^
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/**/LOCK" ^
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/lockfile" ^
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/Default/Cache" ^
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/GrShaderCache/GPUCache" ^
  --exclude "**/AppData/Local/Microsoft/Edge/User Data/ShaderCache/GPUCache" ^
  --exclude "**/AppData/Local/Microsoft/Internet Explorer/CacheStorage" ^
  --exclude "**/AppData/Local/Microsoft/Windows/Notifications" ^
  --exclude "**/AppData/Local/Microsoft/Windows/UsrClass.dat*" ^
  --exclude "**/AppData/Local/Microsoft/Windows/WebCache" ^
  --exclude "**/AppData/Local/Microsoft/Windows/WebCacheLock.dat" ^
  --exclude "**/AppData/Local/Microsoft/WindowsApps" ^
  --exclude "**/AppData/Local/Packages" ^
  --exclude "**/AppData/Local/Temp" ^
  --exclude "**/AppData/Roaming/ASCOMP Software/BackUp Maker" ^
  C:\Users\username\ D:\backup\
```

## List backups

Linux:

```bash
# Complete folder
rdiff-backup -l /tmp/backup/

# One file
rdiff-backup -l public/index.php
```

## Restore backup

Linux:

```bash
# Last backup
rdiff-backup -r now /tmp/backup/ /tmp/data/
rdiff-backup -r now /tmp/backup/ user@localhost::/tmp/data/

# 10 days ago
rdiff-backup -r 10D /tmp/backup/ /tmp/data/

# Incremental backup
rdiff-backup -r 2017-07-12T21:00:58+02:00 /tmp/backup/ /tmp/data/

# One file
rdiff-backup -r 2017-07-12T21:00:58+02:00 /tmp/backup/ /tmp/data/index.php
```

Windows:

```shell
# --no-acls = No permissions (Shows: Warning: Windows Access Control List file not found.)
C:\Users\username\Desktop\rdiff-backup --no-acls -r now ^
  "D:/backup/" "C:/Users/username/Desktop/restore/"
```

## Delete old backups

Linux:

```bash
# Delete older than 30 backups
rdiff-backup --force --remove-older-than 30B /tmp/backup/

# Delete older than 3 months
rdiff-backup --force --remove-older-than 3M /tmp/backup/

# Delete older than 12 weeks
rdiff-backup --force --remove-older-than 12W /tmp/backup/
```

## Mount

With fuse.

Linux:

```bash
sudo apt install rdiff-backup-fs

# Mount backup
rdiff-backup-fs /tmp/data/ /tmp/backup/

# Unmount backup
sudo umount /tmp/data/
```
