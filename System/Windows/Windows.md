# Windows

## Switch off hibernation

So that you can also access Windows hard disks on Linux.

```bash
powercfg.exe /h off
powercfg.exe /hibernate off
```

## Complete shutdown

See: [Scripts/Complete-shutdown.lnk](Scripts/Complete-shutdown.lnk)

```bash
%windir%\system32\shutdown.exe /s /t 0
```

## Move window

ALT + spacebar, then press V key.

## Activate administrator account

```bash
net user Administrator /active:yes
```

## Take over Windows rights

```bash
icacls c:\folder\* /grant {username}:F
cacls "c:\system volume information" /E /G {username}:F
```

## Create a soft link folder

```bash
mklink /J "C:\soft\link" "D:\hard\link"
```

## Create folder list

```bash
dir * /b /s > !liste.txt
```

## Make all files and folders visible (do not hide)

```bash
attrib -H * /S /D
```

## Hide file

```bash
attrib +H C:\Datei.txt
```

## Switch off desktop cleaning

* Control Panel\All Control Panel Items\Troubleshoot > Change Settings
* Computer maintenance = off

## Mount and disconnect virtual drive

```bash
subst Z: "C:\folder"
subst Z: /d
```

## Windows 8 Bios

* Start > Change PC settings > Update/recovery > Recovery > Advanced start (restart now)
* Troubleshoot > Advanced Options > UEFI Firmware Settings

## Virtuelle Desktops

```bash
Settings > System > Multitasking > Virtual Desktops
* In the taskbar show windows that are open on > All Desktops
* When pressing ALT + TAB > Only on the currently used desktop
```
