# Compare Registry

```powershell
scoop install windiff winmerge

function regExport([string]$directory) {if (-Not(Test-Path "$($directory)")) {New-Item -ItemType "directory" -Path "$($directory)";}; reg export HKLM $directory\HKLM.reg /Y; reg export HKCU $directory\HKCU.reg /Y; reg export HKCR $directory\HKCR.reg /Y; reg export HKU $directory\HKU.reg /Y; reg export HKCC $directory\HKCC.reg /Y; Write-Host "Registry exported to $directory";}

regExport tmp-compare\1
regExport tmp-compare\2

windiff tmp-compare\1 tmp-compare\2
WinMergeU tmp-compare\1 tmp-compare\2
```
