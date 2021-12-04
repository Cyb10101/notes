@echo off
setlocal EnableExtensions EnableDelayedExpansion

set scriptPath=%~dp0.

call :checkAdminPermissions
if %ERRORLEVEL% NEQ 0 goto exit

call :buildImage
if %ERRORLEVEL% NEQ 0 goto exit

rem Force execution to quit at the end of the "main" logic
:exit
call :sleep 5
endlocal
exit /B %ERRORLEVEL%

:checkAdminPermissions
  net session >nul 2>&1
  if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Administrative permissions required!
    exit /b %ERRORLEVEL%
  )
goto:eof

:sleep
  timeout /t %1
goto:eof

:buildImage
  rem Calling a script which sets some useful variables 
  call "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"
  cd "%scriptPath%"

  powershell -ExecutionPolicy Unrestricted -File "%scriptPath%\build.ps1"
  pause
goto:eof
