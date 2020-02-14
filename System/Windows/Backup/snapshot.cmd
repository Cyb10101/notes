@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Download Snapshot binary: http://www.drivesnapshot.de/de/down.htm
rem To abort shutdown type in console: shutdown /a

rem ----------------------------------------------------------------------------
rem Adjust the desired values here:
set SourceDrive=C:
set TargetPath=%~dp0.
rem set TargetPath=C:\Users\User\Desktop\Backup
set TargetFolderName=Snapshot_
set BinarySnapshot=%~dp0.\snapshot64.exe
rem set BinarySnapshot=snapshot
set BackupCount=4
set PartsMB=5000

rem Boolean if set (var=y) it true, if empty (var=) it means false
set PowerOffAfterBackup=y
rem ----------------------------------------------------------------------------

call :checkAdminPermissions
if %ERRORLEVEL% NEQ 0 goto exit

call :removeLastBackup
if %ERRORLEVEL% NEQ 0 goto exit

call :moveBackupFolder
if %ERRORLEVEL% NEQ 0 goto exit

call :createTargetFolder
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

rem Remove last backup folder (Maximum from BackupCount)
:removeLastBackup
	if exist %TargetPath%\%TargetFolderName%old (
		echo ERROR: Please delete folder %TargetFolderName%old
		exit /B 1
	)

	if exist %TargetPath%\%TargetFolderName%%BackupCount% (
		echo Remove old backup %BackupCount%
		ren %TargetPath%\%TargetFolderName%%BackupCount% %TargetFolderName%old
		rd %TargetPath%\%TargetFolderName%old /s /q
	)
goto:eof

rem Move all backupfolder (..., 3 to 4, 2 to 3, 1 to 2)
:moveBackupFolder
	for /L %%i in (%BackupCount%,-1,1) do (
		set /a NewNumber=%%i-1
		if exist %TargetPath%\%TargetFolderName%!NewNumber! (
			echo Move backup !NewNumber! to %%i
			ren %TargetPath%\%TargetFolderName%!NewNumber! %TargetFolderName%%%i
		)
	)
goto:eof

:createTargetFolder
	if not exist %TargetPath%\%TargetFolderName%1 (
		md %TargetPath%\%TargetFolderName%1
	)
goto:eof

:createBackup
	if not exist %TargetPath%\%TargetFolderName%1 (
		echo ERROR: Backup folder not created!
		exit /B 2
	)

	%BinarySnapshot% %SourceDrive% %TargetPath%\%TargetFolderName%1\image-$disk.sna -L%PartsMB% -Go
  if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Snapshot error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
	)
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
