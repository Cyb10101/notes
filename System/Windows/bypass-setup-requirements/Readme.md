# Windows 11 - Bypass setup requirements

These files force the upgrade to Windows 11 without performing the official hardware checks.

* [Microsoft Windows 11 ISO](https://www.microsoft.com/de-de/software-download/windows11)
* [WhyNotWin11](https://github.com/rcmaehl/WhyNotWin11)

## ⚠️ Important note

These changes circumvent the official system requirements of Windows 11. Microsoft may prevent this in future updates or restrict the functionality.

## 1. Standard upgrade

If the standard upgrade fails, first try [1-bypass-hardware-checks.cmd](1-bypass-hardware-checks.cmd) or [1-bypass-hardware-checks.reg](1-bypass-hardware-checks.reg). Allows upgrades with unsupported hardware (Secure Boot/TPM/CPU/RAM). Requires a system restart.

## 2. Problems persist

If problems persist, use [2-bypass-setup-requirements.reg](2-bypass-setup-requirements.reg) for additional check bypasses: TPM, Secure Boot, RAM, CPU, memory, hard drive. Requires a system restart.

## 3. Windows updates disabled

Run [3-allow-upgrades-on-unsupported-hardware.reg](3-allow-upgrades-on-unsupported-hardware.reg), if Windows updates are disabled, and a note regarding upgrade/installation appears:

> If you proceed with the installation of Windows 11, your PC will no longer be supported and will not be eligible to receive updates.

This file enables Windows updates on unsupported systems. Microsoft can block updates for unofficially installed Windows 11 systems, but this file re-enables the update service. Requires a system restart.

Check for updates in Windows settings (Settings > Windows Update > Check for updates).

## Bypass requirements during setup

Bypass installation requirements:

* Boot Windows Setup ISO
* Select language
* Launch Command: Shift + F10
* Run: regedit
* Add registry keys (Bypass...Check) or use file [2-bypass-setup-requirements.reg](2-bypass-setup-requirements.reg)
* Click on "Install now"

```powershell
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\PCHC]
#"UpgradeEligibility"=dword:00000001

[HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
#"BypassRAMCheck"=dword:00000001
#"BypassStorageCheck"=dword:00000001
#"BypassCPUCheck"=dword:00000001
#"BypassDiskCheck"=dword:00000001
```

Bypass internet requirements:

* Go though setup until you reach page: "Let's connect you to a network"
* Open Command promt with: Shift + F10
* Run: C:\Windows\System\oobe\BypassNRO.cmd
* Reboot and click on "I don't have internet"

Contents of file `C:\Windows\System32\oobe\BypassNRO.cmd` or `C:\Windows\System\oobe\BypassNRO.cmd`:

```shell
@echo off
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f
shutdown /r /t 0
```
