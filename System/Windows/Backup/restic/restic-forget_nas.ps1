$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-Variable -Name "RESTIC_REPOSITORY" -Value "$scriptDir\restic-repository"
Set-Variable -Name "RESTIC_PASSWORD_FILE" -Value "$scriptDir\password.txt"

# Backup ServerNas
& "$scriptDir\bin\restic" forget -r "$RESTIC_REPOSITORY" -p "$RESTIC_PASSWORD_FILE" --keep-last 10

Clear-Variable -Name "RESTIC_REPOSITORY"
Clear-Variable -Name "RESTIC_PASSWORD_FILE"
