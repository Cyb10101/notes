#Set-Variable -Name "DIR_DOWNLOADS" -Value "$env:userprofile\Desktop\Downloads"
#Set-Variable -Name "DIR_DEPLOY" -Value "$env:userprofile\Desktop\deploy"
#Set-Variable -Name "DIR_TEMP" -Value "$env:userprofile\Temp"
#Start-Process -NoNewWindow -FilePath "explorer.exe "$DIR_DOWNLOADS

. "$env:userprofile\Desktop\deploy\tools.ps1"

$tools.installScoop()
$tools.installChocolatey()

#choco install microsoft-windows-terminal
#scoop install jq --global

#$tools.lazyInstallCache("7-Zip", "https://www.7-zip.org/a/7z1900-x64.exe", "7zip.exe", "/S")
#$tools.lazyInstallCache("Firefox", "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de", "Firefox.exe", "/S")

#$tools.setDevelopment()
if ($development) {
  # Start-Process -FilePath "explorer.exe" -ArgumentList "$($env:localappdata)\Temp"
  Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit Set-Location $($env:userprofile)\Desktop\deploy; . .\tools.ps1"
  #Start-Process -NoNewWindow -FilePath "wt" -ArgumentList "-d $($env:userprofile)\Desktop\deploy"
} else {
  Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit Set-Location $($env:userprofile)\Desktop\Downloads; . $($env:userprofile)\Desktop\deploy\tools.ps1"
  Start-Process -FilePath "cmd.exe" -ArgumentList "/K cd /d $($env:userprofile)\Desktop\Downloads"
  Start-Process -FilePath "explorer.exe" -ArgumentList "$($env:userprofile)\Desktop\Downloads"
  #Start-Process -NoNewWindow -FilePath "wt" -ArgumentList "-d $($env:userprofile)\Desktop\Downloads"
}

exit
# ------------------------------------------------------------------------------
# %LOCALAPPDATA%\Temp
# %USERPROFILE%\Desktop\deploy
