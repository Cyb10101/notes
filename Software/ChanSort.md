# ChanSort

* [ChanSort](https://github.com/PredatH0r/ChanSort/releases)

```powershell
# Add unzip function
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip {
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Download and extract files
mkdir C:\opt
Invoke-WebRequest https://github.com/PredatH0r/ChanSort/releases/download/v2020-05-02/ChanSort_2020-05-02.zip -OutFile C:\opt\chansort.zip
Unzip "C:\opt\chansort.zip" "C:\opt"
del C:\opt\chansort.zip
ren C:\opt\ChanSort_2020-05-02 C:\opt\ChanSort

# Create shortcut (Programs)
$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\ChanSort.lnk");
$s.TargetPath="C:\opt\ChanSort\ChanSort.exe";
$s.WorkingDirectory="C:\opt\ChanSort";
$s.Save();
```
