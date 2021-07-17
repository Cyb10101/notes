@echo off

rem Copy changed configuration to folder
rem reg export HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband C:\Users\WDAGUtilityAccount\Desktop\Sandbox\deploy\taskbar.reg
rem robocopy "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "%USERPROFILE%\Desktop\Sandbox\deploy\TaskBar" /MIR

set "DIR_DOWNLOADS=%USERPROFILE%\Desktop\Downloads"
set "DIR_DEPLOY=%USERPROFILE%\Desktop\Sandbox\deploy"

call :configureSandbox
call :installFirefox
rem call :installVisualStudioCode

explorer.exe %DIR_DOWNLOADS%
start cmd.exe /K "cd /d %DIR_DOWNLOADS%"

exit /b

:configureSandbox
  del "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
  rem robocopy "%DIR_DEPLOY%\TaskBar" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" /MIR

  reg import C:\Users\WDAGUtilityAccount\Desktop\Sandbox\deploy\config.reg
  rem reg import C:\Users\WDAGUtilityAccount\Desktop\Sandbox\deploy\taskbar.reg
exit /b

:installFirefox
  if not exist "%DIR_DEPLOY%\firefox.exe" (
    curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de" --output %DIR_DEPLOY%\firefox.exe
  )
  rem START /WAIT %DIR_DEPLOY%\firefox.exe /S
  %DIR_DEPLOY%\firefox.exe /S
exit /b

:installVisualStudioCode
  if not exist "%DIR_DEPLOY%\vscode.exe" (
    curl -L "https://update.code.visualstudio.com/latest/win32-x64-user/stable" --output %DIR_DEPLOY%\vscode.exe
  )
  %DIR_DEPLOY%\vscode.exe /verysilent /suppressmsgboxes /MERGETASKS=!runcode
exit /b
