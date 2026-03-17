# Shared Folder

Create a shared folder for a group like family on local system.

You need two steps: "Create family folder" and add a "File watcher".

## Create family folder

Create a shared group and add it to users:

```bash
sudo groupadd family
sudo usermod -aG family user1
sudo usermod -aG family user2
```

Add a shared folder:

```bash
sudo mkdir /home/shared-family
sudo chgrp family /home/shared-family
sudo chmod 2770 /home/shared-family
```

Permission description:

All group users can add and delete files, can read, ...

* `chmod 0770 *`: ... but not write to each others files
* `chmod 1770 *`: Same as above, but only the owner of the file can delete it (Sticky bit)
* `chmod 2770 *`: ... write to each other's files (Setgid bit)
* `chmod 3770 *`: Same as above, but only the owner of the file can delete it (Sticky and Setgid bit)


### File watcher

You need to add a systemd script to watch file creation and moving to set permissions automatically.

Install inotify and create shared-family-watcher.sh:

```bash
sudo apt install inotify-tools
sudo nano /usr/local/bin/shared-family-watcher.sh
```

Contents of shared-family-watcher.sh:

```bash
#!/usr/bin/env bash
set -u

FOLDER="/home/shared-family"
GROUP="family"

CHMOD_FOLDER='g+rws' # Optional deny others: g+rws,o-rwx
CHMOD_FILE='g+rw'    # Optional deny others: g+rw,o-rwx

fix_path() {
  local path="$1"
  [ -e "$path" ] || return 0

  if [ -d "$path" ]; then
    echo "Fixing directory tree $path"
    chgrp -R "$GROUP" "$path"
    chmod "$CHMOD_FOLDER" "$path"
    find "$path" -type d -exec chmod "$CHMOD_FOLDER" {} +
    find "$path" -type f -exec chmod "$CHMOD_FILE" {} +
  elif [ -f "$path" ]; then
    echo "Fixing file $path"
    chgrp "$GROUP" "$path"
    chmod "$CHMOD_FILE" "$path"
  else
    echo "Skipping unsupported path type $path"
  fi
}

inotifywait -m -r -e create -e moved_to --format '%w%f' "$FOLDER" | while read -r FILE; do
  fix_path "$FILE"
done
```

Make it executable and create shared-family-watcher.service:

```bash
sudo chmod +x /usr/local/bin/shared-family-watcher.sh
sudo nano /etc/systemd/system/shared-family-watcher.service
```

Contents of shared-family-watcher.service:

```conf
[Unit]
Description=Fix permissions in family share
After=local-fs.target
Requires=local-fs.target

[Service]
Type=simple
ExecStart=/usr/local/bin/shared-family-watcher.sh
Restart=always
RestartSec=2
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Reload daemon, run service and reboot system:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now shared-family-watcher.service
systemctl status --no-pager shared-family-watcher.service

reboot
```
