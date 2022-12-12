/**
 * Tested with Version 1.1.34
 */
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

; Functions --------------------------------------------------------------------
isDebug := false
debugTooltip(message = "") {
    if isDebug {
        ToolTip % message
    }
}

lastToggle := ""
lastActiveId := 0
toogleVlc(applicationExe = "") {
    global lastToggle
    global lastActiveId
    Process, Exist, %applicationExe%
    if (!ErrorLevel) {
        Return
    }

    if (lastActiveId == 0) {
        lastToggle = %applicationExe%
        WinGet, lastActiveId, ID, A
        WinActivate, ahk_exe %applicationExe%
        WinWaitActive, ahk_exe %applicationExe%
        Send, {Space}
    } else {
        Send, {Space}
        Sleep, 10
        WinActivate, ahk_id %lastActiveId%
        lastToggle := ""
        lastActiveId := 0
    }
}

toogleSwitchApp(applicationExe = "") {
    global lastToggle
    global lastActiveId
    Process, Exist, %applicationExe%
    if (!ErrorLevel) {
        Return
    }

    if (lastActiveId == 0) {
        lastToggle = %applicationExe%
        WinGet, lastActiveId, ID, A
        WinActivate, ahk_exe %applicationExe%
        WinWaitActive, ahk_exe %applicationExe%
    } else {
        WinActivate, ahk_id %lastActiveId%
        lastToggle := ""
        lastActiveId := 0
    }
}

toogleApplication(applicationExe = "") {
    global lastToggle
    global lastActiveId
    if (lastToggle != "") {
        applicationExe = %lastToggle%
    }

    if (applicationExe == "vlc.exe") {
        toogleVlc(applicationExe)
    } else {
        toogleSwitchApp(applicationExe)
    }
}

; Keyboard ---------------------------------------------------------------------
if (!(WinActive("ahk_exe Code.exe") or WinActive("ahk_exe firefox.exe"))) {
    F1::
        toogleApplication("firefox.exe")
    return

    F2::
        toogleApplication("Discord.exe")
    return

    F3::
        toogleApplication("xnviewmp.exe")
    return

    F4::
        toogleApplication("vlc.exe")
    return
}

F10::Suspend
F11::Reload
F12::ExitApp
