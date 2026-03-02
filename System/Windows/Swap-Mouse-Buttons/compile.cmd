@echo off
"%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\csc" swap-mouse-buttons.cs

if errorlevel 1 (
    echo Compilation failed!
    timeout /t 10 >nul
    exit /b 1
)

echo Executable generated.
timeout /t 3 >nul
