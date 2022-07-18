# Crack Archive

## Crack rar

Crack *.rar archives.

```bash
/usr/sbin/rar2john archive.rar > hash.txt
john --format=rar hash.txt

# john --wordlist=/usr/share/wordlists/rockyou.txt --format=rar hash.txt
# john --wordlist=/usr/share/john/password.lst --format=rar hash.txt
john --show hash.txt
```

## Crack 7zip

```bash
sudo apt install libcompress-raw-lzma-perl -y
/usr/share/john/7z2john.pl backup.7z > hash.txt

john --format=7z hash.txt
# john --wordlist=/usr/share/wordlists/rockyou.txt --format=7z hash.txt
# john --wordlist=/usr/share/john/password.lst --format=7z hash.txt
john --show hash.txt
```
