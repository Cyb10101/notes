Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit Set-Location $($env:systemdrive)\opt;"
Start-Process -FilePath "cmd.exe" -ArgumentList "/K cd /d $($env:systemdrive)\opt"
#Start-Process -FilePath "explorer.exe" -ArgumentList "$($env:systemdrive)\opt"

if ("$($env:processor_architecture)" -eq "AMD64") {
    Start-Process -FilePath "$($env:systemdrive)\opt\HWiNFO64.exe"
    #& $($env:systemdrive)\opt\HWiNFO64.exe
    & $($env:systemdrive)\opt\cpuz_x64.exe
} else {
    Write-Host 'Install Partition Wizard Free...'
    & $($env:systemdrive)\opt\HWiNFO32.exe
    & $($env:systemdrive)\opt\cpuz_x32.exe
}
