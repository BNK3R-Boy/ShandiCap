#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#InstallKeybdHook
#MaxThreadsPerHotkey 1
#MaxThreadsBuffer Off

If (!A_IsAdmin) {
	SetEnv, UserInput, % DllCall( "GetCommandLine", "Str" )
	Run *RunAs %UserInput% ; (A_AhkPath is usually optional If the script has the .ahk extension.) You would typically check  first.
	ExitApp
}

SetKeyDelay, 100, 400
Global  TF := A_Temp "\ShandiCap\"
Global  ICO := TF "ShandiCap.ico"

If !FileExist(TF) {
	FileCreateDir, %TF%
	FileInstall, ShandiCap.ico, %ICO%, 1
}

Menu, Tray, NoStandard
Menu, Tray, Tip, ShandiCap
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add,
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, Reload
Menu, Tray, Icon, %ICO%

Global fnPresses := Func("Presses")
Global wPresses, aPresses, sPresses, dPresses, LastPress, _hotkey, PressedKey, TimeBetweenPresses, LastPressedKey
Global DoubleClickTime := DllCall("GetDoubleClickTime")	; Get the doubleclicktime in milliseconds
Global timertime := DoubleClickTime * -1

Hotkey, ~*w, %fnPresses%
Hotkey, ~*a, %fnPresses%
Hotkey, ~*s, %fnPresses%
Hotkey, ~*d, %fnPresses%

Return

Presses() {
	_hotkey := StrReplace(A_ThisHotkey, "~*")
	LastPress := A_TickCount
	PressedKey := _hotkey
	TimeBetweenPresses := A_TickCount - LastPress

	If (LastPressedKey) And (PressedKey == LastPressedKey) {
		IfGreater, TimeBetweenPresses, DoubleClickTime, TimeBetweenPresses := 0
		IfGreater, %_hotkey%Presses, 2, GoSub, ResetPresses
		IfLessOrEqual, TimeBetweenPresses, DoubleClickTime, %_hotkey%Presses++
		IfEqual, %_hotkey%Presses, 2, ControlSend, ,{%_hotkey% down}{Shift}, A
		LastPressedKey := 0
	} Else
		LastPressedKey := PressedKey

	SetTimer, ResetPresses, %timertime%

	Loop {
		If !(GetKeyState(_hotkey, "P"))
			Return
		Sleep 10
	}
}

ResetPresses:
	wPresses := 0
	aPresses := 0
	sPresses := 0
	dPresses := 0
	LastPress := 0
	LastPressedKey := 0
Return

Reload:
	Reload
Return

Exit:
	ExitApp
Return