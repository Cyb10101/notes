#Requires AutoHotkey v2.0-beta

#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force

; Functions --------------------------------------------------------------------
isDebug := false
debugTooltip(message := "") {
    if isDebug {
        ToolTip message
    }
}

lastToggle := ""
lastActiveId := 0
toogleVlc(applicationExe := "") {
    global lastToggle
    global lastActiveId
    if (!PID := ProcessExist(applicationExe)) {
        Return
    }

    if (lastActiveId == 0) {
        lastToggle := applicationExe
        lastActiveId := WinGetID("A")
        WinActivate "ahk_exe" applicationExe
        WinWaitActive "ahk_exe" applicationExe
        Send "{Space}"
    } else {
        Send "{Space}"
        Sleep 10
        WinActivate "ahk_id" lastActiveId
        lastToggle := ""
        lastActiveId := 0
    }
}

toogleSwitchApp(applicationExe := "") {
    global lastToggle
    global lastActiveId
    if (!PID := ProcessExist(applicationExe)) {
        Return
    }

    if (lastActiveId == 0) {
        lastToggle := applicationExe
        lastActiveId := WinGetID("A")
        WinActivate "ahk_exe" applicationExe
        WinWaitActive "ahk_exe" applicationExe
    } else {
        WinActivate "ahk_id" lastActiveId
        lastToggle := ""
        lastActiveId := 0
    }
}

toogleApplication(applicationExe := "") {
    global lastToggle
    global lastActiveId
    if (lastToggle != "") {
        applicationExe := lastToggle
    }

    if (applicationExe == "vlc.exe") {
        toogleVlc(applicationExe)
    } else {
        toogleSwitchApp(applicationExe)
    }
}

; Keyboard ---------------------------------------------------------------------
;#HotIf !(WinActive("ahk_exe Code.exe") or WinActive("ahk_exe firefox.exe"))
#HotIf !(WinActive("ahk_exe Code.exe"))
F1::{
    toogleApplication("firefox.exe")
}

F2::{
    toogleApplication("Discord.exe")
}

F3::{
    toogleApplication("xnviewmp.exe")
}

F4::{
    toogleApplication("vlc.exe")
}
#HotIf

F10::Suspend
F11::Reload
F12::ExitApp
