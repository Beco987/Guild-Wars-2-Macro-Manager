#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#singleinstance force
ListLines Off
Process, Priority, , R
SetBatchLines, -1
SetKeyDelay, 0
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
StringCaseSense, On

Delay = 240
count = 1
TrackHolder := [], Notes := [], Durations := [], Volume := [], VolumesDif := [], Delay := [], ToPlay := [], KeyState := [], Tempo := [], TempoDuration := [], IsNotNote := [], DelayToPlay := [], Octaves := [], global OctaveSheet := [], ArrayIndex := 0, TempoIndex := 0, DefaultTempo = 1, pzero = 0
trackcount = 1, songLength = 0, HighlightedSong := ""
DisplayName := ""
EnableClicks := 4
HasSelecetedFiled := false
Playing := 0

;Read Config to get the Octave Delay variable
Data := []
Loop, read, Config.txt
{
    Loop, parse, A_LoopReadLine, `,
    {
        Data.Push(A_LoopField)
    }
}
DataLen := Data.Length()
Loop %DataLen%
    {
        if (Data[A_Index] == "OctaveDelay")
            {
                OctaveDelay := Data[A_Index+1]
            }	
        if (Data[A_Index] == "AlwaysOnTop")
            {
                AlwaysOnTop := Data[A_Index+1]
            }	
        if (Data[A_Index] == "IsTransparent")
            {
                IsTransparent := Data[A_Index+1]
            }	
    }
global Delay := OctaveDelay
global Delay2 := Ceil(Delay/10)
global TransparentEnabled := IsTransparent
global OnTopEnabled := AlwaysOnTop

#Include, scripts/GUI.ahk

Gosub, ReloadSongs

#Include, scripts/Controls.ahk

#Include, scripts/Buttons.ahk

#Include, scripts/Functions.ahk

GuiClose:
ExitApp