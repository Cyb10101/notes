@echo off

:: Check if the script is being run as administrator.
:: net session >nul 2>&1
fltmc >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run the script as administrator!
    pause
    exit /b
)

echo Windows 11 Upgrade Bypass is being applied...

:: Registry entry for AppCompatFlags\HwReqChk
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\HwReqChk" ^
  /f /v HwReqChkVars /t REG_MULTI_SZ /s , ^
  /d "SQ_SecureBootCapable=TRUE,SQ_SecureBootEnabled=TRUE,SQ_TpmVersion=2,SQ_RamMB=8192,"
if errorlevel 1 goto :fail

:: Registry entry for MoSetup - Allows upgrades with unsupported CPUs/TPM
reg add "HKLM\SYSTEM\Setup\MoSetup" /f /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1
if errorlevel 1 goto :fail

echo.
echo Registration successfully updated! Restart your PC before starting the Windows 11 setup.
pause
exit /b 0

:fail
echo.
echo Error setting registry keys. Aborting.
pause
exit /b 1
