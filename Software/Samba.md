# Samba - Windows sharing

## Create a network share on Windows

### Add a user

For more security you can optionally create another user.

Run Powershell as Administrator:

```shell
# Create a user (just for security)
net user "username-share" "password" /add

# Get your ip address
ipconfig

# Optional information
# net user "username-share" "change-password"
# net user "username-share" /delete
```

### Configure network profile type

Set network profile type or permissions to share files on the network:

* Settings > Network & Internet > Advanced network settings > Advanced sharing settings (German: Einstellungen > Netzwerk und Internet > Erweiterte Netzwerkeinstellungen > Erweiterte Freigabeeinstellungen)
  * Choose one or both "private or public networks"
    * File and printer sharing = true

### Create a user share

* Create a folder "Share" on Desktop or elsewere
* Right click > Properties > Tab "Sharing"
  * Field "Network file and Folder Sharing" > Button "Share"
    * Select or add a user (username-share, current user, everyone)
    * Allow User: Read/Write
    * Click on "Share" and "Done"

Paths to connect:

* Windows: `\\192.168.178.21\Users\User\Desktop\Share`
* Linux: `smb://192.168.178.21/Users/User/Desktop/Share`

### Create a global share

* Create a folder "Share" on Desktop or elsewere
* Right click > Properties > Tab "Sharing"
  * Field "Advanced Sharing" > Button "Advanced Sharing"
    * Share this folder = yes
    * Share name = username-share
    * Permissions
      * Select or add a user (username-share, current user, everyone)
        * If add, dont forget "Check Name"
      * Permissions = Allow "Full Control"

Paths to connect:

* Windows: `\\192.168.178.21\username-share`
* Linux: `smb://192.168.178.21/username-share`

## Create a network share on Linux

```bash
# Install Samba
sudo apt -y install samba cifs-utils

# Add Samba user
sudo smbpasswd -a $USER

# Optional Nautilus share
sudo apt -y install nautilus-share
sudo usermod -aG sambashare $USER
sudo reboot
```

More commands as infomation:

```bash
# List SAM database users (Database of Samba Users)
sudo pdbedit -L
sudo pdbedit -L -v

# Change password
sudo smbpasswd $USER
```

Create a directory and share it with nautilus or manually with:

```bash
# Create a share directory
mkdir ~/username-share

# Configure Samba (See below)
sudo vim /etc/samba/smb.conf

sudo systemctl restart smbd && sudo systemctl restart smb
```

Configure `smb.conf`:

```ini
[username-share]
comment = Username Share
path = /home/user/username-share
public = no
writeable = yes
guest ok = no
browseable = yes
# valid users is linux username
valid users = username-share
create mask = 0664
directory mask = 0750
follow symlinks = yes
wide links = yes
force user = linux-user
force group = linux-user
```

Paths to connect:

* Windows: `\\192.168.178.21\username-share`
* Linux: `smb://192.168.178.21/username-share`

## Connect share via Windows:

Open file manager with path: `\\192.168.178.21\username-share`

Open file manager on "This PC".
* Rightclick > Add a network location
* Internet or network address: \\192.168.178.199\username-transfer
* Name: username-transfer


## Connect share via Linux:

Simply with Nautilus, mount command or fstab.

Nautilus path: `smb://192.168.178.21/username-share`

For mount/fstab, optionally add credentials in a file:

```bash
sudo touch ~/.smbcredentials
sudo chmod 600 ~/.smbcredentials
sudo vim ~/.smbcredentials

# Add the following lines
username=username-share
password=password-share
```

Mount command:

```bash
# Samba share with username and password
sudo mount -t cifs -o "username=username-share,password=password-share,uid=$USER" //192.168.178.21/username-share /mnt

# Samba share with credentials file
sudo mount -t cifs -o "credentials=/home/$USER/.smbcredentials,uid=$USER" //192.168.178.21/username-share /mnt
```

For Fstab, edit `/etc/fstab` file:

```bash
# Samba share with username and password
//192.168.178.21/username-share /media/username-share cifs username=username-share,password=password-share,uid=linux-user,noauto,user 0 0

# Samba share with credentials file
//192.168.178.21/username-share /media/username-share cifs credentials=/home/user/.smbcredentials,uid=linux-user,noauto,user 0 0

# Reload daemon and mount
# sudo systemctl daemon-reload && sudo mount -a

# Notes
# noauto = Not automatically mounted at boot
# user = Allows a normal user to mount the share
```

## Connect share via iPhone:

* Open "Files" > Click on three dots > Connect to Server
  * Server: 192.168.178.21 (Alternatively: smb://192.168.178.21)
  * Click on "Connect"
  * Click on "Registered User", enter your username "username-share" and your password
  * Click on "Next"

* Open "Album"
  * Share > Save to files
  * Select Server and folder "username-share"
