# Rdiff Backup

* [rdiff-backup](https://rdiff-backup.net/)
* [GitHub Release](https://github.com/rdiff-backup/rdiff-backup/releases/latest)
* [Windows Scripts](../System/Windows/Backup/rdiff-backup/)

Incremental backup creation.

Linux:

```bash
sudo apt install rdiff-backup
```

## Backup

Linux:

```bash
rdiff-backup --use-compatible-timestamps --api-version 201 backup /tmp/source/ /tmp/backup/
rdiff-backup --use-compatible-timestamps --api-version 201 backup user@localhost::/tmp/source/ /tmp/backup/

# rdiff-backup --verbosity 5 backup \
rdiff-backup --use-compatible-timestamps --api-version 201 --verbosity 5 backup \
  --exclude /var/www/vhosts/website_www/.git \
  --exclude /var/www/vhosts/website_www/var \
  --exclude /var/www/vhosts/website_www/public/tmp \
  server::/var/www/vhosts/website_www/ /backup/website_www/

# Old api version
rdiff-backup --use-compatible-timestamps --api-version 200 /tmp/data/ /tmp/backup/
```

Windows:

*Note: If you don't use --no-acls then the GUID from old user is stored.*

```shell
# --no-acls = No permissions (Shows: Warning: Windows Access Control List file not found.)
C:\Users\username\Desktop\rdiff-backup --use-compatible-timestamps --api-version 201 --verbosity 5 backup --no-acls ^
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
rdiff-backup --api-version 201 list increments /tmp/backup

# Old api version
rdiff-backup --api-version 200 list increments /tmp/backup
```

## Restore backup

Linux:

```bash
# Last backup
rdiff-backup --api-version 201 restore --at now /tmp/backup/ /tmp/restored/
rdiff-backup --api-version 201 restore --at now /tmp/backup/ user@localhost::/tmp/restored/

# Specified time
rdiff-backup --api-version 201 restore --at 2025-01-14T00-23-53 /tmp/backup/ /tmp/restored/

# Old api version
rdiff-backup --api-version 200 restore --at now /tmp/backup/ /tmp/restored/
```

Windows:

```shell
# --no-acls = No permissions (Shows: Warning: Windows Access Control List file not found.)
C:\Users\username\Desktop\rdiff-backup --api-version 201 restore --no-acls --at now ^
  "D:/backup/" "C:/Users/username/Desktop/restore/"
```

## Delete old backups

Linux:

```bash
# Delete older than 30 backups
rdiff-backup --api-version 201 --force remove increments --older-than 30B /tmp/backup

# Delete older than 3 months
rdiff-backup --api-version 201 --force remove increments --older-than 3M /tmp/backup

# Delete older than 12 weeks
rdiff-backup --api-version 201 --force remove increments --older-than 12W /tmp/backup

# Old api version
rdiff-backup --api-version 200 --force remove increments --older-than 1B /tmp/backup
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

## Other

Backup server to Windows:

```powershell
rdiff-backup --remote-schema "ssh.exe -i $env:USERPROFILE\.ssh\id_rsa.pub -C {h} rdiff-backup --server" user@server-ip::/remote/folder .\backup\
```
