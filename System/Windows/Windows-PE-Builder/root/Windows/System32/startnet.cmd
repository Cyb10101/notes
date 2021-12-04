@echo off
title Windows PE (Main Process)
wpeinit

rem Power scheme: High performance
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

rem powershell -ExecutionPolicy Unrestricted -File ".\startnet.ps1"

rem Change Console size
rem MODE CON COLS=30 LINES=5

rem Show software
cd %SYSTEM_DRIVE%\opt
echo Software:
dir *.exe /B
echo.

rem Show information
echo Processor Architecture: %processor_architecture%

rem Show Warnings
echo DO NOT CLOSE THIS WINDOW OR SYSTEM REBOOTS!
