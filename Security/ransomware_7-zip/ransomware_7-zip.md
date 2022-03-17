# Ransomware 7-Zip

Encrypt and decript 7-Zip files.
Recover lost password with deleted files.

*Keywords: recover, 7z*

## Encrypt and decript

Linux:

```bash
sudo apt update && sudo apt -y install p7zip-full

# Encrypt
find -type f -exec echo -e "\033[0;32m# {}\033[0m" \; -execdir 7z a -bso0 -mx=0 -sdel -pPassword "{}.7z" "{}" \;

# Decrypt
find -type f -iname '*.7z' -exec echo -e "\033[0;32m# {}\033[0m" \; -execdir 7z x -bso1 -pPassword "{}" \; -exec rm "{}" \;
```

Windows encrypt:

```shell
@echo off
for /F "TOKENS=*" %%F IN ('dir /s /b /a-d "folder\*"') DO (
    echo ## Encrypt: %%F
    echo "C:\Program Files\7-Zip\7z.exe" a -mx=0 -sdel "-pPASSWORD" "%%F.7z" "%%F" > nul
    echo.
)
```

Windows decrypt:

```shell
@echo off
for /F "TOKENS=*" %%F IN ('dir /s /b "*.7z"') DO (
    echo ## Decrypt: %%F
    "C:\Program Files\7-Zip\7z.exe" x -pPASSWORD -o"C:%%~pF" "%%F" > nul
    if %errorlevel% equ 0 (
        rem CAREFULL!!!
        echo del "%%F"
    )
    echo.
)
```

## Recover encrypted files

Recover encrypted 7-Zip files with testdisk/photorec.

Install testdisk on Qnap:

```bash
wget --no-check-certificate https://www.cgsecurity.org/testdisk-7.2-WIP.linux26-x86_64.tar.bz2 -O testdisk.tar.bz2
tar xf testdisk.tar.bz2
cd testdisk-7.2-WIP
chmod +x photorec_static
./photorec_static
```

Run `recover_7-zip.sh`.
