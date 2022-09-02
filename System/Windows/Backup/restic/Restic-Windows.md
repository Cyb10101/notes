# Restic Backup

## Initialize repository

```powershell
# Create password
New-Item -Path ".\" -Name "password.txt" -ItemType "file" -Value "123456"

# Initialize repository
& .\bin\restic init -r "restic-repository" -p "password.txt"
```

## Restore backup

```powershell
& .\bin\restic restore -r "restic-repository" -p "password.txt" -H "my-pc" `
  --target C:\restic-restore latest
```
