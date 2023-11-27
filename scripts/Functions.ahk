#SingleInstance Force
#NoEnv
global MidiIndex := 0
global Track1 := []
global startTime
global endTime
;------------------------------- Functions ------------------------------;
;------- Refresh List View Contents ------;
ReloadSongs:
	; This cross references file names in the csv folder with file names in the data file
	; With get the file date from the csv folder and the number of players from the data file
	GuiControl, Show, MidiPlayer
	Gui, 1:Default
	LV_Delete()
	Data := []
	Loop, read, Data.csv
	{
		Loop, parse, A_LoopReadLine, `,
		{
			Data.Push(A_LoopField)
		}
	}

	Loop, Csv\*.*
	{
		SplitPath, A_LoopFileName, OutFileName,, OutExtension
		NoExt := StrReplace(A_LoopFileName, ".csv" , "")
		DataLen := Data.Length()
		Loop %DataLen%
		{
			if (Data[A_Index] == noExt)
			{
				FormatTime, FileDate, %A_LoopFileTimeCreated%, MM-dd-yy
				LV_Add("", noExt, Data[A_Index+1], FileDate)
				LV_ModifyCol(2, "Integer")
			}
		}
	}
return

;------- Remake New Song GUI ------;
NewNewSongGUI:
	Gui,NewSong:Add,Text,x0 y3 w50 h20,Title :
	Gui,NewSong:Add,Edit,x30 y0 w170 h20 vNewSongTitle,
	Gui,NewSong:Add,Text,x0 y20 w100 h20,Players :
	Gui,NewSong:Add,Button,x80 y20 w20 h20 gPlayersExplanation,?
	Gui,NewSong:Add,DropDownList,x100 y20 w100 h100 vNumberPlayers, 1||2|3|4|5
	Gui,NewSong:Add,Text,x0 y40 w100 h20,Tempo Modifier :
	Gui,NewSong:Add,DropDownList,x100 y40 w100 h100 vTempoModifier, -10|-9|-8|-7|-6|-5|-4|-3|-2|-1|0||1|2|3|4|5|6|7|8|9|10
	Gui,NewSong:Add,Button,x80 y40 w20 h20 gTempoExplanation,?
	Gui,NewSong:Add,Text,x0 y75 w100 h20,Description :
	Gui,NewSong:Add,Button,x80 y75 w20 h20 gDescriptionExplanation,?
	Gui,NewSong:Add,Edit,x100 y60 w100 h50 vSongDescription,
	Gui,NewSong:Add,Button,x0 y110 w50 h50 gFileSelectButton,Import Midi
	Gui,NewSong:Add,Button,x70 y160 w75 h40 gNewSongOkButton Center,Add song
return

;------- Manage List Click Events ------;
MyListView:
Critical ;Fixes known issue with Autohotkey GuiEvent Listener
	if A_GuiEvent = I
	{
		LV_GetText(RowText, A_EventInfo) ; Get the text from the row's first field.
		HighlightedSong := RowText
		Data := []
		Loop, read, Data.csv
		{
			Loop, parse, A_LoopReadLine, `,
			{
				Data.Push(A_LoopField)
			}
		}
		DataLen := Data.Length()
		Loop %DataLen%
		{
			if (Data[A_Index] == RowText)
			{
				GuiControl,, SongDescription, % Data[A_Index+3]
			}
		}
	}
return

RefreshPlayers:
	Sleep, 150
	ControlSend,, {9}, Player1
	ControlSend,, {9}, Player2
	ControlSend,, {9}, Player3
	ControlSend,, {9}, Player4
	ControlSend,, {9}, Player5
	Sleep, 150
	ControlSend,, {9}, Player1
	ControlSend,, {9}, Player2
	ControlSend,, {9}, Player3
	ControlSend,, {9}, Player4
	ControlSend,, {9}, Player5
	Sleep, 150
	ControlSend,, {0}, Player1
	ControlSend,, {0}, Player2
	ControlSend,, {0}, Player3
	ControlSend,, {0}, Player4
	ControlSend,, {0}, Player5
return

;------- Song Player ------;
SongPlayer:
	Gui, Submit, Nohide
	NumberOfPlayers := 1

	; Make adjustments to Default Tempo based on data from Data.csv
	Data := []
	Loop, read, Data.csv
	{
		Loop, parse, A_LoopReadLine, `,
		{
			Data.Push(A_LoopField)
		}
	}
	DataLen := Data.Length()
	Loop %DataLen%
	{
		if (Data[A_Index] == HighlightedSong)
		{
			NumberOfPlayers := Data[A_Index+1]
			DefaultTempo += (Data[A_Index+2] * 0.05)*-1
		}
	}

	Tempo := [], TempoDuration := [], IsNotNote := [], VolumesDif := [], DelayToPlay := [], Volumes := [], Durations := [], Notes := [], TrackHolder := [], KeyState := []
	postnotes := false, trackcounter = 0
	Loop, %ArrayIndex%
	{
		Volume%ArrayIndex% := ""
		Durations%ArrayIndex% := ""
		Notes%ArrayIndex% := ""
		TrackHolder%ArrayIndex% := ""
		KeyState%ArrayIndex% := ""
	}
	ArrayIndex = 1
	Loop, read, Csv/%HighlightedSong%.csv
	{
		subIndex = 0
		record := false
		tempoer := false
		Loop, parse, A_LoopReadLine, `,
		{
			subIndex++
			var = %A_Loopfield%
			if(subIndex = 1){
				track = %var%
			}
			if(subIndex = 2){
				duration = %var%
			}
			if (subIndex = 3 && var = "Note_on_c"){
				record := true
			}
			if (subIndex = 3 && var = "Tempo"){
				tempoer := true
			}
			if (subIndex = 5) {
				if(var = 48){
					note = z
				}
				if(var = 50){
					note = x
				}
				if(var = 52){
					note = c
				}
				if(var = 53){
					note = v
				}
				if(var = 55){
					note = b
				}
				if(var = 57){
					note = n
				}
				if(var = 59){
					note = m
				}
				if(var = 60){
					note = a
				}
				if(var = 62){
					note = s
				}
				if(var = 64){
					note = d
				}
				if(var = 65){
					note = f
				}
				if(var = 67){
					note = g
				}
				if(var = 69){
					note = h
				}
				if(var = 71){
					note = j
				}
				if(var = 72){
					note = q
				}
				if(var = 74){
					note = w
				}
				if(var = 76){
					note = e
				}
				if(var = 77){
					note = r
				}
				if(var = 79){
					note = t
				}
				if(var = 81){
					note = y
				}
				if(var = 83){
					note = u
				}
				if(var = 84){
					note = i
				}
			}
			if (subIndex = 4 && tempoer = true){
				tempy = %var%
				if (duration != prevDuration){
					if((postnotes = false && pzero = 0) || (postnotes = true)){
						outTemp := "B"
						outTemp .= tempy
						Tempo.Push(outTemp)
						TempoDuration.Push(duration)
						IsNotNote.Push(" ")
						TempoIndex++
						prevDuration := duration
						pzero = 1
					}
				}
			}
			if(subIndex = 6 && record = true && var > 0){
				postnotes := true
				var2 := Round(var, -1)
				Volume%ArrayIndex% := var2
				Durations%ArrayIndex% := duration
				Notes%ArrayIndex% := note
				TrackHolder%ArrayIndex% := track
				KeyState%ArrayIndex% := keyState
				ArrayIndex++
			}
		}
	}
	
	if (NumberOfPlayers = 1)
		GoSub, OnePlayer
	else
		GoSub TrackPlayer
return

TrackPlayer:
	Loop 25
	{
		Track%A_Index% := []
		Track%A_Index%Vol := []
		Track%A_Index%Duration := []
	}
	ArrayIndex += 1
	Loop %ArrayIndex%
	{
		tracker := TrackHolder%A_Index%
		note := Notes%A_Index%
		Track%tracker%.Push(note)
		dur := Durations%A_Index%
		Track%tracker%Duration.Push(dur)
		vol := Volume%A_Index%
		Track%tracker%Vol.Push(vol)
		if (trackcounter != tracker){
			trackcounter++
		}
	}

	;;;;;;;;;;;;;;The below section merges notes on occurring on the same beat, adds octave swaps, and replaces the notes with keys mapped for output to specific windows. This process is repeated across all 5 Tracks;;;;;;;;;;;;;

	;;;;;;;;;;;Track1;;;;;;;;;;
	Temp := [], TempDuration := []
	OutNotes := Combine(Track1Duration, Track1, TempDuration, Temp)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()
	Track1 := AddSwaps(Track1)
    OutNotes := OpportunisticSwaps(Track1, Track1Duration)
    Track1Duration := OutNotes.alpha.Clone()
	Track1 := OutNotes.num.Clone()
	replacements := [["z", "1"], ["x", "2"], ["c", "3"], ["v", "4"], ["b", "5"], ["n", "6"], ["m", "7"], ["a", "1"], ["s", "2"], ["d", "3"], ["f", "4"], ["g", "5"], ["h", "6"], ["j", "7"], ["q", "1"], ["w", "2"], ["e", "3"], ["r", "4"], ["t", "5"], ["y", "6"], ["u", "7"], ["i", "8"]]
	Track1 := replaceChars(Track1, replacements)
	;;;;;;;;;;;Track1;;;;;;;;;;

	;;;;;;;;;;;Track2;;;;;;;;;;
	OutNotes := Combine(Track2Duration, Track2, TempDuration, Temp)
	Track2Duration := OutNotes.num.Clone()
	Track2 := OutNotes.alpha.Clone()
	Track2 := AddSwaps(Track2)
    OutNotes := OpportunisticSwaps(Track2, Track2Duration)
    Track2Duration := OutNotes.alpha.Clone()
	Track2 := OutNotes.num.Clone()
	replacements := [["z", "q"], ["x", "w"], ["c", "e"], ["v", "r"], ["b", "t"], ["n", "y"], ["m", "u"], ["a", "q"], ["s", "w"], ["d", "e"], ["f", "r"], ["g", "t"], ["h", "y"], ["j", "u"], ["q", "q"], ["w", "w"], ["e", "e"], ["r", "r"], ["t", "t"], ["y", "y"], ["u", "u"], ["i", "i"], ["9", "o"], ["0", "p"], ["8", "i"]]
	Track2 := replaceChars(Track2, replacements)
	;;;;;;;;;;;Track2;;;;;;;;;;

	;;;;;;;;;;;Track3;;;;;;;;;;
	OutNotes := Combine(Track3Duration, Track3, TempDuration, Temp)
	Track3Duration := OutNotes.num.Clone()
	Track3 := OutNotes.alpha.Clone()
	Track3 := AddSwaps(Track3)
    OutNotes := OpportunisticSwaps(Track3, Track3Duration)
    Track3Duration := OutNotes.alpha.Clone()
	Track3 := OutNotes.num.Clone()
	replacements := [["z", "a"], ["x", "s"], ["c", "d"], ["v", "f"], ["b", "g"], ["n", "h"], ["m", "j"], ["a", "a"], ["s", "s"], ["d", "d"], ["f", "f"], ["g", "g"], ["h", "h"], ["j", "j"], ["q", "a"], ["w", "s"], ["e", "d"], ["r", "f"], ["t", "g"], ["y", "h"], ["u", "j"], ["i", "k"], ["9", "l"], ["0", "m"], ["8", "k"]]
	Track3 := replaceChars(Track3, replacements)
	;;;;;;;;;;;Track3;;;;;;;;;;

	;;;;;;;;;;;Track4;;;;;;;;;;
	OutNotes := Combine(Track4Duration, Track4, TempDuration, Temp)
	Track4Duration := OutNotes.num.Clone()
	Track4 := OutNotes.alpha.Clone()
	Track4 := AddSwaps(Track4)
    OutNotes := OpportunisticSwaps(Track4, Track4Duration)
    Track4Duration := OutNotes.alpha.Clone()
	Track4 := OutNotes.num.Clone()
	replacements := [["z", "à"], ["x", "á"], ["c", "â"], ["v", "ã"], ["b", "ä"], ["n", "å"], ["m", "æ"], ["a", "à"], ["s", "á"], ["d", "â"], ["f", "ã"], ["g", "ä"], ["h", "å"], ["j", "æ"], ["q", "à"], ["w", "á"], ["e", "â"], ["r", "ã"], ["t", "ä"], ["y", "å"], ["u", "æ"], ["i", "ç"], ["9", "è"], ["0", "é"], ["8", "ç"]]
	Track4 := replaceChars(Track4, replacements)
	;;;;;;;;;;;Track4;;;;;;;;;;

	;;;;;;;;;;;Track5;;;;;;;;;;
	OutNotes := Combine(Track5Duration, Track5, TempDuration, Temp)
	Track5Duration := OutNotes.num.Clone()
	Track5 := OutNotes.alpha.Clone()
	Track5 := AddSwaps(Track5)
    OutNotes := OpportunisticSwaps(Track5, Track5Duration)
    Track5Duration := OutNotes.alpha.Clone()
	Track5 := OutNotes.num.Clone()
	replacements := [["z", "ð"], ["x", "ñ"], ["c", "ò"], ["v", "ó"], ["b", "ô"], ["n", "õ"], ["m", "ö"], ["a", "ð"], ["s", "ñ"], ["d", "ò"], ["f", "ó"], ["g", "ô"], ["h", "õ"], ["j", "ö"], ["q", "ð"], ["w", "ñ"], ["e", "ò"], ["r", "ó"], ["t", "ô"], ["y", "õ"], ["u", "ö"], ["i", "ø"], ["9", "ù"], ["0", "ú"], ["8", "ø"]]
	Track5 := replaceChars(Track5, replacements)
	;;;;;;;;;;;Track1;;;;;;;;;;

	;;;;;;;;;merge tracks;;;;;;;;;
	OutNotes := Combine(Track1Duration, Track1, Track2Duration, Track2)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track3Duration, Track3)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track4Duration, Track4)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track5Duration, Track5)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutArrays := CombineFlags(Track1Duration, Track1, TempoDuration, Tempo, dupes = false)
	TimeToPlay := OutArrays.num.Clone()
	KeysToPlay := OutArrays.alpha.Clone()
	;;;;;;;;;merge tracks;;;;;;;;;

	timeLength := TimeToPlay.Length()
	Loop %timeLength%
	{
		nextIndex := A_Index + 1
		par1 := TimeToPlay[A_Index]
		par2 := TimeToPlay[nextIndex]
		par3 := par2 - par1
		par3 := par3 / 500000
		DelayToPlay.Push(par3)
	}
	;Primary song-playing loop
    songLength := KeysToPlay.Length()
	Loop %songLength% {
		item := KeysToPlay[A_Index]
		first := SubStr(item, 1, 1)
		if (first == "B"){
			tempotemp := SubStr(item, 2)
			sleepDuration := DelayToPlay[A_Index] * tempotemp * DefaultTempo
			Sleep, %sleepDuration%
		}
		else
		{
			nextKey := KeysToPlay[A_Index]
			Loop, parse, nextKey
			{
				var := A_LoopField
				if (var = 1){
					ControlSend,, {1}, Player1
				}
				else if (var = 2){
					ControlSend,, {2}, Player1
				}
				else if (var = 3){
					ControlSend,, {3}, Player1
				}
				else if (var = 4){
					ControlSend,, {4}, Player1
				}
				else if (var = 5){
					ControlSend,, {5}, Player1
				}
				else if (var = 6){
					ControlSend,, {6}, Player1
				}
				else if (var = 7){
					ControlSend,, {7}, Player1
				}
				else if (var = 8){
					ControlSend,, {8}, Player1
				}
				else if (var = 9){
					ControlSend,, {9}, Player1
				}
				else if (var = 0){
					ControlSend,, {0}, Player1
				}
				else if (var = "q"){
					ControlSend,, {1}, Player2
				}
				else if (var = "w"){
					ControlSend,, {2}, Player2
				}
				else if (var = "e"){
					ControlSend,, {3}, Player2
				}
				else if (var = "r"){
					ControlSend,, {4}, Player2
				}
				else if (var = "t"){
					ControlSend,, {5}, Player2
				}
				else if (var = "y"){
					ControlSend,, {6}, Player2
				}
				else if (var = "u"){
					ControlSend,, {7}, Player2
				}
				else if (var = "i"){
					ControlSend,, {8}, Player2
				}
				else if (var = "o"){
					ControlSend,, {9}, Player2
				}
				else if (var = "p"){
					ControlSend,, {0}, Player2
				}
				else if (var = "a"){
					ControlSend,, {1}, Player3
				}
				else if (var = "s"){
					ControlSend,, {2}, Player3
				}
				else if (var = "d"){
					ControlSend,, {3}, Player3
				}
				else if (var = "f"){
					ControlSend,, {4}, Player3
				}
				else if (var = "g"){
					ControlSend,, {5}, Player3
				}
				else if (var = "h"){
					ControlSend,, {6}, Player3
				}
				else if (var = "j"){
					ControlSend,, {7}, Player3
				}
				else if (var = "k"){
					ControlSend,, {8}, Player3
				}
				else if (var = "l"){
					ControlSend,, {9}, Player3
				}
				else if (var = "m"){
					ControlSend,, {0}, Player3
				}
				else if (var = "à"){
					ControlSend,, {1}, Player4
				}
				else if (var = "á"){
					ControlSend,, {2}, Player4
				}
				else if (var = "â"){
					ControlSend,, {3}, Player4
				}
				else if (var = "ã"){
					ControlSend,, {4}, Player4
				}
				else if (var = "ä"){
					ControlSend,, {5}, Player4
				}
				else if (var = "å"){
					ControlSend,, {6}, Player4
				}
				else if (var = "æ"){
					ControlSend,, {7}, Player4
				}
				else if (var = "ç"){
					ControlSend,, {8}, Player4
				}
				else if (var = "è"){
					ControlSend,, {9}, Player4
				}
				else if (var = "é"){
					ControlSend,, {0}, Player4
				}
				else if (var = "ð"){
					ControlSend,, {1}, Player5
				}
				else if (var = "ñ"){
					ControlSend,, {2}, Player5
				}
				else if (var = "ò"){
					ControlSend,, {3}, Player5
				}
				else if (var = "ó"){
					ControlSend,, {4}, Player5
				}
				else if (var = "ô"){
					ControlSend,, {5}, Player5
				}
				else if (var = "õ"){
					ControlSend,, {6}, Player5
				}
				else if (var = "ö"){
					ControlSend,, {7}, Player5
				}
				else if (var = "ø"){
					ControlSend,, {8}, Player5
				}
				else if (var = "ù"){
					ControlSend,, {9}, Player5
				}
				else if (var = "ú"){
					ControlSend,, {0}, Player5
				}
			}
			sleepDuration := DelayToPlay[A_Index] * tempotemp * DefaultTempo
			Sleep, %sleepDuration%
		}
	}
	Gosub, RefreshPlayers
	Reload
return

OpportunisticSwaps(a1, a2)
{
    a3 := [], a4 := []
    len := a1.Length()
    Loop %len%
        {
            if (A_Index != 1)
                {
                    if (InStr(a1[A_Index], "9", false, 1, 1) == 1)
                        {
                            dif := a2[A_Index] - a2[A_Index-1] 
                            if (dif >= Delay)
                                {
                                    a3.Push("9")
                                    addSleep := Floor(a2[A_Index-1] + (dif/2))
                                    a4.Push(addSleep)
                                    ReplacedStr := StrReplace(a1[A_Index], "9",,,1)
                                    a3.Push(ReplacedStr)
                                    a4.Push(a2[A_Index])
                                }
                            Else
                                {
                                    a3.Push(a1[A_Index])
                                    a4.Push(a2[A_Index])
                                }
                        }
                    else if (InStr(a1[A_Index], "0", false, 1, 1) == 1)
                        {
                            dif := a2[A_Index] - a2[A_Index-1] 
                            if (dif >= Delay)
                                {
                                    a3.Push("0")
                                    addSleep := Floor(a2[A_Index-1] + (dif/2))
                                    a4.Push(addSleep)
                                    ReplacedStr := StrReplace(a1[A_Index], "0",,,1)
                                    a3.Push(ReplacedStr)
                                    a4.Push(a2[A_Index])
                                }
                            Else
                                {
                                    a3.Push(a1[A_Index])
                                    a4.Push(a2[A_Index])
                                }
                        }
                    Else
                        {
                            a3.Push(a1[A_Index])
                            a4.Push(a2[A_Index])
                        }
                }
                Else
                    {
                        a3.Push(a1[A_Index])
                        a4.Push(a2[A_Index])
                    }
        }
        return {num: a3, alpha: a4}
}

AddSwaps(a1)
{
	len := a1.Length()
	octave = 1
	set1 := "asdfghjqwertyuizxcvbnm"
	set2 := "zxcvbnmasdfghjkq"
	set3 := "qwertyuiasdfghj"
	a3 := []
	Loop %len% {
		notes := a1[A_Index]
		newStr := ""

		if (octave = 1)
		{
			Loop, parse, set1
			{
				i := A_LoopField
				if notes contains %i%
				{
					if i contains a
						{
							if notes contains z,x,c,v,b,n,m
								{
									if notes not contains s,d,f,g,h,j
										{
											if (octave == 1)
												{
													octave -= 1
													newStr .= "9"
												}
												newStr .= "8"
										}
										Else
											{
												newStr .= i
											}
								}
							Else
								{
									newStr .= i
								}
						}
					else if i contains w,e,r,t,y,u,i
					{
						if (octave = 1)
						{
							octave += 1
							newStr .= "0"
						}
						newStr .= i
					}
					else if i contains z,x,c,v,b,n,m
					{
						if (octave = 1)
						{
							octave -= 1
							newStr .= "9"
						}
						newStr .= i
					}
					else if i contains q
					{
						if notes contains w,e,r,t,y,u,i
							{
								if (octave = 1)
									{
										octave += 1
										newStr .= "0"
									}
									newStr .= i
							}
						Else
							{
								newStr .= "8"
							}
					}
					else
					{
						newStr .= i
					}
				}
			}
		}
		else if (octave = 0)
		{
			Loop, parse, set2
			{
				i := A_LoopField
				if notes contains %i%
				{
					if i contains a
						{
							if notes contains s,d,f,g,h,j
								{
									if (octave = 0)
										{
											octave += 1
											newStr .= "0"
										}
										newStr .= i
								}
							Else
								{
									newStr .= "8"
								}
						}
					else if i contains q
						{
							if (octave == 0)
								{
									octave += 1
									newStr .= "0"
								}
								newStr .= "8"
						}
					else if i contains s,d,f,g,h,j,k
					{
						if (octave == 0)
						{
							octave += 1
							newStr .= "0"
						}
						newStr .= i
					}
					else
					{
						newStr .= i
					}
				}
			}
		}
		else if (octave = 2)
		{
			Loop, parse, set3
			{
				i := A_LoopField
				if notes contains %i%
				{
					if i contains q
						{
							if notes contains a,s,d,f,g,h,j
								{
									if notes not contains w,e,r,t,y,u,i
										{
											if (octave = 2)
												{
													octave -= 1
													newStr .= "9"
												}
												newStr .= "8"
										}
										Else
											{
												newStr .= i
											}
								}
							Else
								{
									newStr .= i
								}
						}
					else if i contains a,s,d,f,g,h,j
					{
						if (octave == 2)
						{
							octave -= 1
							newStr .= "9"
						}
						newStr .= i
					}
					else
					{
						newStr .= i
					}
				}
			}
		}
		a3.Push(newStr)
	}
	return a3
}

replaceChars(a1, a2)
{
	len := a1.Length()
	a3 := []
	Loop %len%
	{
		var := a1[A_Index]

		For inputVar, outputVar in a2
		{
			var := StrReplace(var, outputVar.1, outputVar.2)
		}
		a3.Push(var)
	}
	return a3
}

Combine(a1, a2, a3, a4) {
	a25 := [], a26 := [], t := []
	for k,v in a1
		if(v != "")
			list .= v "|"
	for k,v in a3
		if(v != "")
			list .= v "|"
	list := LTrim(list, "|")
	Sort, list, UND|
	a25 := StrSplit(list, "|")
	for k,v in a1
		t[a1[k]] := a2[k] . t[v]
	for k,v in a3
		t[a3[k]] := a4[k] . t[v]
	for k,v in t ; transfer associative array to simple array
		a26.Push(v)
	return {num: a25, alpha: a26}
}

CombineFlags(a1, a2, a3, a4, dupes) {
	a5 := [], a6 := [], t := []
	for k,v in a1
		if(v != "")
			list .= v "|"
	for k,v in a3
		if(v != "")
			list .= v "|"
	list := LTrim(list, "|")
	if (!dupes){
		Sort, list, ND|
	}else{
		Sort, list, UND|
	}
	a5 := StrSplit(list, "|")
	for k,v in a1
		t[a1[k]] := a2[k] . t[v]

	adjust = 0
	for k,v in a3{
		checknull := t[v]
		x := v + adjust
		if (x =){
			x := x - 1
		}
		if(checknull =){
			if(a4[k] != ""){
				t[x] := a4[k]
			}
		}else{
			if(a4[k] != ""){
				t.Insert(x - 1, a4[k])
				adjust++
			}

		}
	}
	for k,v in t
		a6.Push(v)
	return {num: a5, alpha: a6}
}

;-------------------------------------------------- SINGLEPLAYER FUNCTIONS -------------------------------------------------------;
OnePlayer:
	Loop 25
	{
		Track%A_Index% := []
		Track%A_Index%Vol := []
		Track%A_Index%Duration := []
	}
	ArrayIndex += 1
	Loop %ArrayIndex%
	{
		tracker := TrackHolder%A_Index%
		note := Notes%A_Index%
		Track%tracker%.Push(note)
		dur := Durations%A_Index%
		Track%tracker%Duration.Push(dur)
		vol := Volume%A_Index%
		Track%tracker%Vol.Push(vol)
		if (trackcounter != tracker){
			trackcounter++
		}
	}
	;;;;;;;;;;;;;;The below section merges notes on occurring on the same beat, adds octave swaps, and replaces the notes with keys mapped for output to specific windows. This process is repeated across all 5 Tracks;;;;;;;;;;;;;

	;;;;;;;;;;;Track1;;;;;;;;;;
	Temp := [], TempDuration := []
	OutNotes := Combine(Track1Duration, Track1, TempDuration, Temp)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()
	;;;;;;;;;;;Track1;;;;;;;;;;

	;;;;;;;;;;;Track2;;;;;;;;;;
	OutNotes := Combine(Track2Duration, Track2, TempDuration, Temp)
	Track2Duration := OutNotes.num.Clone()
	Track2 := OutNotes.alpha.Clone()
	;;;;;;;;;;;Track2;;;;;;;;;;

	;;;;;;;;;;;Track3;;;;;;;;;;
	OutNotes := Combine(Track3Duration, Track3, TempDuration, Temp)
	Track3Duration := OutNotes.num.Clone()
	Track3 := OutNotes.alpha.Clone()
	;;;;;;;;;;;Track3;;;;;;;;;;

	;;;;;;;;;;;Track4;;;;;;;;;;
	OutNotes := Combine(Track4Duration, Track4, TempDuration, Temp)
	Track4Duration := OutNotes.num.Clone()
	Track4 := OutNotes.alpha.Clone()
	;;;;;;;;;;;Track4;;;;;;;;;;

	;;;;;;;;;;;Track5;;;;;;;;;;
	OutNotes := Combine(Track5Duration, Track5, TempDuration, Temp)
	Track5Duration := OutNotes.num.Clone()
	Track5 := OutNotes.alpha.Clone()
	;;;;;;;;;;;Track1;;;;;;;;;;

	;;;;;;;;;merge tracks;;;;;;;;;
	OutNotes := Combine(Track1Duration, Track1, Track2Duration, Track2)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track3Duration, Track3)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track4Duration, Track4)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	OutNotes := Combine(Track1Duration, Track1, Track5Duration, Track5)
	Track1Duration := OutNotes.num.Clone()
	Track1 := OutNotes.alpha.Clone()

	Track1 := AddSwapsOnePlayer(Track1)
	replacements := [["z", "1"], ["x", "2"], ["c", "3"], ["v", "4"], ["b", "5"], ["n", "6"], ["m", "7"], ["a", "1"], ["s", "2"], ["d", "3"], ["f", "4"], ["g", "5"], ["h", "6"], ["j", "7"], ["q", "1"], ["w", "2"], ["e", "3"], ["r", "4"], ["t", "5"], ["y", "6"], ["u", "7"], ["i", "8"]]
	Track1 := replaceChars(Track1, replacements)
	
	OutArrays := CombineFlags(Track1Duration, Track1, TempoDuration, Tempo, dupes = false)
	Track1Duration := OutArrays.num.Clone()
	Track1 := OutArrays.alpha.Clone()

	;;;;;;;;;merge tracks;;;;;;;;;
	timeLength := Track1Duration.Length()
	Loop %timeLength%
	{
		nextIndex := A_Index + 1
		par1 := Track1Duration[A_Index]
		par2 := Track1Duration[nextIndex]
		par3 := par2 - par1
		par3 := par3 / 500000
		DelayToPlay.Push(par3)
	}

	counter := new SecondCounter()
	;Primary song-playing loop
	songLength := Track1.Length()
	tempotemp := 1
	startTime := 0
	endTime := 0
	Loop %songLength% {
		MidiIndex := A_Index
		item := Track1[A_Index]
		first := SubStr(item, 1, 1)
		if (first == "B"){
			tempotemp := SubStr(item, 2)
			NotesToPlay("", tempotemp, DefaultTempo, DelayToPlay[A_Index], counter)
		}
		else
		{
			nextKey := Track1[A_Index]
			;DelayToPlay[A_Index] := CheckNextForDupes(Track1[A_Index+1], tempotemp, DefaultTempo, DelayToPlay[A_Index])
			containsDupes := DupeSeparation(nextKey, tempotemp, DefaultTempo, DelayToPlay[A_Index], counter)
			if (!containsDupes)
				NotesToPlay(nextKey, tempotemp, DefaultTempo, DelayToPlay[A_Index], counter)
		}
	}
	Reload
return

DupeSeparation(notes, tempotemp, DefaultTempo, DelayToPlay, counter)
{

	StringReplace, notes, notes, 1, 1, UseErrorLevel
	ones := ErrorLevel
	StringReplace, notes, notes, 2, 2, UseErrorLevel
	twos := ErrorLevel
	StringReplace, notes, notes, 3, 3, UseErrorLevel
	threes := ErrorLevel
	StringReplace, notes, notes, 4, 4, UseErrorLevel
	fours := ErrorLevel
	StringReplace, notes, notes, 5, 5, UseErrorLevel
	fives := ErrorLevel
	StringReplace, notes, notes, 6, 6, UseErrorLevel
	sixes := ErrorLevel
	StringReplace, notes, notes, 7, 7, UseErrorLevel
	sevens := ErrorLevel
	StringReplace, notes, notes, 8, 8, UseErrorLevel
	eights := ErrorLevel
	dupes := false
	;Check for duplicates
	if (ones > 1) or (twos > 1) or (threes > 1) or (fours > 1) or (fives > 1) or (sixes > 1) or (sevens > 1) or (eights > 1)
		{
			dupes := true
			NewEntries := []
			toSub := 0
			if InStr(notes, "0")
				{
					Loop, parse, notes, "0"
						{
							entry := A_LoopField
							NewEntries.Push(entry)
						}
					EntriesLen := NewEntries.Length()
					Loop %EntriesLen%
						{
							if (A_Index != EntriesLen)
								{
									entry := NewEntries[A_Index] . "0"
									toSub += 75/tempotemp
									NotesToPlay(entry, tempotemp, DefaultTempo, 75/tempotemp, counter)
								}
							else
								{
									entry := NewEntries[A_Index]
									;DelayToPlay -= toSub
									NotesToPlay(entry, tempotemp, DefaultTempo, DelayToPlay, counter)
								}
						}
					
				}
			else if InStr(notes, "9")
				{
					Loop, parse, notes, "9"
						{
							entry := A_LoopField
							NewEntries.Push(entry)
						}
					EntriesLen := NewEntries.Length()
					Loop %EntriesLen%
						{
							if (A_Index != EntriesLen)
								{
									entry := NewEntries[A_Index] . "9"
									toSub += 75/tempotemp
									NotesToPlay(entry, tempotemp, DefaultTempo, 75/tempotemp, counter)
								}
							else
								{
									entry := NewEntries[A_Index]
									DelayToPlay -= toSub
									NotesToPlay(entry, tempotemp, DefaultTempo, DelayToPlay, counter)
								}
						}
				}
		}
		return dupes
}

AddSwapsOnePlayer(a1)
{
	len := a1.Length()
	octave = 1
	set1 := "asdfghjqwertyuizxcvbnm"
	set2 := "zxcvbnmasdfghjqwertyui"
	set3 := "qwertyuiasdfghjzxcvbnm"
	a3 := []
	Loop %len% {
		notes := a1[A_Index]
		nextNotes := a1[A_Index+1]
		newStr := ""

		;if the starting octave is the middle octave(1), sort starting with middle octave notes and then add any high/low octave notes and any required octave switches;
		;This is the most complicated octave for adding swaps since we'll have to handle cases where the chord crosses all three octaves and determine whether to play the chord from high to low or low to high
		;STEPS:
			;1) Check if the chord is a three octave chord
			;2) If Yes, determine whether to start low -> high or high -> low based on whether the next note contains low notes or high notes.
				;3) Default to Low -> high the case that it contains both high and low notes
		
		;Step 1)
		if (octave = 1)
		{
			isThreeOctaveChord := false
			; we ignore any middle octave notes as well as C(a) or c(q)
			if notes contains z,x,c,v,b,n,m
				if notes contains w,e,r,t,y,u,i
					isThreeOctaveChord := true
			if (isThreeOctaveChord)
			{
				; Step 2)
				if nextNotes contains w,e,r,t,y,u,i
				{
					if nextNotes not contains z,x,c,v,b,n,m
					{
						newStr .= "9"
						octave = 0
					}
				}	
				else if nextNotes contains z,x,c,v,b,n,m
				{
					if nextNotes not contains w,e,r,t,y,u,i
					{
						newStr .= "0"
						octave = 2
					}
					; Step 3)
					Else
					{
						newStr .= "9"
						octave = 0
					}
				}
				else
				{
					newStr .= "9"
					octave = 0
				}
			}
		}
		
		;Steps:
			;4) Check if notes contains the note "C"
				;5) Check if the chord is a low octave only chord.
					;6) If it is, then the C with be played as a low octave 8 instead of mid octave 1
					;7) In all other cases, the C will be played as a middle octave 1
			;8) Check if notes contains the note "c"
				;9) If notes contains any high octave notes, then the c will be played as a high octave 1
				;10) in all other cases the c will be played as a middle octave 8
		if (octave = 1)
		{
			Loop, parse, set1
			{
				i := A_LoopField
				if notes contains %i%
				{
					;4)
					if i contains a
					{
						;5)
						if notes contains z,x,c,v,b,n,m
							{
								if notes not contains s,d,f,g,h,j,q
									{
										;6)
										if (octave == 1)
											{
												octave -= 1
												newStr .= "9"
											}
											newStr .= "8"
									}
									;7)
									Else
									{
										newStr .= i
									}
							}
						Else
							{
								newStr .= i
							}
					}
					;8)
					else if i contains q
					{
						;9)
						if notes contains w,e,r,t,y,u,i
							{
								if (octave = 1)
									{
										octave += 1
										newStr .= "0"
									}
									newStr .= i
							}
						;10)
						Else
							{
								newStr .= "8"
							}
					}
					else if i contains w,e,r,t,y,u,i
					{
						if (octave = 1)
						{
							octave += 1
							newStr .= "0"
						}
						newStr .= i
					}
					else if i contains z,x,c,v,b,n,m
					{
						if (octave = 1)
						{
							octave -= 1
							newStr .= "9"
						}
						newStr .= i
					}
					else
					{
						newStr .= i
					}
				}
			}
		}
		else if (octave = 0)
		{
			Loop, parse, set2
			{
				i := A_LoopField
				if notes contains %i%
				{
					if i contains a
						{
							if notes contains s,d,f,g,h,j
								{
									if (octave = 0)
										{
											octave += 1
											newStr .= "0"
										}
										newStr .= i
								}
							Else
								{
									newStr .= "8"
								}
						}
					else if i contains s,d,f,g,h,j,k
					{
						if (octave == 0)
						{
							octave += 1
							newStr .= "0"
						}
						newStr .= i
					}
					else if i contains q
						{
							if notes not contains w,e,r,t,y,u,i
								{
									if (octave == 0)
										{
											octave += 1
											newStr .= "0"
										}
										newStr .= "8"
								}
							else
								{
									if (octave == 0)
										{
											octave += 2
											newStr .= "00"
										}
									else if (octave == 1)
										{
											octave += 1
											newStr .= "0"
										}
									newStr .= i
								}
						}
					else if i contains w,e,r,t,y,u,i
						{
							if (octave == 0)
								{
									octave += 2
									newStr .= "00"
								}
							else if (octave == 1)
								{
									octave += 1
									newStr .= "0"
								}
							newStr .= i
						}
					else
					{
						newStr .= i
					}
				}
			}
		}
		else if (octave = 2)
		{
			Loop, parse, set3
			{
				i := A_LoopField
				if notes contains %i%
				{
					if i contains q
						{
							if notes contains a,s,d,f,g,h,j
								{
									if notes not contains w,e,r,t,y,u,i
										{
											if (octave = 2)
												{
													octave -= 1
													newStr .= "9"
												}
												newStr .= "8"
										}
										Else
											{
												newStr .= i
											}
								}
							Else
								{
									newStr .= i
								}
						}
					else if i contains a,s,d,f,g,h,j
					{
						if (octave == 2)
						{
							octave -= 1
							newStr .= "9"
						}
						newStr .= i
					}
					else if i contains z,x,c,v,b,n,m
						{
							if (octave == 2)
								{
									octave -= 2
									newStr .= "99"
								}
							else if (octave == 1)
								{
									octave -= 1
									newStr .= "9"
								}
							newStr .= i
						}
					else
					{
						newStr .= i
					}
				}
			}
		}
		a3.Push(newStr)
	}
	return a3
}

NotesToPlay(nextKey, tempotemp, DefaultTempo, DelayToPlay, counter)
{
	counter.Stop()
	Loop, parse, nextKey
		{
			var := A_LoopField
			if (var = 1){
				ControlSend,, {1}, Guild Wars 2
			}
			else if (var = 2){
				ControlSend,, {2}, Guild Wars 2
			}
			else if (var = 3){
				ControlSend,, {3}, Guild Wars 2
			}
			else if (var = 4){
				ControlSend,, {4}, Guild Wars 2
			}
			else if (var = 5){
				ControlSend,, {5}, Guild Wars 2
			}
			else if (var = 6){
				ControlSend,, {6}, Guild Wars 2
			}
			else if (var = 7){
				ControlSend,, {7}, Guild Wars 2
			}
			else if (var = 8){
				ControlSend,, {8}, Guild Wars 2
			}
			else if (var = 9){
				DllCall("QueryPerformanceFrequency", "Int64*", 1)
				DllCall("QueryPerformanceCounter", "Int64*", startTime)
				dif := Floor((startTime - endTime)/10000)
				if (dif < Delay)
					{
						dif := Delay - dif
						Sleep, %dif%
					}
				DllCall("QueryPerformanceCounter", "Int64*", endTime)
				ControlSend,, {9}, Guild Wars 2
			}
			else if (var = 0){
				DllCall("QueryPerformanceFrequency", "Int64*", 1)
				DllCall("QueryPerformanceCounter", "Int64*", startTime)
				dif := Floor((startTime - endTime)/10000)
				if (dif < Delay)
					{
						dif := Delay - dif
						Sleep, %dif%
					}
				DllCall("QueryPerformanceCounter", "Int64*", endTime)
				ControlSend,, {0}, Guild Wars 2
			}
		}
		counter.Start()
		sleepDuration := DelayToPlay * tempotemp * DefaultTempo
		Sleep, %sleepDuration%
}

class SecondCounter {
    __New() {
        this.interval := 1
        this.count := 1
        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        ; Known limitation: SetTimer requires a plain variable reference.
        timer := this.timer
		this.count := 0
        SetTimer % timer, % this.interval
        ;ToolTip % "Counter started"
    }
    Stop() {
        ; To turn off the timer, we must pass the same object as before:
        timer := this.timer
		this.count := 0
        SetTimer % timer, Off
        ;ToolTip % "Counter stopped at " this.count
    }
    ; In this example, the timer calls this method:
    Tick() {
	this.count++
		if (this.count >= Delay2){
			first := SubStr(Track1[MidiIndex+1], 1, 1)
			if ((first = 0) || (first = 9))
			{
				ControlSend,, {%first%}, Guild Wars 2
				DllCall("QueryPerformanceCounter", "Int64*", endTime)6
				newStr := SubStr(Track1[MidiIndex+1], 2)
				Track1[MidiIndex+1] := newStr
			}
			this.Stop()
			this.count := 0
		}
    }
}
