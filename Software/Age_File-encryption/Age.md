# Age (File encryption)

* [Age: Github](https://github.com/FiloSottile/age/)
* Other binaries for scripts
  * [jq](https://github.com/jqlang/jq)
  * [fzf](https://github.com/junegunn/fzf)

## Installation

Ubuntu:

```bash
sudo apt install age
```

Scoop (Windows):

* [Scoop installation](../../System/Windows/Windows-Installation.md)

```powershell
scoop bucket add extras
scoop install age
scoop install age fzf jq
```

## Quick and dirty

```bash
# Generate a key
age-keygen -o keys.txt

# Encrypt
age -e -r age1publicKey -o example.txt.age example.txt

# Encrypt with recipients-file
age -e -R user-or-group-name.txt -o example.txt.age example.txt

# Decrypt
age -d -i keys.txt -o example.txt.age example.txt
```

## 🔑 Install and generate key

Linux:

```bash
# Preparing the key store
mkdir -p ~/.config/age
touch ~/.config/age/keys.txt
echo '[{"name": "Name", "key": "age1key", "groups": "family, friends"}]' > ~/.config/age/users.json
chmod 700 ~/.config/age
chmod 600 ~/.config/age/{keys.txt,users.json}

# Generate key
age-keygen >> ~/.config/age/keys.txt
```

Windows Powershell as User:

```powershell
# Preparing the key store
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\age"

# Generate key
age-keygen | Add-Content "$env:USERPROFILE\.config\age\keys.txt"

# User config
'[{"name": "Name", "key": "age1key", "groups": "family, friends"}]' | Set-Content -Encoding UTF8 "$env:USERPROFILE\.config\age\users.json"

notepad "$env:USERPROFILE\.config\age\users.json"
```

## 📦 Usage

```bash
# Encrypt
tar cvz ~/data | age -r age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p > data.tar.gz.age

# Decrypt
age --decrypt -i key.txt data.tar.gz.age > data.tar.gz

# Encrypt via ssh key
curl -s https://github.com/cyb10101.keys | age -R - example.jpg > example.jpg.age

# Decrypt with keys & ssh key: age-decrypt <file>
age-decrypt() { age -d -i ~/.config/age/keys.txt -i ~/.ssh/id_rsa -o "${1%.age}" "${1}"; }
```

## 🐧 Linux scripts

Install both script:

```bash
sudo apt install jq fzf
sudo install age-encrypt.sh /usr/local/bin/age-encrypt
sudo install age-decrypt.sh /usr/local/bin/age-decrypt
```

Add users in `~/.config/age/users.json`:

```json
[
  {"name": "Alice", "key": "age1alice", "groups": "family, friends"},
  {"name": "Bob", "key": "age1bob", "groups": "family"}
]
```

Usage:

```bash
age-decrypt.sh <file/folder>...
age-encrypt.sh <file>...
```

## 🪟 Windows scripts

Install both script:

```bash
scoop install jq fzf

mkdir "$env:USERPROFILE\bin"
Copy-Item -Path "age-encrypt.ps1" -Destination "$env:USERPROFILE\bin" -Force
Copy-Item -Path "age-decrypt.ps1" -Destination "$env:USERPROFILE\bin" -Force
Copy-Item -Path "age-encrypt.cmd" -Destination "$env:USERPROFILE\bin" -Force
Copy-Item -Path "age-decrypt.cmd" -Destination "$env:USERPROFILE\bin" -Force

Ctrl + R > sysdm.cpl > Advanced > Environmental Variables > Edit PATH (Restart)
```

Add users in `~\.config\age\users.json`:

```json
[
  {"name": "Alice", "key": "age1alice", "groups": "family, friends"},
  {"name": "Bob", "key": "age1bob", "groups": "family"}
]
```

Usage:

```shell
# Decrypt
age-decrypt.ps1 <file/folder>...
age-decrypt.cmd <file/folder>...

# Encrypt
age-encrypt.ps1 <file>...
age-encrypt.cmd <file>...
```
