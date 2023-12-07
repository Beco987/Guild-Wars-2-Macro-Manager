#SingleInstance 
F1=Data.csv
BeforeNames := []
AfterNames := []
TestString = col1,col2,col3,col4`nname,players,tempo,description
IfNotExist, %F1% 
  FileAppend,%TestString%, %F1% 

FileRead, FileContent, %F1%
newContent := ""
Loop, parse, FileContent, `n, `r
{
	if RegExMatch(A_LoopField, "[^,]+", match) ; match anything but comma
		newContent .= A_LoopField "`n"
	else
		continue
}
FileDelete, %F1%
FileAppend, %newContent%, %F1%

Loop,Read,%F1%
  {
    Line%A_Index% := A_LoopReadLine
    Line0 = %A_Index%
  }
Loop, %Line0%
    {    
      StringSplit, Array, Line%A_Index%, `, 
      BeforeNames.Push(Array1)
    } 
	

Gui,Add, ListView,grid r20 w437 -Multi +hscroll altsubmit vMyListView gMyListView, NAME|PLAYERS|TEMPO|DESCRIPTION|ID
Gui, Add, Button, xm gSAVE,Save
Gui, Show, ,Csv Editor 
GoSub,FILLLIST 
return 

FILLLIST: 
  LV_Delete() 
  Loop, %Line0%
    {    
      StringSplit, Array, Line%A_Index%, `, 
      LV_Add("",Array1,Array2,Array3,Array4,A_Index) 
    } 
  LV_ModifyCol(1,"AutoHdr") 
  LV_ModifyCol(2,"AutoHdr") 
  LV_ModifyCol(3,"AutoHdr") 
  LV_ModifyCol(4,"AutoHdr") 
  LV_ModifyCol(5,"0 Integer") 
return 

MyListView: 
  if A_GuiEvent = DoubleClick 
    { 
      RowNumber := LV_GetNext(0)
      if not RowNumber
          return
      Loop, 5
          LV_GetText(A3%A_Index%, RowNumber,A_Index) 
      editadd = edit 
      GoSub,SMGUI 
    } 
return 

SMGUI: 
  Gui,2:Add,Text, xm Section w80, NAME 
  Gui,2:Add,Edit, ys-4 w420  vA41, %A31% 
  Gui,2:Add,Text, xm Section w80  , PLAYERS 
  Gui,2:Add,Edit, ys-4 w420  vA42, %A32% 
  Gui,2:Add,Text, xm Section w80  , TEMPO 
  Gui,2:Add,Edit, ys-4 w420  vA43, %A33% 
  Gui,2:Add,Text, xm Section w80  , DESCRIPTION 
  Gui,2:Add,Edit, ys-4 w420  vA44, %A34% 
  Gui,2:Add, Button, xm, OK 
  Gui,2:Show, , NAME-INPUT 
return 

2ButtonOK: 
  Gui,2:Submit 
  Gui,2:Destroy 
  Gui,1:Default 
  if editadd = edit 
	{
	A41 := StrReplace(A41, ",", "")
	A42 := StrReplace(A42, ",", "")
	A43 := StrReplace(A43, ",", "")
	A44 := StrReplace(A44, ",", "")
      Line%A35% := A41 . "," . A42 . "," . A43 . "," . A44
	}
  Else
    { 
      Line0++
      Line%Line0% := A41 . "," . A42 . "," . A43 . "," . A44
    } 
  GoSub,FILLLIST 
return 

2GuiClose: 
2GuiEscape: 
  Gui,2:Submit 
  Gui,2:Destroy 
  Gui,1:Default 
return

SAVE:
  Loop, %Line0%
    {    
      StringSplit, Array, Line%A_Index%, `, 
      AfterNames.Push(Array1)
    } 
	nameLen := BeforeNames.Length()
	Loop %nameLen%
	{
		name1 := BeforeNames[A_Index]
		name2 := AfterNames[A_Index]
		if (name1 != name2)
		{
			SelectedFile := A_WorkingDir "\Csv\" name1 ".csv"
			if FileExist(SelectedFile)
			{
				NewPath := A_WorkingDir "\Csv\" name2 ".csv"
				FileMove, %SelectedFile%, %NewPath%, 1
			}
      SelectedFile := A_WorkingDir "\Midi\" name1 ".mid"
			if FileExist(SelectedFile)
			{
				NewPath := A_WorkingDir "\Midi\" name2 ".mid"
				FileMove, %SelectedFile%, %NewPath%, 1
			}
		}
	}
  FileContent =
  Loop, %Line0%
      FileContent := FileContent . Line%A_Index% . "`n"
  FileDelete, %F1%
  FileAppend, %FileContent%, %F1%
  Sleep, 500
  ExitApp 
return

GuiClose:
  ExitApp 