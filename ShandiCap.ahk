#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#MaxThreadsPerHotkey 1
#MaxThreadsBuffer 0

If (!A_IsAdmin) {
	SetEnv, UserInput, % DllCall( "GetCommandLine", "Str" )
	Run *RunAs %UserInput% ; (A_AhkPath is usually optional If the script has the .ahk extension.) You would typically check  first.
	ExitApp
}

SetKeyDelay, 100, 300

Global fnPresses := Func("Presses")
Global LastPressedKey
Global MemoryDrainTimer := -1 * (DllCall("GetDoubleClickTime") + 100) ; Get the double click time in milliseconds, add 100 to it and divide by -1 to get a negative number for memory drain time.
Global TF := A_Temp "\ShandiCap\"
Global ICO := TF "ShandiCap.ico"

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

Hotkey, ~*w, %fnPresses%
Hotkey, ~*a, %fnPresses%
Hotkey, ~*s, %fnPresses%
Hotkey, ~*d, %fnPresses%

Return

Presses() {
	_hotkey := StrReplace(A_ThisHotkey, "~*")
	PressedKey := _hotkey
	If (LastPressedKey) And (PressedKey == LastPressedKey) {
		ControlSend, ,{%_hotkey% down}{Shift}, A
		LastPressedKey := 0
	} Else {
		LastPressedKey := PressedKey
		SetTimer, ResetLastPressedKey, %MemoryDrainTimer%
	}

	Loop {
		If !(GetKeyState(_hotkey, "P")) {
			ControlSend, ,{%_hotkey% up}, A
			Break
		}
		Sleep, 10
	}
}

ResetLastPressedKey:
	LastPressedKey := 0
Return

Reload:
	Reload
Return

Exit:
	ExitApp
Return