# GPG - OpenPGP encryption and signing tool

* [GnuPG](https://gnupg.org/download/)
* [Gpg4win](https://gpg4win.org/download.html)

```bash
sudo apt install gpa gnupg2 xsel
```

```shell
curl -L -o "%LOCALAPPDATA%\Temp\gpg4win.exe" "https://files.gpg4win.org/gpg4win-3.1.14.exe"
# Install with GPA
"%LOCALAPPDATA%\Temp\gpg4win.exe"
del "%LOCALAPPDATA%\Temp\gpg4win.exe"
```

## Create a new GPG key-pair

```bash
gpg --full-generate-key
gpg --gen-key
- Kind of key: 1 RSA & RSA (default)
- Key length: 4096
- Expire: 0 = key does not expire (or 1 - 5 years)

- Real name:
- Email adress:
- Comment:
```

## Export your public key

```bash
gpg --list-keys
gpg --export {username} > key-pub.gpg
gpg --armor --export E0123456 | xsel --clipboard
gpg --armor --output gpg2-key.asc --export E0123456

# Export als ASCII
gpg --armor --export {username} > key-pub-asc.gpg
```

## Import others public key

```bash
xsel --clipboard | gpg --import
gpg --with-fingerprint key-pub.gpg
gpg --import key-pub.gpg

# Check fingerprint
gpg2 --fingerprint 0x012345678901234d5678901234567890123456789

# There is no particular reason that you should trust this key. You can see who has trusted it:
gpg2 --list-sigs 0x012345678901234d5678901234567890123456789

gpg --edit-key {username} trust
# Possibly enter 'save'
```

## Send encrypted message

```bash
## Binary file
gpg --recipient {username} --encrypt secret.txt

## Or ASCII-File
gpg --recipient {username} --armor --encrypt secret.txt
```

## Read the encrypted message

```bash
gpg --decrypt file.txt.gpg > file.txt
```

# Verify Signed Message

```bash
xsel --clipboard | gpg --verify -a | xsel --clipboard
```

## Symmetric (Encrypt & Decrypt)

```bash
# Encrypt
gpg -c --cipher-algo aes256 --digest-algo SHA512 secret.txt
gpg -c --cipher-algo TWOFISH --digest-algo SHA512 secret.txt

# Decrypt
gpg --output secret.txt -d secure.txt.gpg
```

## Chat

```bash
# Sender: Encrypt and send chat
netcat -l -p 7779 | gpg --decrypt

# Receiver: Receive and decrypt chat
gpg -e -r test1@example.org | netcat 127.0.0.1 7779
```

## GPA - Graphical frontend for the GNU Privacy Guard

```bash
sudo gpa
```

* Public Key: Keys > Export Keys
* Backup Private key: Keys > Backup
