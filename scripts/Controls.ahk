#SingleInstance Force
#NoEnv
;------------------------------- Controls ------------------------------;
F1::
	Stop := false
	Gosub, Songplayer
return

F2::
	pause, toggle
return

F3::
	Gosub, RefreshPlayers
	Gui, Show,,GW2MM
	Stop := true
return

F4::
	Gosub, RefreshPlayers
	ExitApp
return

F5::
	WinWaitActive, Guild Wars 2
	WinSetTitle, Guild Wars 2,,Player1
return

F6::
	WinWaitActive, Guild Wars 2
	WinSetTitle, Guild Wars 2,,Player2
return

F7::
	WinWaitActive, Guild Wars 2
	WinSetTitle, Guild Wars 2,,Player3
return

F8::
	WinWaitActive, Guild Wars 2
	WinSetTitle, Guild Wars 2,,Player4
return

F9::
	WinWaitActive, Guild Wars 2
	WinSetTitle, Guild Wars 2,,Player5
return

F10::
	DefaultTempo += 0.01
return

F11::
	DefaultTempo -= 0.01
return