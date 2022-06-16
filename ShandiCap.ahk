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

SetKeyDelay, 100, 300

Global fnPresses := Func("Presses")
Global LastPressedKey
Global timertime := -1 * (DllCall("GetDoubleClickTime") + 100) ; Get the doubleclicktime in milliseconds
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

	If (LastPressedKey) And (PressedKey == LastPressedKey)
		ControlSend, ,{%_hotkey% down}{Shift}, A
	Else
		LastPressedKey := PressedKey

	SetTimer, ResetPresses, %timertime%

	Loop {
		If !(GetKeyState(_hotkey, "P"))
			Return
		Sleep, 10
	}
}

ResetPresses:
	LastPressedKey := 0
Return

Reload:
	Reload
Return

Exit:
	ExitApp
Return