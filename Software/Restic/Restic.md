# Restic (Backup)

Restic is a powerful tool for creating incremental backups
You should have a look at the documentation.

* [Website](https://restic.net/)
* [GitHub Release](https://github.com/restic/restic/releases/latest)
* [Documentation](https://restic.readthedocs.io/)
* [Windows Scripts](../System/Windows/Backup/restic/)

## Backup and restore user folder

I will show you an example of how to back up a user folder.
However, it is always an individual decision as to what should be secured and where.

Maybe this is a useful short script:

* [Linux Script: restic-helper.sh](restic-helper.sh)
* [Windows Script: restic-helper.sh](restic-helper.ps1)

### Linux

Install restic:

```bash
sudo apt -y install restic
```

Restic variables:

If you want to simplify the commands, you can save the Restic variables either in the shell file or in the script.

Otherwise you must always specify this in the command, for example like this:

```bash
restic -r "$RESTIC_REPOSITORY" -p "$RESTIC_PASSWORD_FILE" ...
```

Add variables in your shell file `~/.bashrc`:

```bash
export RESTIC_REPOSITORY=$HOME/restic-repository
#export RESTIC_REPOSITORY=sftp:user@192.168.178.21:/restic-repository

export RESTIC_PASSWORD_FILE=~/.config/restic/password.txt
```

**Do not forget to restart shell to apply variables.**

Add restic configuration:

```bash
# Create a folder
mkdir -p ~/.config/restic

# Add exclude files
touch ~/.config/restic/iexcludes.txt
touch ~/.config/restic/excludes.txt
@todo wget excludes

# Set a password without new line
vim ${RESTIC_PASSWORD_FILE}

# Set permissions
chmod -R go-rwx ~/.config/restic
```

Initialize Repository:

```bash
restic init
```

Now your repository is ready for creating backup.

Create a backup:

```bash
restic backup --host="my-pc" --tag="optional-tag" \
  --exclude-file=$HOME/.config/restic/excludes.txt \
  --exclude=$HOME/restic-repository \
  /home/user

# or simpler
restic backup --host="$(hostname)" --tag="$USER" \
  --exclude-file=$HOME/.config/restic/excludes.txt \
  --exclude=$HOME/restic-repository \
  $HOME
```

Maybe you want add `--iexclude-file=/home/user/.config/restic/iexcludes.txt` too.

List snapshots

```bash
restic snapshots

# Compact view
restic snapshots -c
```

Mount repository:

```bash
restic mount `mktemp -d /tmp/restic_mount_$(date +%H-%M)_XXXXXXXX`
```

Restore files:

```bash
# Restore all files, by host
restic restore --host="$(hostname)" --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` latest

# Restore all files, by host and path
restic restore --host="$(hostname)" --target=`mktemp -d /tmp/restic-restore_$(date +%H-%M)_XXXXXXXX` \
  --path="/home/user" latest
```

Forget snapshots:

```bash
# Dry run - Do nothing
restic forget --keep-last 90 --compact --dry-run

# Forget and prune (Delete snapshot)
restic forget --keep-last 90 --compact --prune
```

### Windows

Open a PowerShell as user:

Install restic:

```shell
scoop install restic
```

Restic variables:

If you want to simplify the commands, you can save the Restic variables either in the shell file or in the script.

Otherwise you must always specify this in the command, for example like this:

```shell
restic -r "$env:RESTIC_REPOSITORY" -p "$env:RESTIC_PASSWORD_FILE" ...
```

Add PowerShell profile if not exists:

```shell
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
```

Edit PowerShell profile:

```shell
notepad $PROFILE
```

Add variables in your shell file:

```shell
$env:RESTIC_REPOSITORY = "$env:USERPROFILE\restic-repository"
#$env:RESTIC_REPOSITORY = "sftp:user@192.168.178.21:/restic-repository"

$env:RESTIC_PASSWORD_FILE = "$env:USERPROFILE\.config\restic\password.txt"
```

*Note: Since Windows uses drive letters, your external drive should match the drive letter. You can also use a script on external drive with relative paths.*

**Do not forget to restart shell to apply variables.**

Add restic configuration:

```shell
# Create a folder
if (!(Test-Path "$env:USERPROFILE\.config\restic")) { New-Item -Path "$env:USERPROFILE\.config\restic" -ItemType Directory -Force }

# Add exclude files
Add-Content -Path "$env:USERPROFILE\.config\restic\iexcludes.txt" -Value "# Excludes"
Add-Content -Path "$env:USERPROFILE\.config\restic\excludes.txt" -Value "# Excludes"
@todo wget excludes

# Set a password without new line
notepad $env:RESTIC_PASSWORD_FILE
```

Initialize Repository:

```shell
restic init
```

Now your repository is ready for creating backup.

Create a backup:

```shell
restic backup --host="my-pc" --tag="optional-tag" `
  --exclude-file=$env:USERPROFILE\.config\restic\excludes.txt `
  --exclude=$env:USERPROFILE/restic-repository `
  C:\Users\User

# or simpler
restic backup --host="$env:COMPUTERNAME" --tag="$env:USERNAME" `
  --exclude-file=$env:USERPROFILE\.config\restic\excludes.txt `
  --exclude=$env:USERPROFILE/restic-repository `
  $env:USERPROFILE
```

Maybe you want add `--iexclude-file=$env:USERPROFILE\.config\restic\iexcludes.txt` too.

List snapshots

```shell
restic snapshots

# Compact view
restic snapshots -c
```

Mount repository:

*Note: Mounting repository in Windows is currently not supported.*

Restore files:

```shell
# Restore all files, by host
restic restore --host="$env:COMPUTERNAME" --target="C:\restic-restore" latest

# Restore all files, by host and path
restic restore --host="$env:COMPUTERNAME" --target="C:\restic-restore" `
  --path="C:\Users\User" latest
```

Forget snapshots:

```bash
# Dry run - Do nothing
restic forget --keep-last 90 --compact --dry-run

# Forget and prune (Delete snapshot)
restic forget --keep-last 90 --compact --prune
```

## Special sftp command

```bash
restic snapshots -o sftp.command="ssh -i /home/cyb10101/.ssh/id_rsa -l cyb10101 192.168.178.21 -s sftp"
```

## Windows Scripts

Windows SSH Copy ID (ssh-copy-id):

```powershell
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh user@192.168.178.21 "cat >> .ssh/authorized_keys"
```

SSH:

```shell
cat %USERPROFILE%\.ssh\config
```

## Differences added and changed files

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
sshfs user@192.168.178.21:/home/user ${DIR_BACKUP_SSH}
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

Maybe remove some snapshots:

```bash
restic snapshots
restic forget
restic prune
```

Update repository from version 1 to 2:

```bash
restic cat config
restic check
restic migrate upgrade_repo_v2
restic prune
restic prune --repack-uncompressed --max-repack-size=200G
```
