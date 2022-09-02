$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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

# Backup ServerNas
# --no-acls = No permissions (Shows: Warning: Windows Access Control List file not found.)
& "$scriptDir\bin\rdiff-backup\rdiff-backup" -b -v5 --no-acls `
  "C:\media\picture\" "$scriptDir\rdiff-repository\picture\"
