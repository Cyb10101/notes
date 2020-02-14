@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem To abort shutdown type in console: shutdown /a

rem ----------------------------------------------------------------------------
rem Adjust the desired values here:

rem Boolean if set (var=y) it true, if empty (var=) it means false
set PowerOffAfterBackup=y
rem ----------------------------------------------------------------------------

set ScriptPath=%~dp0.

call :checkAdminPermissions
if %ERRORLEVEL% NEQ 0 goto exit

call :createBackup
if %ERRORLEVEL% NEQ 0 goto exit

if defined PowerOffAfterBackup (
	call :shutdown 60
	if %ERRORLEVEL% NEQ 0 goto exit
)

rem Force execution to quit at the end of the "main" logic
:exit
call :sleep 5
endlocal
exit /B %ERRORLEVEL%

:createBackup
  robocopy %HOMEDRIVE%%HOMEPATH% %ScriptPath%\Users_%USERNAME% /MIR /XJ /R:0 /W:0 /NDL /NFL /NJS ^
    /XF "NTUSER.DAT" /XF "ntuser.dat.*" /XF "UsrClass.dat*" ^
    /XF "WebCacheLock.dat*" ^
    /XD "%HOMEDRIVE%%HOMEPATH%\AppData\Local\Microsoft\Windows\WebCache" ^
    /XD "%HOMEDRIVE%%HOMEPATH%\AppData\Local\Microsoft\Windows\Notifications" ^
    /XD "%HOMEDRIVE%%HOMEPATH%\AppData\Local\Packages"
goto:eof

:shutdown
  echo Backup complete, shutdown in %1 seconds...
	shutdown /s /t %1 /c "Backup complete, shutdown in %1 seconds..."
goto:eof

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
