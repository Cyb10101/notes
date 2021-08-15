# rdiff-backup

* [rdiff-backup.net](https://rdiff-backup.net/)

Incremental backup creation.

```bash
sudo apt install rdiff-backup
```

## Backup

Linux

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

Windows

```bash
rdiff-backup.exe -b "C:/source/" "E:/backup/destination/"

rdiff-backup.exe -b ^
  --exclude "**/NTUSER.DAT" ^
  "C:/source/" "E:/backup/destination/"
```

## List backups

```bash
# Complete folder
rdiff-backup -l /tmp/backup/

# One file
rdiff-backup -l public/index.php
```

## Restore backup

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

## Delete old backups

```bash
# Delete older than 30 backups
rdiff-backup --force --remove-older-than 30B /tmp/backup/

# Delete older than 3 months
rdiff-backup --force --remove-older-than 3M /tmp/backup/

# Delete older than 12 weeks
rdiff-backup --force --remove-older-than 12W /tmp/backup/
```

## rdiff-backup mount (fuse)

```bash
sudo apt install rdiff-backup-fs

# Mount backup
rdiff-backup-fs /tmp/data/ /tmp/backup/

# Unmount backup
sudo umount /tmp/data/
```
