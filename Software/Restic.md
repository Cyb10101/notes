# Restic (Backup)

Incremental backup creation.

* [Website](https://restic.net/)
* [GitHub Release](https://github.com/restic/restic/releases/latest)
* [Documentation](https://restic.readthedocs.io/)
* [Windows Scripts](../System/Windows/Backup/restic/)

## Installation

Linux:

```bash
sudo apt update && sudo apt install -y restic && sudo restic self-update

# Doesn't work without "export"
# -r ${RESTIC_REPOSITORY} -p ${RESTIC_PASSWORD_FILE}

export RESTIC_REPOSITORY=~/restic-repository
#export RESTIC_REPOSITORY=sftp:user@192.168.178.40:/tmp/backup/restic-repository
#export RESTIC_REPOSITORY="sftp:my-server:/home/user/backup-repository"

export RESTIC_PASSWORD=123456
export RESTIC_PASSWORD_FILE=~/.restic/password.txt

# chmod -R go-rwx ~/.restic
echo '123456' > ${RESTIC_PASSWORD_FILE}

echo 'export RESTIC_REPOSITORY="/tmp/backup/restic"' >> ~/.bashrc
echo 'export RESTIC_REPOSITORY="/tmp/backup/restic"' >> ~/.zshrc
```

Windows:

```shell
set RESTIC_REPOSITORY=D:\restic-repository
set RESTIC_REPOSITORY=sftp:user@192.168.178.40:/tmp/backup/restic-repository
set RESTIC_REPOSITORY="sftp:my-server:/home/user/backup-repository"

set RESTIC_PASSWORD=123456
set RESTIC_PASSWORD_FILE=%USERPROFILE%\restic-password.txt
```

Untested Windows mounts: https://winfsp.dev/

## Initialize Repository

Linux:

```bash
restic init
#restic init -r ${RESTIC_REPOSITORY} -p ${RESTIC_PASSWORD_FILE}
#restic init -r sftp:user@host:/srv/restic-repo
```

Windows:

```shell
# Set password
echo 123456 > D:\password.txt

C:\Users\username\Desktop\restic init -r D:\restic-repository -p D:\password.txt
```

## Backup

Linux:

```bash
sudo /usr/bin/restic backup --host=cyb-pc-linux \
  --exclude /home/username/.cache \
  --exclude /home/username/.local/share/Trash \
  --exclude /home/username/snap/spotify \
  --exclude /mnt/home/username/projects/*/var/cache \
  --exclude /mnt/home/username/Steam \
  --exclude /mnt/home/username/VirtualBox \
  /home/username \
  /etc \
  /mnt/home/username
```

Windows:

```shell
# -r D:\restic-repository -p D:\password.txt
%USERPROFILE%\Desktop\restic backup --host=cyb-pc-windows ^
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
  C:\Users\username\ ^
  %USERPROFILE%\Desktop
```

## List backups

Linux:

```bash
restic snapshots
restic snapshots --latest 1
restic snapshots --latest 1 --host=cyb-pc
```

Windows:

```shell

```

## Mount

Linux:

```bash
restic mount `mktemp -d /tmp/restic_mount_$(date +%H-%M)_XXXXXXXX`

# restic mount --host=cyb-pc `mktemp -d /tmp/restic_$(date +%H-%M)_XXXXXXXX`
# restic mount --path="${HOME}/Bilder" `mktemp -d /tmp/restic_$(date +%H-%M)_XXXXXXXX`
```

*Note: Windows mount not yet possible.*

## Restore backup

Linux:

```bash
restic restore --host=cyb-pc --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` latest

#restic restore --host=cyb-pc --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` --path="${HOME}/Bilder" latest

#restic restore --host=cyb-pc --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` --path=["${HOME}/Bilder" "${HOME}/Dokumente" "${HOME}/Musik"] latest

# restic restore --host=cyb-pc --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` \
#   --path="${HOME}/Bilder" \
#   --path="${HOME}/Dokumente" \
#   --path="${HOME}/Musik" \
#   latest
```

Windows:

```shell
# -r D:\restic-repository -p D:\password.txt
%USERPROFILE%\Desktop\restic restore --host=cyb-windows ^
  --target=%USERPROFILE%\Downloads\restore latest
```

## Remove old backups

Linux:

```bash
restic forget --keep-last 10
```

## Linux Scripts

```bash
#!/usr/bin/env bash
export RESTIC_REPOSITORY="/tmp/restic-repository"
export RESTIC_PASSWORD="123456"
export RESTIC_PASSWORD_FILE="~/.restic/password.txt"

exec /usr/bin/restic "\$@"
```

## Windows Scripts

Windows SSH Copy ID (ssh-copy-id):

```powershell
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh user@192.168.178.40 "cat >> .ssh/authorized_keys"
```

SSH:

```shell
cat %USERPROFILE%\.ssh\config
```

Script:

```shell
@echo off

set RESTIC_REPOSITORY=D:\restic-repository
set RESTIC_PASSWORD=123456
set RESTIC_PASSWORD_FILE=%USERPROFILE%\restic-password.txt

%USERPROFILE%\Desktop\restic %*
rem "C:\ProgramData\scoop\apps\restic\current\restic" %*
```

## Diff added and changed files

```bash
sudo apt -y install jq

sudo su
export RESTIC_REPOSITORY="/mnt/backup/repository"
export RESTIC_PASSWORD_FILE="/home/username/.config/restic/password.txt"

# Get latest and previous snapshot
PREVIOUS=$(restic snapshots --json | jq -r '.[-2].short_id'); echo "Previous: ${PREVIOUS}"
LATEST=$(restic snapshots --json | jq -r '.[-1].short_id'); echo "Latest: ${LATEST}"

# Add files and change permissions
touch diff.json added-or-changed.txt snapshot-list.txt added-or-changed_by-size.txt
chown cyb10101:cyb10101 diff.json added-or-changed.txt snapshot-list.txt added-or-changed_by-size.txt

# Convert changes from snapshot to regular expression
restic diff --metadata --json $PREVIOUS $LATEST > diff.json
jq -r 'select(.modifier == "+" or .modifier == "M") | "\(.path)"' diff.json > added-or-changed.txt

# Get file list from latest snapshot
restic ls --long --json $LATEST | jq -r 'select(.size != null) | "\(.size) \(.path)"' | sort -rnk 1 | numfmt --field=1 --to=iec-i --suffix=B --padding=7 > snapshot-list.txt

# Grep pattern file with file list
grep -F -f added-or-changed.txt snapshot-list.txt > added-or-changed_by-size.txt

# Other: Find changes in music folder
cat diff.json | jq 'select(.path | test("^\/home\/cyb10101\/[mM]usi[ck]")?)'
```

## Remote backup (Beta)

Theoretical possibility to do a backup reverse.

Linux:

```bash
sudo apt install sshfs
DIR_BACKUP_SSH=`mktemp -d /tmp/restic_$(date +%H-%M)_XXXXXXXX`
sshfs user@192.168.178.71:/home/user ${DIR_BACKUP_SSH}
cd ${DIR_BACKUP_SSH}
restic backup --host=cyb-server --tag=example.com .
restic backup --host=cyb-server --tag=example.org ${DIR_BACKUP_SSH}/./
cd -
fusermount -u ${DIR_BACKUP_SSH}
```

## Database backup (untested)

Theoretical possibility to do a database backup.

Linux:

```bash
set -o pipefail
mysqldump [...] | restic -r /srv/restic-repo backup --stdin

mysqldump [...] | restic -r /srv/restic-repo backup --stdin --stdin-filename=website_www.sql

mysqldump [...] | gzip | restic -r /srv/restic-repo backup --stdin --stdin-filename=website_www.sql.gz

cat /etc/group | restic backup --tag=database --stdin --stdin-filename=website_www.sql
```

## Update repository

```bash
# Maybe remove some snapshots
restic snapshots
restic forget
restic prune

# Update repository from version 1 to 2
restic cat config
restic check
restic migrate upgrade_repo_v2
restic prune
restic prune --repack-uncompressed --max-repack-size=200G
```
