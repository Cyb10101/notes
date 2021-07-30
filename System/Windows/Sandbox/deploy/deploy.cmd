@echo off

rem Copy changed configuration to folder
rem reg export HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband %DIR_DEPLOY%\taskbar.reg
rem robocopy "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "%USERPROFILE%\Desktop\deploy\TaskBar" /MIR

set "DIR_DOWNLOADS=%USERPROFILE%\Desktop\Downloads"
set "DIR_DEPLOY=%USERPROFILE%\Desktop\deploy"
set "DIR_TEMP=%LOCALAPPDATA%\Temp"

call :configureSandbox
rem call :installFirefox %DIR_DEPLOY%
rem call :installFirefox %DIR_TEMP%

rem Let powershell open: -NoExit
start /WAIT powershell -Command "Set-ExecutionPolicy RemoteSigned -scope CurrentUser -Confirm:$False -Force; Set-Location %DIR_DEPLOY%; . .\deploy.ps1"

rem start cmd.exe /K "cd /d %DIR_DOWNLOADS%"
rem start powershell -NoExit -Command "Set-Location %DIR_DOWNLOADS%"
rem start powershell -NoExit -Command "Set-Location %DIR_DEPLOY%"
rem explorer.exe %DIR_DOWNLOADS%

exit /b

:configureSandbox
  del "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
  rem robocopy "%DIR_DEPLOY%\TaskBar" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" /MIR

  reg import %DIR_DEPLOY%\config.reg
  rem reg import %DIR_DEPLOY%\taskbar.reg
exit /b

:installFirefox
  if not exist "%1\firefox.exe" (
    curl -L --output "%1\firefox.exe" "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de"
  )
  rem START /WAIT %1\firefox.exe /S
  %1\firefox.exe /S
exit /b
