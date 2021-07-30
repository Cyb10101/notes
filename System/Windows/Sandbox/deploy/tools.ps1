# Allow execution of unsigned scripts (Scoop script is not signed)
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Confirm:$False -Force

# . "$($env:userprofile)\Sync\notes\System\Windows\Sandbox\deploy\tools.ps1"
# $tools.packageManagerList()
# $tools.packageManagerUpgrade()

# Don't need this
# $tools.addScoop("croc")
# $tools.addScoop("restic")
# $tools.installScoopPackages()

class CybTools {
  [String]$dirDeploy = "$env:userprofile\Desktop\deploy"
  [System.Collections.ArrayList]$packagesScoop = @()

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

  [void] setDevelopment() {
    Set-Variable -Name "development" -Value "$true"
  }

  [bool] commandExists($command) {
    return (Get-Command $command -ErrorAction "SilentlyContinue")
  }

  [bool] fileExists($file) {
    return (Test-Path "$file" -PathType leaf)
  }

  [void] installScoop() {
    if (-Not ($this.commandExists("scoop"))) {
      Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
      scoop install aria2 7zip git sudo --global
      scoop bucket add extras
    }
  }

  [void] installChocolatey() {
    if (-Not ($this.commandExists("choco"))) {
      Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      choco feature enable -n allowGlobalConfirmation
    }
  }

  [void]addScoop([string]$package) {
    $package = $package.Trim()
    if (-Not($this.packagesScoop.Contains($package))) {
      $this.packagesScoop.Add($package)
    }
  }

  [void]removeScoop([string]$package) {
    $package = $package.Trim()
    if ($this.packagesScoop.Contains($package)) {
      $this.packagesScoop.Remove($package)
    }
  }

  [void]installScoopPackages() {
    if ($this.packagesScoop.Count -gt 0) {
      scoop install $this.packagesScoop.Split(" ") --global
      $this.packagesScoop = @()
    } else {
      Write-Host "Error: Packages not set!"
    }
  }

  [void] packageManagerList() {
    if ($this.commandExists("scoop")) {
      Write-Host "Scoop Packages:"
      scoop list
    }
    if ($this.commandExists("choco")) {
      Write-Host "Chocolatey Packages:"
      # @todo don't show anything?!
      choco list --localonly
    }
    Write-Host "Done"
  }

  [void] packageManagerUpgrade() {
    if ($this.commandExists("scoop")) {
      Write-Host "Upgrading Scoop:"
      scoop update
      scoop update *
    }
    if ($this.commandExists("choco")) {
      Write-Host "Upgrading Chocolatey:"
      # @todo don't show anything?!
      choco upgrade all
    }
    Write-Host "Done"
  }

  [void] lazyInstall($title, $url, $tempFilename, $parameter) {
    Write-Host "Download: $title"
    if ($this.commandExists("aria2c")) {
      aria2c --download-result=hide --dir="$env:localappdata\Temp\" -o "$tempFilename" "$url"
    } else {
      Invoke-WebRequest -Uri "$url" -OutFile "$env:localappdata\Temp\$tempFilename"
    }

    Write-Host "Install: $title"
    Write-Host "-> Close installer or program after setup to continue!"
    if ([string]::IsNullOrWhiteSpace($parameter) -eq $false) {
      Start-Process -NoNewWindow -Wait -FilePath "$env:localappdata\Temp\$tempFilename" -ArgumentList "$parameter"
    } else {
      Start-Process -NoNewWindow -Wait -FilePath "$env:localappdata\Temp\$tempFilename"
    }

    if ($this.fileExists("$env:localappdata\Temp\$tempFilename")) {
      Remove-Item "$env:localappdata\Temp\$tempFilename"
    }

    Write-Host "Done: $title"
  }

  [void] lazyInstallCache($title, $url, $tempFilename, $parameter) {
    if (-Not(Test-Path "$($this.dirDeploy)")) {
      New-Item -ItemType "directory" -Path "$($this.dirDeploy)"
    }

    if (-Not($this.fileExists("$($this.dirDeploy)\$tempFilename"))) {
      Write-Host "Download: $title"
      if ($this.commandExists("aria2c")) {
        aria2c --download-result=hide --dir="$($this.dirDeploy)\" -o "$tempFilename" "$url"
      } else {
        Invoke-WebRequest -Uri "$url" -OutFile "$($this.dirDeploy)\$tempFilename"
      }
    }

    Write-Host "Install: $title"
    Write-Host "-> Close installer or program after setup to continue!"
    if ([string]::IsNullOrWhiteSpace($parameter) -eq $false) {
      Start-Process -NoNewWindow -Wait -FilePath "$($this.dirDeploy)\$tempFilename" -ArgumentList "$parameter"
    } else {
      Start-Process -NoNewWindow -Wait -FilePath "$($this.dirDeploy)\$tempFilename"
    }

    Write-Host "Done: $title"
  }
}

$tools = [CybTools]::new()
$tools.checkAdmin()
