#SingleInstance Force
#NoEnv
;------------------------------------ Main Buttons ----------------------------------------;
InfoButton:
	Gui,Info:Show,w200 h220, Info
return

SettingsButton:
	Gui,SettingsGui:Show,w200 h200, Settings
return

RefreshButton:
	Gosub, ReloadSongs
return

NewButton:
	Gui,NewSong:Show,w200 h200, New Song
return

DeleteSongButton:
	MsgBox, 4, Confirm action, Are you sure you wish to delete the following song: %HighlightedSong%? (This will delete the csv, midi, and entry in the data file),
	IfMsgBox Yes
	{
		SelectedFile := A_WorkingDir "\Csv\" HighlightedSong ".csv"
		Datacsv := A_WorkingDir "\Data.csv"
		if FileExist(SelectedFile)
		{
			FileRecycle, %SelectedFile%
		}
		SelectedFile := A_WorkingDir "\Midi\" HighlightedSong ".mid"
		Datacsv := A_WorkingDir "\Data.csv"
		if FileExist(SelectedFile)
		{
			FileRecycle, %SelectedFile%
		}
		AdjustData := []
		Loop, read, Data.csv
		{
			AddEntry := true
			Loop, parse, A_LoopReadLine, `,
			{
				if (A_LoopField == HighlightedSong)
					AddEntry := false
			}
			if (AddEntry == true)
				AdjustData.Push(A_LoopReadLine)
		}
		datalen := AdjustData.Length()
		FileDelete, Data.csv
		FileContent =
		Loop %datalen%
			{
				if (A_Index != datalen)
					FileContent .= AdjustData[A_Index] . "`n"
				Else
					FileContent .= AdjustData[A_Index]
			}
		FileAppend, %FileContent%, Data.csv
		GoSub, ReloadSongs
	}
return

OpenEditorButton:
	Run, CsvEditor.ahk
return

TogglePlay:
	Stop := false
	Gosub, Songplayer
return

ControlsButton:
	Gui,ControlsExplanation:Show,w200 h150,Controls
return

SettingsSaveButton:
	Gui, Submit, Nohide
	Data := []
	Loop, read, Config.txt
		{
			Data.Push(A_LoopReadLine)
		}
	DataLen := Data.Length()
	FileDelete, Config.txt
	toAppend := ""
	Loop %DataLen%
		{
			entry := Data[A_Index]
			if (InStr(entry,"OctaveDelay"))
			{
				newline := "OctaveDelay," OctaveDelay "`n"
				toAppend .= newline
			}
			else if (InStr(entry,"AlwaysOnTop"))
			{
				newline := "AlwaysOnTop," AlwaysOnTop "`n"
				toAppend .= newline
			}
			else if (InStr(entry,"IsTransparent"))
			{
				newline := "IsTransparent," IsTransparent "`n"
				toAppend .= newline
			}
			else
			{
				if (A_Index = DataLen)
					newline := entry
				else
					newline := entry "`n"
				toAppend .= newline
			}
		}
	ClicksEnabled := ClicksSetting
	Delay := OctaveDelay
	Delay2 := Ceil(Delay/10)
	
	FileAppend, %toAppend%, Config.txt
	Reload
return

OctaveDelayExplanation:
	Gui,OctaveDelayExplanation:Show,w200 h150,Octave Delay Explanation
return

AlwaysOnTopExplanation:
	Gui,AlwaysOnTopExplanation:Show,w200 h150,AlwaysOnTop Explanation
return

TransparencyExplanation:
	Gui,TransparencyExplanation:Show,w200 h150,Transparency Explanation
return

;------------------------------------ New Song Buttons ----------------------------------------;
FileSelectButton:
	if (HasSelectedFile == true)
		{
			Gui, NewSong:Destroy
			Gosub, NewNewSongGUI
			Gui, NewSong:Show
		}
	FileSelectFile, SelectedFile, 1, %A_WorkingDir%\Midi, Open a file, Text Documents (*.mid; *.midi)
	SplitPath, SelectedFile, FileName,,FileExtension
	Gui,NewSong:Add,Text,x60 y130 w100 h20 vDisplayName, %FileName%
	HasSelectedFile := true
return

TempoExplanation:
	Gui,TempoExplanation:Show,w200 h150,Tempo Explanation
return

DescriptionExplanation:
	Gui,DescriptionExplanation:Show,w200 h150,Description Explanation
return

PlayersExplanation:
	Gui,PlayersExplanation:Show,w200 h150,Players Explanation
return

NewSongOkButton:
	Gui, Submit, Nohide
	;remove newline and comma characters for the csv file
	NewSongTitle := StrReplace(NewSongTitle, "`n", " ")
	NewSongTitle := StrReplace(NewSongTitle, ",", " ")
	;do the same thing with the description
	SongDescription := StrReplace(SongDescription, "`n", " ")
	SongDescription := StrReplace(SongDescription, ",", " ")

	;if the file doesn't exist in the midi folder, copy and paste it over with the NewSongTitle name
	;else overwrite the file with the NewSongTitle name
	FilePath := A_WorkingDir "\Midi\" FileName
	if !FileExist(A_WorkingDir "\Midi\" FileName)
	{
		NewPath := A_WorkingDir "\Midi\" NewSongTitle ".mid"
		FileCopy, %SelectedFile%, %NewPath%
	}
	Else
	{
		NewPath := A_WorkingDir "\Midi\" NewSongTitle ".mid"
		FileMove, %SelectedFile%, %NewPath%, 1
	}

	;Add new entry to Data.csv
	newEntry := "`n" NewSongTitle ", " NumberPlayers ", " TempoModifier ", " SongDescription
	FileAppend, %newEntry%, Data.csv

	;Convert Midi to Csv
	FileDelete, %NewSongTitle%.bat
	FileAppend, echo `%cd`%`r`n"./Midicsv.exe" "./Midi/%NewSongTitle%.mid" "./Csv/%NewSongTitle%.csv", %NewSongTitle%.bat
	Run, %NewSongTitle%.bat, Hide

	;Refresh GUI
	HasSelectedFile := false
	Gui, NewSong:Submit
	Gui, NewSong:Destroy
	Gosub, NewNewSongGUI
	Sleep, 2000
	FileDelete, %NewSongTitle%.bat
	msgbox, Done!
	Gosub, ReloadSongs
	Gui, Show,,GW2MM
return