# rdiff-backup

Incremental backup creation.

```bash
sudo apt install rdiff-backup
```

## Backup

Linux

```bash
rdiff-backup -b /tmp/data/ /tmp/backup/
rdiff-backup -b user@localhost::/tmp/data/ /tmp/backup/
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
rdiff-backup -l /tmp/backup/
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
```

## Delete old backups

```bash
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
