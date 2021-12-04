$scriptPath = "$($PSScriptRoot)"

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

  [void] build([string]$architecture, [string]$scriptPath) {
    Write-Host "Build Windows PE $($architecture)..."

    # Do not call WinPeMainDirectory -> WinPeRoot
    $WinPeMainDirectory = "C:\WinPE"
    $WinPeBuild = "$($WinPeMainDirectory)\$($architecture)"
    $WinPeMount = "$($WinPeBuild)\mount"

    $WinPeLanguage = 'de-de'
    $WinPeKit = 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit'

    #$windowsOptionalComponentsPath
    $WinPeKitOCs = "$($WinPeKit)\Windows Preinstallation Environment\$($architecture)\WinPE_OCs"

    #rem Calling a script which sets some useful variables 
    #echo "%WinPeKit%\Deployment Tools\DandISetEnv.bat"
    #rem call "%WinPeKit%\Deployment Tools\DandISetEnv.bat"
    #& "$($WinPeKit)\Deployment Tools\DandISetEnv.bat"
    #cd "$($scriptPath)"

    if (Test-Path "$($WinPeMount)\Windows") {
        Write-Host 'Discarding and unmounting the existing Windows PE image...'
        Dismount-WindowsImage -Path "$($WinPeMount)" -Discard
    }

    if (Test-Path "$($WinPeBuild)") {
        Write-Host "Remove old build"
        Remove-Item -Recurse $WinPeBuild
    }

    & "$($WinPeKit)\Windows Preinstallation Environment\copype.cmd" $($architecture) "$($WinPeBuild)" | Out-Null
    & copype.cmd $($architecture) "$($WinPeBuild)" | Out-Null
    if (Test-Path "$($WinPeBuild)") {
        Write-Host 'Mounting the Windows PE image...'
        Mount-WindowsImage `
            -ImagePath "$($WinPeBuild)\media\sources\boot.wim" `
            -Index 1 -Path "$($WinPeMount)" | Out-Null

        if (Test-Path "$($WinPeMount)") {
            # Language
            Add-WindowsPackage `
                -Path "$($WinPeMount)" `
                -PackagePath "$($WinPeKitOCs)\$($WinPeLanguage)\lp.cab" `
                | Out-Null

            # Standard & DE
            @(
                'WinPE-HTA'
                'WinPE-WMI'
                'WinPE-StorageWMI'
                'WinPE-Scripting'
                'WinPE-NetFx'
                'WinPE-PowerShell'
                'WinPE-DismCmdlets'
                'WinPE-EnhancedStorage'
                'WinPE-SecureStartup'
            ) | ForEach-Object {
                Write-Host "Adding the $($_) Windows Package..."
                Add-WindowsPackage -Path "$($WinPeMount)" `
                    -PackagePath "$($WinPeKitOCs)\$($_).cab" | Out-Null
                Add-WindowsPackage -Path "$($WinPeMount)" `
                    -PackagePath "$($WinPeKitOCs)\$($WinPeLanguage)\$($_)_$($WinPeLanguage).cab" | Out-Null
            }

            # Standard
            @(
                'WinPE-FMAPI'
                'WinPE-SecureBootCmdlets'
            ) | ForEach-Object {
                Write-Host "Adding the $($_) Windows Package..."
                Add-WindowsPackage -Path "$($WinPeMount)" `
                    -PackagePath "$($WinPeKitOCs)\$($_).cab" | Out-Null
            }

            # Adding drivers
            # Dism /image:%WinPeBuild%\mount /Add-Driver /driver:%drivers_path% /recurse

            Write-Host "Fix background image permisions..."
            & takeown /F "$($WinPeMount)\Windows\System32\winpe.jpg"
            & icacls "$($WinPeMount)\Windows\System32\winpe.jpg" /grant "$($env:username):F"

            Write-Host "Copying root to build directory..."
            & xcopy "$($scriptPath)\root\" "$($WinPeMount)\" /r /s /e /i /y

            Write-Host "Set region language..."
            & Dism /Set-AllIntl:de-DE /Image:"$($WinPeMount)"

            # List of available timezones: http://technet.microsoft.com/en-US/library/cc749073(v=ws.10).aspx
            Write-Host "Setting the timezone..."
            & Dism /Image:"$($WinPeMount)" /Set-TimeZone:"W. Europe Standard Time"

            Write-Host 'Cleaning up the image...'
            & dism /Quiet /Cleanup-Image /Image:"$($WinPeMount)" /StartComponentCleanup /ResetBase
            if ($LASTEXITCODE) {
                throw "Failed with Exit Code $LASTEXITCODE"
            }

            Write-Host 'Saving and unmounting the Windows PE image...'
            Dismount-WindowsImage -Path "$($WinPeMount)" -Save

            Write-Host 'Creating ISO image from WinPE...'
            & Makewinpemedia /iso /f "$($WinPeBuild)" "$($WinPeMainDirectory)\WinPE_$($architecture).iso"
            Write-Host ''
        } else {
            throw "Failed Mounting the Windows PE image"
        }
    } else {
        throw "Failed copy Windows PE data"
    }
  }
}

$tools = [CybTools]::new()
$tools.checkAdmin()
$tools.build('amd64', $scriptPath)
$tools.build('x86', $scriptPath)
