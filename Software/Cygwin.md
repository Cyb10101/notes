# Cygwin

Download: [Cygwin](https://cygwin.com/install.html)

## Install

* Minimal Packages: git,openssh,rsync,vim
* C & C++: make,gcc-g++,mingw64-x86_64-gcc-core,mingw64-x86_64-gcc-g++

Open PowerShell as User:

```bash
mkdir C:\opt

# Disable progressbar for faster downloading (PS < 7.2) ( https://github.com/PowerShell/PowerShell/issues/2138 )
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest https://cygwin.com/setup-x86_64.exe -OutFile "$env:HOMEDRIVE\opt\cygwin-setup.exe"

& $env:HOMEDRIVE\opt\cygwin-setup.exe --root="$env:HOMEDRIVE\opt\cygwin64" `
  --local-package-dir="$env:HOMEDRIVE\opt\Cygwin-Setup" `
  --site="http://ftp-stud.hs-esslingen.de/pub/Mirrors/sources.redhat.com/cygwin/" `
  --packages="git,openssh,rsync,vim,ncdu,unzip"
```

Configure Cygwin Terminal:

* Text > Lucidia Console 11px
* Text > DejaVu Sans Mono 11px

Configure Git:

```bash
git config --global core.editor "C:/opt/cygwin64/bin/vim.exe"
```

Windows drives are here:

```bash
cd /cygdrive/
```

### Cygwin - Open Git commit in Notepad++

```bash
git config --global core.editor "/usr/local/bin/edit"

vim /usr/local/bin/edit
chmod +x /usr/local/bin/edit
```

Script: /usr/local/bin/edit

```bash
#!/usr/bin/env bash
'/cygdrive/c/Program Files/Notepad++/notepad++.exe' $(cygpath --windows "${1}")
```

## SSH-Key für Cygwin generieren

```bash
ssh-keygen -t rsa -b 4096 -C 'user@example.org'
ssh-copy-id -i ~/.ssh/id_rsa.pub user@localhost
mkdir ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 640 ~/.ssh/id_rsa.pub
```

## Automatisch direkt zur VM verbinden

```bash
echo 'Connect to VM'
ssh user@localhost

VM_IP=192.168.56.101
if ping -n 1 -w 1000 "$VM_IP" 2>&1 >/dev/null; then
  ssh user@${VM_IP}
  sleep 1
  echo 'Exit in 1 seconds'
  exit
else
  echo "${VM_IP} not found"
fi
```

## Compile C & C++ for Windows

```bash
x86_64-w64-mingw32-gcc -static -o script.exe script.c
x86_64-w64-mingw32-g++ -static -o script.exe script.cpp
```
