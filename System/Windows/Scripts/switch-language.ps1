<# Some code not working on a Windows machine previous as Windows 10/11 (22H2)
You need to install language manually and seperate the language switch into multiple files

Administrator privileges only needed for install a new language

Not Working: Version 10.0.19043.928  (Windows 10 21H1)
Not Working: Version 10.0.22000.318  (Windows 11 21H2)
Working:     Version 10.0.19045.2604 (Windows 10 22H2)
Working:     Version 10.0.22621.525  (Windows 11 22H2)

Command script:
@echo off
powershell -ExecutionPolicy Unrestricted -NoExit -File ".\switch-language.ps1"
pause
#>

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

    [void] installLanguage([string]$language, [string]$code) {
        if (-Not (Get-InstalledLanguage -language $code)) {
            $this.checkAdmin()
            Write-Host "Install $language language..."
            Install-Language $code
        }
    }

    [void] setWinSystemLocale([string]$language, [string]$code) {
        Write-Host "Set language to $language..."
        Set-WinSystemLocale $code
    }

    [void] logoff([int]$seconds) {
        Write-Host "Logoff in $seconds seconds..."
        Sleep $seconds
        logoff
    }

    [void] restartSystem([int]$seconds) {
        shutdown /r /t $seconds /c "Restart in $seconds seconds..."
    }

    [void] switchLanguageToGerman() {
        $this.setWinSystemLocale("German", "de-DE")

        $userLanguageList = New-WinUserLanguageList -Language "de-DE"
        Set-WinUserLanguageList -LanguageList $userLanguageList -Force

        $this.logoff(10)
        #$this.restartSystem(10)
    }

    [void] switchLanguageToTurkish() {
        $this.setWinSystemLocale("Turkish", "tr-TR")

        $userLanguageList = New-WinUserLanguageList -Language "tr-TR"
        $userLanguageList.Add("de-DE")
        $userLanguageList[0].InputMethodTips.Clear()
        $userLanguageList[0].InputMethodTips.Add("0407:00000407")
        Set-WinUserLanguageList -LanguageList $userLanguageList -Force

        $this.logoff(10)
        #$this.restartSystem(10)
    }

    [void] switchLanguage() {
        if ((Get-WinUserLanguageList)[0].LanguageTag -eq "de-DE") {
            if (Get-InstalledLanguage -language tr-TR) {
                $this.switchLanguageToTurkish()
            } else {
                Write-Host "Can not set language to Turkish!"
                Sleep 10
            }
        } else {
            if (Get-InstalledLanguage -language de-DE) {
                $this.switchLanguageToGerman()
            } else {
                Write-Host "Can not set language to German!"
                Sleep 10
            }
        }
    }

    [void] switchLanguageOld() {
        if ((Get-WinUserLanguageList)[0].LanguageTag -eq "de-DE") {
            $this.switchLanguageToTurkish()
        } else {
            $this.switchLanguageToGerman()
        }
    }
}

$app = [App]::new()

# Install-Language not working in previous Windows version
$app.installLanguage("Turkish", "tr-TR")

# Get-InstalledLanguage not working in previous Windows version, use $app.switchLanguageOld()
$app.switchLanguage()
#$app.switchLanguageOld()
