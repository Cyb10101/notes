# Age (File encryption)

The scripts in this folder are meant to make [age](https://github.com/FiloSottile/age/) usable without manually typing recipient keys:

* Recipients are configured in a single `users.json`, read by [jq](https://github.com/jqlang/jq)
* Recipient selection is interactive: [gum](https://github.com/charmbracelet/gum) as primary recipient selector, [fzf](https://github.com/junegunn/fzf) as fallback
* One or more files or folders are always packed into one [zip](https://infozip.sourceforge.net/) archive automatically
* Main workflow is always: Archive first, then encrypt into `bundle_YYYY-MM-DD_XXXX.zip.age`

## 🐧 Setup on Linux/Ubuntu

Install required packages:

```bash
sudo apt install curl age zip unzip jq fzf

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update
sudo apt install gum
```

Create a private key, and don't forget to note your public key:

```bash
mkdir -p ~/.config/age
chmod 700 ~/.config/age
age-keygen >> ~/.config/age/keys.txt
chmod 600 ~/.config/age/keys.txt
```

Create a users.json to store public keys:

```bash
cat <<'EOF' > ~/.config/age/users.json
[
  {"name": "Alice", "key": "age1-alice-public-key", "groups": "family, backup"},
  {"name": "Laptop SSH", "key": "ssh-ed25519 AAAAC3Nz...I1NTE5AAAA", "groups": "devices"},
  {"name": "Your name", "key": "age1-my-public-key", "groups": "own-publc-key"}
]
EOF

gted ~/.config/age/users.json
```

Install scripts:

```bash
url='https://raw.githubusercontent.com/Cyb10101/notes/master/Software/Age_File-encryption'
curl --progress-bar -o /tmp/age-encrypt.sh -fL "$url/age-encrypt.sh"
curl --progress-bar -o /tmp/age-decrypt.sh -fL "$url/age-decrypt.sh"

sudo install /tmp/age-encrypt.sh /usr/local/bin/age-encrypt
sudo install /tmp/age-decrypt.sh /usr/local/bin/age-decrypt
```

Usage:

```bash
age-encrypt secret.txt secret-folder ...
age-decrypt bundle_2026-03-10_abcd.zip.age
```

## 🪟 Setup on Windows

Install required packages:

* [Scoop installation](../../System/Windows/Windows-Installation.md)

```powershell
scoop bucket add extras
scoop install age jq fzf zip unzip charm-gum
```

Create a private key, and don't forget to note your public key:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\age" -Force
age-keygen | Add-Content "$env:USERPROFILE\.config\age\keys.txt"
```

Create a users.json to store public keys:

```powershell
@'
[
  {"name": "Alice", "key": "age1-alice-public-key", "groups": "family, backup"},
  {"name": "Laptop SSH", "key": "ssh-ed25519 AAAAC3Nz...I1NTE5AAAA", "groups": "devices"},
  {"name": "Your name", "key": "age1-my-public-key", "groups": "own-publc-key"}
]
'@ | Set-Content "$env:USERPROFILE\.config\age\users.json"

notepad "$env:USERPROFILE\.config\age\users.json"
```

Install scripts:

```powershell
# Allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

mkdir "$env:USERPROFILE\bin" -Force

$url='https://raw.githubusercontent.com/Cyb10101/notes/master/Software/Age_File-encryption'
iwr "$url/age-encrypt.ps1" -OutFile "$env:USERPROFILE\bin\age-encrypt.ps1"
iwr "$url/age-decrypt.ps1" -OutFile "$env:USERPROFILE\bin\age-decrypt.ps1"

# Add user path for binary/script execution or: Ctrl + R > sysdm.cpl > Advanced > Environmental Variables > Edit PATH (Restart)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\bin", "User")
```

Restart the terminal after updating `PATH`.

Usage:

```powershell
age-encrypt.ps1 secret.txt secret-folder
age-decrypt.ps1 bundle_2026-03-10_abcd.zip.age
```

## Other age examples

Encrypt/decrypt via ssh key:

```bash
curl -s https://github.com/cyb10101.keys | age -R - example.jpg > example.jpg.age

# age-decrypt-ssh <file.age>
age-decrypt-ssh() { age -d -i ~/.config/age/keys.txt -i ~/.ssh/id_rsa -o "${1%.age}" "${1}"; }
```
