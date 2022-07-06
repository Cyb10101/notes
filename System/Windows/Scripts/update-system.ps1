$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

class CybTools {
  [bool] isAdmin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }

  [void] checkAdmin() {
    if (-Not ($this.isAdmin())) {
      Write-Host "You are not an admin. You need a elevated commandshell (cmd/powershell)!"
      sleep 5
      exit
    }
  }
}

$tools = [CybTools]::new()
$tools.checkAdmin()

scoop status
scoop update
scoop update --all
scoop update --all --global

choco outdated
choco upgrade all

start ms-windows-store://updates
control update
sleep 10
