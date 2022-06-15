#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#InstallKeybdHook

If (!A_IsAdmin) {
	SetEnv, UserInput, % DllCall( "GetCommandLine", "Str" )
	Run *RunAs %UserInput% ; (A_AhkPath is usually optional If the script has the .ahk extension.) You would typically check  first.
	ExitApp
}

SetEnv, TF, %A_Temp%\ShandiCap\
SetEnv, ICO, %TF%ShandiCap.ico

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

SetKeyDelay, 100, 400
SetEnv, wPresses, 0
SetEnv, aPresses, 0
SetEnv, sPresses, 0
SetEnv, dPresses, 0
SetEnv, LastPress, 0
SetEnv, DoubleClickTime, % 2 * DllCall("GetDoubleClickTime")	; Get the doubleclicktime in milliseconds
SetEnv, timertime, % DoubleClickTime * -1

Hotkey, ~*w, Presses
Hotkey, ~*a, Presses
Hotkey, ~*s, Presses
Hotkey, ~*d, Presses

Return

Presses:
	SetEnv, _hotkey, % StrReplace(A_ThisHotkey, "~*")
	SetEnv, LastPress, A_TickCount
	SetEnv, TimeBetweenPresses, A_TickCount - LastPress
	IfGreater, TimeBetweenPresses, DoubleClickTime, SetEnv, TimeBetweenPresses, 0
	IfGreater, %_hotkey%Presses, 2, GoSub, ResetPresses
	IfLessOrEqual, TimeBetweenPresses, DoubleClickTime, EnvAdd, %_hotkey%Presses, 1
	IfEqual, %_hotkey%Presses, 2, ControlSend, ,{%_hotkey% down}{Shift}, A

	SetTimer, ResetPresses, %timertime%

	Loop {
		If !(GetKeyState(_hotkey, "P"))
			Return
		Sleep 10
	}
Return

ResetPresses:
	SetEnv, wPresses, 0
	SetEnv, aPresses, 0
	SetEnv, sPresses, 0
	SetEnv, dPresses, 0
	SetEnv, LastPress, 0
Return

Reload:
	Reload
Return

Exit:
	ExitApp
Return