/**
 * Tested with Version 1.1.34
 */
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include %A_ScriptDir%\XInput.ahk
XInput_Init()

; Functions --------------------------------------------------------------------
isDebug := false
debugTooltip(message = "") {
    if isDebug {
        ToolTip % message
    }
}

; Keyboard ---------------------------------------------------------------------
F9::
global isDebug
isDebug := !isDebug
ToolTip
return

F10::Suspend
F11::Reload
F12::ExitApp

#IfWinActive ahk_class Notepad ahk_exe Notepad.exe
; WASD to Arrows
w::Up
s::Down
a::Left
d::Right

; Switch y to z, z to y
y::z
z::y
#IfWinActive

; Gamepad ----------------------------------------------------------------------
#MaxThreadsPerHotkey 3
F1:: ; Activate/Deactivate Gamepad
#MaxThreadsPerHotkey 1
if isThreadGamepadRunning {
    isThreadGamepadRunning := false
    ToolTip % "Gamepad disabled"
    Sleep 1000
    ToolTip
    return
} else {
    ToolTip % "Gamepad enabled"
    Sleep 1000
    ToolTip
}
isThreadGamepadRunning := true

gamepadIsPressedStart := false
gamepadIsPressedBack := false
gamepadIsPressedA := false
gamepadIsPressedB := false
gamepadIsPressedX := false
gamepadIsPressedY := false

gamepadIsPressedLeftShoulder := false
gamepadIsPressedRightShoulder := false

gamepadTriggerThreshold := 64
gamepadIsPressedLeftTrigger := false
gamepadIsPressedRightTrigger := false

gamepadIsPressedLeftThumb := false
gamepadIsPressedRightThumb := false

gamepadThumbThreshold := 9000
gamepadThumbThresholdReverse := gamepadThumbThreshold * -1
gamepadIsPressedThumbLX := 0
gamepadIsPressedThumbLXLeft := false
gamepadIsPressedThumbLXRight := false
gamepadIsPressedThumbLYUp := false
gamepadIsPressedThumbLYDown := false
gamepadIsPressedThumbRXLeft := false
gamepadIsPressedThumbRXRight := false
gamepadIsPressedThumbRYUp := false
gamepadIsPressedThumbRYDown := false

gamepadIsPressedDpadUp := false
gamepadIsPressedDpadDown := false
gamepadIsPressedDpadLeft := false
gamepadIsPressedDpadRight := false

Loop {
    if not isThreadGamepadRunning {
        break
    }

    State := XInput_GetState()
    if State {
        if ! gamepadIsPressedStart && State.Buttons & XINPUT_GAMEPAD_START {
            debugTooltip("Gamepad Start (pressed)")
            ; Send {Enter down}
            gamepadIsPressedStart := true
        } else if gamepadIsPressedStart && ! (State.Buttons & XINPUT_GAMEPAD_START) {
            debugTooltip("Gamepad Start (released)")
            ; Send {Enter up}
            gamepadIsPressedStart := false
        }
        if ! gamepadIsPressedBack && State.Buttons & XINPUT_GAMEPAD_BACK {
            debugTooltip("Gamepad Back (pressed)")
            gamepadIsPressedBack := true
        } else if gamepadIsPressedBack && ! (State.Buttons & XINPUT_GAMEPAD_BACK) {
            debugTooltip("Gamepad Back (released)")
            gamepadIsPressedBack := false
        }

        if ! gamepadIsPressedA && State.Buttons & XINPUT_GAMEPAD_A {
            debugTooltip("Gamepad A (pressed)")
            ; Send {Space down}
            gamepadIsPressedA := true
        } else if gamepadIsPressedA && ! (State.Buttons & XINPUT_GAMEPAD_A) {
            debugTooltip("Gamepad A (released)")
            ; Send {Space up}
            gamepadIsPressedA := false
        }
        if ! gamepadIsPressedB && State.Buttons & XINPUT_GAMEPAD_B {
            debugTooltip("Gamepad B (pressed)")
            gamepadIsPressedB := true
        } else if gamepadIsPressedB && ! (State.Buttons & XINPUT_GAMEPAD_B) {
            debugTooltip("Gamepad B (released)")
            gamepadIsPressedB := false
        }
        if ! gamepadIsPressedX && State.Buttons & XINPUT_GAMEPAD_X {
            debugTooltip("Gamepad X (pressed)")
            gamepadIsPressedX := true
        } else if gamepadIsPressedX && ! (State.Buttons & XINPUT_GAMEPAD_X) {
            debugTooltip("Gamepad X (released)")
            gamepadIsPressedX := false
        }
        if ! gamepadIsPressedY && State.Buttons & XINPUT_GAMEPAD_Y {
            debugTooltip("Gamepad Y (pressed)")
            gamepadIsPressedY := true
        } else if gamepadIsPressedY && ! (State.Buttons & XINPUT_GAMEPAD_Y) {
            debugTooltip("Gamepad Y (released)")
            gamepadIsPressedY := false
        }

        if ! gamepadIsPressedLeftShoulder && State.Buttons & XINPUT_GAMEPAD_LEFT_SHOULDER {
            debugTooltip("Gamepad Left Shoulder (pressed)")
            gamepadIsPressedLeftShoulder := true
        } else if gamepadIsPressedLeftShoulder && ! (State.Buttons & XINPUT_GAMEPAD_LEFT_SHOULDER) {
            debugTooltip("Gamepad Left Shoulder (released)")
            gamepadIsPressedLeftShoulder := false
        }
        if ! gamepadIsPressedRightShoulder && State.Buttons & XINPUT_GAMEPAD_RIGHT_SHOULDER {
            debugTooltip("Gamepad Right Shoulder (pressed)")
            gamepadIsPressedRightShoulder := true
        } else if gamepadIsPressedRightShoulder && ! (State.Buttons & XINPUT_GAMEPAD_RIGHT_SHOULDER) {
            debugTooltip("Gamepad Right Shoulder (released)")
            gamepadIsPressedRightShoulder := false
        }

        if ! gamepadIsPressedLeftTrigger && State.LeftTrigger >= gamepadTriggerThreshold {
            debugTooltip("Gamepad Left Trigger (pressed)")
            gamepadIsPressedLeftTrigger := true
        } else if gamepadIsPressedLeftTrigger && State.LeftTrigger < gamepadTriggerThreshold {
            debugTooltip("Gamepad Left Trigger (released)")
            gamepadIsPressedLeftTrigger := false
        }
        if ! gamepadIsPressedRightTrigger && State.RightTrigger >= gamepadTriggerThreshold {
            debugTooltip("Gamepad Right Trigger (pressed)")
            gamepadIsPressedRightTrigger := true
        } else if gamepadIsPressedRightTrigger && State.RightTrigger < gamepadTriggerThreshold {
            debugTooltip("Gamepad Right Trigger (released)")
            gamepadIsPressedRightTrigger := false
        }

        if ! gamepadIsPressedLeftThumb && State.Buttons & XINPUT_GAMEPAD_LEFT_THUMB {
            debugTooltip("Gamepad Left Thumb (pressed)")
            gamepadIsPressedLeftThumb := true
        } else if gamepadIsPressedLeftThumb && ! (State.Buttons & XINPUT_GAMEPAD_LEFT_THUMB) {
            debugTooltip("Gamepad Left Thumb (released)")
            gamepadIsPressedLeftThumb := false
        }
        if ! gamepadIsPressedRightThumb && State.Buttons & XINPUT_GAMEPAD_RIGHT_THUMB {
            debugTooltip("Gamepad Right Thumb (pressed)")
            gamepadIsPressedRightThumb := true
        } else if gamepadIsPressedRightThumb && ! (State.Buttons & XINPUT_GAMEPAD_RIGHT_THUMB) {
            debugTooltip("Gamepad Right Thumb (released)")
            gamepadIsPressedRightThumb := false
        }

        ; Left position not working
        ;if ! gamepadIsPressedThumbLX == 1 && State.ThumbLX >= gamepadThumbThreshold {
        ;    debugTooltip("Gamepad Thumb Left X (pressed right)" . State.ThumbLX)
        ;    gamepadIsPressedThumbLX := 1
        ;} else if ! gamepadIsPressedThumbLX == 2 && State.ThumbLX <= gamepadThumbThresholdReverse {
        ;    debugTooltip("Gamepad Thumb Left X (pressed left)" . State.ThumbLX)
        ;    gamepadIsPressedThumbLX := 2
        ;} else if ! gamepadIsPressedThumbLX == 0 && State.ThumbLX > gamepadThumbThresholdReverse && State.ThumbLX < gamepadThumbThreshold {
        ;    debugTooltip("Gamepad Thumb Left X (released)" . State.ThumbLX)
        ;    gamepadIsPressedThumbLX := 0
        ;}
        ; debugTooltip("Gamepad Thumb Left X " . State.ThumbLX . " left: " . (State.ThumbLX <= gamepadThumbThresholdReverse) . " right: " . (State.ThumbLX >= gamepadThumbThreshold) . " p: " . gamepadIsPressedThumbLX)

        if ! gamepadIsPressedThumbLXRight && State.ThumbLX >= gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Left X (pressed right)")
            ; Send {Right down}
            gamepadIsPressedThumbLXRight := true
        } else if gamepadIsPressedThumbLXRight && State.ThumbLX < gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Left X (released right)")
            ; Send {Right up}
            gamepadIsPressedThumbLXRight := false
        }
        if ! gamepadIsPressedThumbLXLeft && State.ThumbLX <= gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Left X (pressed left)")
            ; Send {Left down}
            gamepadIsPressedThumbLXLeft := true
        } else if gamepadIsPressedThumbLXLeft && State.ThumbLX > gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Left X (released left)")
            ; Send {Left up}
            gamepadIsPressedThumbLXLeft := false
        }

        if ! gamepadIsPressedThumbLYUp && State.ThumbLY >= gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Left Y (pressed up)")
            ; Send {Up down}
            gamepadIsPressedThumbLYUp := true
        } else if gamepadIsPressedThumbLYUp && State.ThumbLY < gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Left Y (released up)")
            ; Send {Up up}
            gamepadIsPressedThumbLYUp := false
        }
        if ! gamepadIsPressedThumbLYDown && State.ThumbLY <= gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Left Y (pressed down)")
            ; Send {Down down}
            gamepadIsPressedThumbLYDown := true
        } else if gamepadIsPressedThumbLYDown && State.ThumbLY > gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Left Y (released down)")
            ; Send {Down up}
            gamepadIsPressedThumbLYDown := false
        }

        if ! gamepadIsPressedThumbRXRight && State.ThumbRX >= gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Right X (pressed right)")
            gamepadIsPressedThumbRXRight := true
        } else if gamepadIsPressedThumbRXRight && State.ThumbRX < gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Right X (released right)")
            gamepadIsPressedThumbRXRight := false
        }
        if ! gamepadIsPressedThumbRXLeft && State.ThumbRX <= gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Right X (pressed left)")
            gamepadIsPressedThumbRXLeft := true
        } else if gamepadIsPressedThumbRXLeft && State.ThumbRX > gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Right X (released left)")
            gamepadIsPressedThumbRXLeft := false
        }

        if ! gamepadIsPressedThumbRYUp && State.ThumbRY >= gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Right Y (pressed up)")
            gamepadIsPressedThumbRYUp := true
        } else if gamepadIsPressedThumbRYUp && State.ThumbRY < gamepadThumbThreshold {
            debugTooltip("Gamepad Thumb Right Y (released up)")
            gamepadIsPressedThumbRYUp := false
        }
        if ! gamepadIsPressedThumbRYDown && State.ThumbRY <= gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Right Y (pressed down)")
            gamepadIsPressedThumbRYDown := true
        } else if gamepadIsPressedThumbRYDown && State.ThumbRY > gamepadThumbThresholdReverse {
            debugTooltip("Gamepad Thumb Right Y (released down)")
            gamepadIsPressedThumbRYDown := false
        }

        if ! gamepadIsPressedDpadUp && State.Buttons & XINPUT_GAMEPAD_DPAD_UP {
            debugTooltip("Gamepad Direction Pad Up (pressed)")
            Send {Up down}
            gamepadIsPressedDpadUp := true
        } else if gamepadIsPressedDpadUp && ! (State.Buttons & XINPUT_GAMEPAD_DPAD_UP) {
            debugTooltip("Gamepad Direction Pad Up (released)")
            Send {Up up}
            gamepadIsPressedDpadUp := false
        }
        if ! gamepadIsPressedDpadDown && State.Buttons & XINPUT_GAMEPAD_DPAD_DOWN {
            debugTooltip("Gamepad Direction Pad Down (pressed)")
            Send {Down down}
            gamepadIsPressedDpadDown := true
        } else if gamepadIsPressedDpadDown && ! (State.Buttons & XINPUT_GAMEPAD_DPAD_DOWN) {
            debugTooltip("Gamepad Direction Pad Down (released)")
            Send {Down up}
            gamepadIsPressedDpadDown := false
        }
        if ! gamepadIsPressedDpadRight && State.Buttons & XINPUT_GAMEPAD_DPAD_RIGHT {
            debugTooltip("Gamepad Direction Pad Right (pressed)")
            Send {Right down}
            gamepadIsPressedDpadRight := true
        } else if gamepadIsPressedDpadRight && ! (State.Buttons & XINPUT_GAMEPAD_DPAD_RIGHT) {
            debugTooltip("Gamepad Direction Pad Right (released)")
            Send {Right up}
            gamepadIsPressedDpadRight := false
        }
        if ! gamepadIsPressedDpadLeft && State.Buttons & XINPUT_GAMEPAD_DPAD_LEFT {
            debugTooltip("Gamepad Direction Pad Left (pressed)")
            Send {Left down}
            gamepadIsPressedDpadLeft := true
        } else if gamepadIsPressedDpadLeft && ! (State.Buttons & XINPUT_GAMEPAD_DPAD_LEFT) {
            debugTooltip("Gamepad Direction Pad Left (released)")
            Send {Left up}
            gamepadIsPressedDpadLeft := false
        }
    }

    Sleep, 100
}
Tooltip
isThreadGamepadRunning := false
return

F2::
    Caps := XInput_GetCapabilities()
    if Caps {
        MsgBox % "UserIndex: " . Caps.UserIndex . "`n"
            . "SubType: " . Caps.SubType . "`n" 
            . "Flags: " . Caps.Flags . "`n" 
            . "Buttons: " . Caps.Buttons . "`n" 
            . "LeftTrigger: " . Caps.LeftTrigger . "`n" 
            . "RightTrigger: " . Caps.RightTrigger . "`n" 
            . "ThumbLX: " . Caps.ThumbLX . "`n" 
            . "ThumbLY: " . Caps.ThumbLY . "`n" 
            . "ThumbRX: " . Caps.ThumbRX . "`n" 
            . "ThumbRY: " . Caps.ThumbRY . "`n" 
            . "LeftMotorSpeed: " . Caps.LeftMotorSpeed . "`n" 
            . "RightMotorSpeed: " . Caps.RightMotorSpeed . "`n" 
    }
    else if ErrorLevel = ERROR_DEVICE_NOT_CONNECTED
        MsgBox, Failed to find a connected XInput gamepad controller.
    else
        MsgBox, ErrorLevel: %ErrorLevel% `n`nERROR_SUCCESS = 0`nERROR_DEVICE_NOT_CONNECTED = 1167
return

F3::
    State := XInput_GetState()
    
    if State {
        MsgBox % "UserIndex: " . State.UserIndex . "`n" ; The index number of the gamepad
            ;. "PacketNumber: " . State.PacketNumber . PacketNumber . "`n" ; This value increments whenever the state of the gamepad changes.
            . "Buttons: " . State.Buttons . "`n" ; Which buttons are pressed (Bitwise OR). See XInput_Init (above) for the list of buttons.
            . "LeftTrigger: " . State.LeftTrigger . "`n" ; Between 0 and 255
            . "RightTrigger: " . State.RightTrigger . "`n" 
            . "ThumbLX: " State.ThumbLX . "`n" ; Between -32768 to 32767. 0 is centered. Negative is down or left.
            . "ThumbLY: " . State.ThumbLY . "`n" 
            . "ThumbRX: " . State.ThumbRX . "`n" 
            . "ThumbRY: " . State.ThumbRY . "`n" 
    }
    else if ErrorLevel = ERROR_DEVICE_NOT_CONNECTED
        MsgBox, Failed to find a connected XInput gamepad controller.
    else
        MsgBox, ErrorLevel: %ErrorLevel% `n`nERROR_SUCCESS = 0`nERROR_DEVICE_NOT_CONNECTED = 1167
return

F4::
    Battery := XInput_GetBatteryInformation()
    if Battery {
        MsgBox % "UserIndex: " . Battery.UserIndex . "`n" ; Index of the user's controller. Can be a value of 0 to XUSER_MAX_COUNT - 1.
            . "DevType: " . DevType . "`n" ; Specifies which device associated with this user index should be queried. Must be BATTERY_DEVTYPE_GAMEPAD or BATTERY_DEVTYPE_HEADSET.
            . "BatteryType: " . BatteryType . "`n" ; The type of battery.
            . "BatteryLevel: " . BatteryLevel . "`n"  ; The charge state of the battery. This value is only valid for wireless devices with a known battery type.
    }
    else if ErrorLevel = ERROR_DEVICE_NOT_CONNECTED
        MsgBox, Failed to find a connected XInput gamepad controller.
    else
        MsgBox, ErrorLevel: %ErrorLevel% `n`nERROR_SUCCESS = 0`nERROR_DEVICE_NOT_CONNECTED = 1167
return

F5::
    Keystroke = XInput_GetKeystroke()
    
    if Keystroke {
        MsgBox % "UserIndex: " . Keystroke.UserIndex . "`n" ; Index of the signed-in gamer associated with the device. Can be a value in the range 0–3.
            . "VirtualKey: " . Keystroke.VirtualKey . "`n" ; Virtual-key code of the key, button, or stick movement. 
            ;. "Unicode: " . Keystroke.Unicode . "`n" ; This member is unused and the value is zero.
            . "Flags: " . Keystroke.Flags . "`n" ; Flags that indicate the keyboard state at the time of the input event. 
            . "HidCode: " . Keystroke.HidCode . "`n" ; HID code corresponding to the input. If there is no corresponding HID code, this value is zero.
    }
    else if ErrorLevel = ERROR_EMPTY
        MsgBox, No new gamepad keystrokes.
    else if ErrorLevel = ERROR_DEVICE_NOT_CONNECTED
        MsgBox, Failed to find a connected XInput gamepad controller.
    else
        MsgBox, ErrorLevel: %ErrorLevel% `n`nERROR_SUCCESS = 0`nERROR_DEVICE_NOT_CONNECTED = 1167`nERROR_EMPTY = 4306
return

F6::
Loop 16 ; Query each joystick number to find out which ones exist.
{
    GetKeyState, JoyName, %A_Index%JoyName
    if JoyName <>
    {
        JoystickNumber = %A_Index%
        MsgBox Joystick found: %JoystickNumber%
        break
    }
}
if JoystickNumber <= 0
{
    MsgBox The system does not appear to have any joysticks.
    ExitApp
}
return
