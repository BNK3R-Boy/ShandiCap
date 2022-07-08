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

Process, Priority,, High

Global fnPresses := Func("Presses")
Global LastPressedKey
Global TF := A_Temp . "\ShandiCap\"
Global ICO := TF . "ShandiCap.ico"

If !FileExist(TF) {
	FileCreateDir, %TF%
	If !FileExist(ICO)
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
	_priorhotkey := StrReplace(A_PriorHotkey, "~*")

	if (_priorhotkey <> _hotkey or A_TimeSincePriorHotkey > 400)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, %_hotkey%
		return
	}

	; You double-pressed a key.
	Sleep, 300
	ControlSend,, {Shift down}, A
	Sleep, 300
	ControlSend,, {Shift up}, A
	KeyWait, %_hotkey%
}


Reload:
	Reload
Return

Exit:
	ExitApp
Return