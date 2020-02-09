# GPG - OpenPGP encryption and signing tool

```bash
sudo apt install gpa gnupg2
```

## Create a new GPG key-pair

```bash
gpg --full-generate-key
gpg --gen-key
- Kind of key: 1 RSA & RSA (default)
- Key length: 4096
- Expire: 0 = key does not expire

- Real name:
- Email adress:
- Comment:
```

## Export your public key

```bash
gpg --list-keys
gpg --export {username} > key-pub.gpg

#### Export als ASCII
gpg --armor --export {username} > key-pub-asc.gpg
```

## Import others public key

```bash
gpg --with-fingerprint key-pub.gpg
gpg --import key-pub.gpg
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

## Symmetric (Encrypt & Decrypt)

```bash
# Encrypt
gpg -c --cipher-algo aes256 --digest-algo SHA512 secret.txt
gpg -c --cipher-algo TWOFISH --digest-algo SHA512 secret.txt

# Decrypt
gpg --output secret.txt -d secure.txt.gpg
```

## GPA - Graphical frontend for the GNU Privacy Guard

```bash
sudo gpa
```

* Public Key: Keys > Export Keys
* Backup Private key: Keys > Backup
