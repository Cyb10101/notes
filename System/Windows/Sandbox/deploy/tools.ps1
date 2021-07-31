# Allow execution of unsigned scripts (Scoop script is not signed)
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Confirm:$False -Force

# . "$($env:userprofile)\Sync\notes\System\Windows\Sandbox\deploy\tools.ps1"
# . "$($env:userprofile)\Desktop\deploy\tools.ps1"
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

  [int] getOsArchitecture() {
    return (32, 64)[[Environment]::Is64BitOperatingSystem]
  }

  # Add:    updateEnvironmentVariable -path "$env:homedrive$env:homepath\opt\tools\croc" -global
  # Remove: updateEnvironmentVariable -path "$env:homedrive$env:homepath\opt\tools\croc" -global -remove
  [void] updateEnvironmentVariable([string]$path, [switch]$global, [switch]$remove) {
    if ($global) {
      $target = [System.EnvironmentVariableTarget]::Machine
    } else {
      $target = [System.EnvironmentVariableTarget]::User
    }

    $value = ([Environment]::GetEnvironmentVariable("Path", "$($target)"))
    $valueCleaned = ((($value).split(";") | Where-Object { $_ -ne "$($path)" }) -join ";")
    if (-Not ($remove)) {
        $valueCleaned = "$($valueCleaned);$($path)"
    }
    [Environment]::SetEnvironmentVariable("Path", "$($valueCleaned)", "$($target)")
    [Environment]::GetEnvironmentVariable("Path", "$($target)") | Format-Table -AutoSize
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

  [array] getGithubRelease([string]$repository) {
    return (Invoke-RestMethod "https://api.github.com/repos/$($repository)/releases/latest" | Select-Object -Property tag_name, name, assets)[0]
  }

  [array] getGithubReleaseFile([array]$release, [string]$expr) {
    return ($release.assets | Select-Object -Property name, content_type, browser_download_url | Where-Object {$_.name -Match "$($expr)"})[0]
  }

  [string] getVersionByGitTag([string]$value) {
    if ($value -match "v(\d\.\d\.\d)$") {
      return $matches[1]
    }
    return "0.0.0"
  }

  [string] getVersionByFile([string]$executable, [string]$args, [string]$expr) {
    if (-Not(Test-Path "$($executable)" -PathType leaf)) {
        return "0.0.0"
    }

    $version = (Invoke-Expression "$($executable) $($args)")
    if ($version -match "$($expr)") {
      return $matches[1]
    }
    return "0.0.0"
  }

  [void] installZip([string]$title, [string]$url, [string]$tmpFileName, [string]$path) {
    Write-Output "Download: $title"
    Invoke-WebRequest -Uri "$($url)" -OutFile "$env:localappdata\Temp\$($tmpFileName)"

    Write-Output "Remove old files..."
    if (Test-Path -Path "$($path)") {
        Remove-Item "$($path)" -Recurse -Force
    }

    Write-Output "Extract new files..."
    Expand-Archive -Path "$env:localappdata\Temp\$($tmpFileName)" -DestinationPath "$($path)"

    Remove-Item "$env:localappdata\Temp\$($tmpFileName)"
    Write-Output "Done: $title"
  }

  ################################################################################
  # Install Scripts

  [void] installCroc() {
      $installPath = "$env:homedrive$env:homepath\opt\tools\croc"

      $release = $this.getGithubRelease("schollz/croc")
      $releaseFile = $this.getGithubReleaseFile($release, "^.*Windows-$($this.getOsArchitecture())bit\.zip$")

      $tmpFile = "$env:localappdata\Temp\$($releaseFile.name)"
      $releaseVersion = $this.getVersionByGitTag($release.tag_name)
      $currentVersion = $this.getVersionByFile("$($installPath)\croc.exe", "-v", "croc version v(\d\.\d\.\d)-.*")
      if ([version]$releaseVersion -gt [version]$currentVersion) {
          Write-Host "Installing/Updating Croc! [$($currentVersion) -> $($releaseVersion)]"
          $this.installZip("Croc", "$($releaseFile.browser_download_url)", "$($releaseFile.name)", "$($installPath)")
          $this.updateEnvironmentVariable("$($installPath)", $True, $False)
      } else {
          Write-Host "No new release. [$($currentVersion)]"
      }
  }

  # Just for information, require jq
  [string] getGitlabReleaseUrl([string]$domain, [string]$repository, [string]$exprName) {
    $releases = ((New-Object System.Net.WebClient).DownloadString("https://$($domain)/api/v4/projects/$($repository)/releases"))
    $url = $releases | jq -r --arg exprName ${exprName} '.[0].assets.sources[] | select(.url | test(\"\($exprName)\")) | .url'
    return $url
  }

  # Just for information, require jq
  [void] installLinphone() {
    return;
    $installPath = "$env:homedrive$env:homepath\opt\tools\linphone"

    $url = $this.getGitlabReleaseUrl("gitlab.linphone.org", "BC%2Fpublic%2Flinphone-desktop", "^.*linphone-desktop-\d\.\d\.\d\.zip$")

    $releaseFileName = "linphone.zip"
    $tmpFile = "$env:localappdata\Temp\$($releaseFileName)"
    $this.installZip("Linphone", "$($url)", "$($releaseFileName)", "$($installPath)")
  }
}

$tools = [CybTools]::new()
$tools.checkAdmin()
