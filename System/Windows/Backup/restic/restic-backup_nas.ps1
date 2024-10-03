$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

class App {
  [bool] isAdmin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }

  [void] checkAdmin() {
    if (-Not ($this.isAdmin())) {
      Write-Host "You are not an admin. You need a elevated commandshell (cmd/powershell)!"
      exit
    }
  }
}

$app = [App]::new()
# $app.checkAdmin()

Set-Variable -Name "RESTIC_REPOSITORY" -Value "$scriptPath\restic-repository"
Set-Variable -Name "RESTIC_PASSWORD_FILE" -Value "$scriptPath\password.txt"

# Backup ServerNas
& "$scriptPath\bin\restic" backup -r "$RESTIC_REPOSITORY" -p "$RESTIC_PASSWORD_FILE" `
  --host='my-pc' --tag='my-pc' `
  C:\media\picture

Clear-Variable -Name "RESTIC_REPOSITORY"
Clear-Variable -Name "RESTIC_PASSWORD_FILE"
