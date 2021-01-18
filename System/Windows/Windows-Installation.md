# Windows Installation

## Flameshot

* [Flameshot](https://github.com/flameshot-org/flameshot)

```shell
curl -fSL -o "%LOCALAPPDATA%\Temp\flameshot.zip" "https://github.com/flameshot-org/flameshot/releases/download/v0.8.4/flameshot-0.8.4-win64.zip"

# Unzip via Powershell
powershell -Command "Expand-Archive -Force \"$env:localappdata\Temp\flameshot.zip\" \"$env:homedrive$env:homepath\opt\""

# Unzip via 7-Zip
# "C:\Program Files\7-Zip\7z.exe" x -o"%HOMEDRIVE%%HOMEPATH%\opt" "%LOCALAPPDATA%\Temp\flameshot.zip"

cd /D "%HOMEDRIVE%%HOMEPATH%\opt"
ren flameshot-0.8.4-win64 flameshot
del "%LOCALAPPDATA%\Temp\flameshot.zip"

# Create shortcut for startup (explorer "shell:startup")
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut(\"$env:homedrive$env:homepath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\FlameShot.lnk\");$s.TargetPath=\"$env:homedrive$env:homepath\opt\flameshot\bin\flameshot.exe\";$s.Save()"

# Create shortcut in program folder (explorer "shell:programs")
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut(\"$env:homedrive$env:homepath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\FlameShot.lnk\");$s.TargetPath=\"$env:homedrive$env:homepath\opt\flameshot\bin\flameshot.exe\";$s.Save()"
```

## ChanSort

* [ChanSort](https://github.com/PredatH0r/ChanSort/releases)

```shell
curl -fSL -o "%LOCALAPPDATA%\Temp\chansort.zip" "https://github.com/PredatH0r/ChanSort/releases/download/v2021-01-17/ChanSort_2021-01-17.zip"

# Unzip via Powershell
powershell -Command "Expand-Archive -Force \"$env:localappdata\Temp\chansort.zip\" \"$env:homedrive$env:homepath\opt\""

# Unzip via 7-Zip
# "C:\Program Files\7-Zip\7z.exe" x -o"%HOMEDRIVE%%HOMEPATH%\opt" "%LOCALAPPDATA%\Temp\chansort.zip"

cd /D "%HOMEDRIVE%%HOMEPATH%\opt"
ren ChanSort_2021-01-17 ChanSort
del "%LOCALAPPDATA%\Temp\chansort.zip"

# Create shortcut in program folder (explorer "shell:programs")
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut(\"$env:homedrive$env:homepath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ChanSort.lnk\");$s.TargetPath=\"$env:homedrive$env:homepath\opt\ChanSort\ChanSort.exe\";$s.Save()"
```
