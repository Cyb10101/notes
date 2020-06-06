# Samba - Windows sharing

```bash
sudo apt install samba

# Add Samba user
sudo smbpasswd -a cyb10101

# Configure Samba (See below)
sudo vim /etc/samba/smb.conf

sudo systemctl restart smbd
```

## Configure smb.conf

```ini
[Public]
  comment = Cyb10101 Public
  path = /home/cyb10101/Downloads/public
  public = no
  writeable = yes
  guest ok = no
  browseable = yes
  valid users = cyb10101
  create mask = 0664
  directory mask = 0750
  follow symlinks = yes
  wide links = yes
  force user = cyb10101
  force group = cyb10101
```

smb://server/Public
