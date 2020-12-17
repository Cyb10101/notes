# ChanSort

* [ChanSort](https://github.com/PredatH0r/ChanSort/releases)

```shell
mkdir C:\opt

curl -L -o "%LOCALAPPDATA%\Temp\chansort.zip" "https://github.com/PredatH0r/ChanSort/releases/download/v2020-12-05/ChanSort_2020-12-05.zip"
"C:\Program Files\7-Zip\7z.exe" x -o"C:\opt" "%LOCALAPPDATA%\Temp\chansort.zip"
del "%LOCALAPPDATA%\Temp\chansort.zip"

cd /D C:\opt
ren ChanSort_2020-12-05 ChanSort
```

Create shortcut (Programs):

```powershell
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\ChanSort.lnk");
$s.TargetPath="C:\opt\ChanSort\ChanSort.exe";
$s.WorkingDirectory="C:\opt\ChanSort";
$s.Save();
```
