#SingleInstance Force
#NoEnv
Gui, Margin, 0, 0
Gui, Font,, Verdana
Gui, Font, c1F4671
;Gui,Add,Picture,x0 y0 w400 h490,Images\bg.png

;------------------------------- Main GUI ------------------------------;
WinSet, TransColor, ffffff
Gui,Add,Picture,x0 y0 w400 h75,Images\Title.png
Gui Add, ListView, x10 y75 w290 h305 +LV0x4000 gMyListView -Multi AltSubmit, Name                            |Players|Date
LV_ModifyCol(3,58)
Gui, Add, Button, x300 y365 w20 h20 gRefreshButton, ↻
Gui, Add, Picture, x310 y85 w80 h80 gNewButton, Images\Page.png
Gui Add, Text, x310 y165 w80 h15 Center, New Song
Gui, Add, Picture, x310 y185 w80 h80 gDeleteSongButton, Images\Salvage Kit.png
Gui Add, Text, x310 y265 w80 h15 Center, Delete Song
Gui, Add, Picture, x310 y285 w80 h80 gOpenEditorButton, Images\Tool Kit.png
Gui Add, Text, x320 y365 w72 h15, Data Editor

Gui, Add, Picture, x10 y390 w80 h80 vPlayPauseImage gTogglePlay, Images\Fa.png
Gui Add, Text, x10 y470 w80 h15 vPlayPause Center, Play
Gui Add, Edit, x100 y390 w200 h80 vSongDescription
Gui Add, Text, x100 y470 w200 h15 Center, Song Description
Gui, Add, Picture, x310 y390 w80 h80 gControlsButton, Images\Return.png
Gui Add, Text, x310 y470 w80 h15 Center, Controls
Gui, Add, Button, x380 y0 w20 h20 gInfoButton, ?
Gui,Add,Button,x360 y0 w20 h20 gSettingsButton,⚙
if (OnTopEnabled)
    Gui, +AlwaysOnTop
Gui, Show,,GW2AhkPlayer
if (TransparentEnabled)
    WinSet, Transparent, 200, GW2AhkPlayer
Gui, Show,,GW2MM

;------------------------------- Settings GUI ------------------------------;
Gui,SettingsGui:Add,Text,x0 y3 w80 h20, Octave Delay :
Gui,SettingsGui:Add,Button,x170 y0 w20 h20 gOctaveDelayExplanation,?
Gui,SettingsGui:Add,Edit,x100 y0 w50 h20 vOctaveDelay,%Delay%
Gui,SettingsGui:Add,CheckBox, x0 y30 w170 h20 vAlwaysOnTop Checked%OnTopEnabled%, Enable Always On Top?
Gui,SettingsGui:Add,Button,x170 y30 w20 h20 gAlwaysOnTopExplanation,?
Gui,SettingsGui:Add,CheckBox, x0 y50 w170 h20 vIsTransparent Checked%TransparentEnabled%, Enable Transparency?
Gui,SettingsGui:Add,Button, x170 y50 w20 h20 gTransparencyExplanation,?
Gui SettingsGui:Add,Button, x0 y160 w200 h40 gSettingsSaveButton, Save
Gui SettingsGui:Add,Button, x0 y160 w200 h40 gSettingsSaveButton, Save


;------------------------------- Info GUI ------------------------------;
Gui, Info:Add,Link,x0 y0 w200 h40 vText1,Please check out this <a href="https://docs.google.com/document/d/1Ek9sHKd0PQw9vmecujCG7tVtNIkKMtPnIPPEBio5ZoU/edit?usp=sharing">doc</a> for guidance on using this application.
Gui, Info:Add,Picture, x20 y30 w160 h160, Images\logo.png
Gui, Info:Add,Text,x0 y200 w200 h40 Center,Version 1.5
GuiControl +BackgroundTrans, Text1

;------------------------------- New Song GUI ------------------------------;
;Adds to list view in the following format -> NewSongTitle | NumberPlayers | TempoModifier | SongDescription
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

;------ Tempo Explanation GUI ------;
Gui,TempoExplanation:Add,Text,x0 y0 w200 h150, Midis don't always import with the correct tempo, so with this you can change the tempo that the song will start with. Each -1/-+1 will decrease/increase the tempo by 5 percent. For example, -4 will slow the song down by 20 percent, while +4 will speed up the song by 20 percent. You can always change this value with the data editor.

;------ Description Explanation GUI ------;
Gui,DescriptionExplanation:Add,Text,x0 y0 w200 h100, This is where you can type out a helpful description of the song. For example, you might want to write down which instruments are used in it as well as their order.

;------ Players Explanation GUI ------;
Gui,PlayersExplanation:Add,Text,x0 y0 w200 h100, Add the number of players that are used in this song. If this is set to 1 player, it will merge all the tracks in the midi and use a different method while playing it.

;------ Controls Explanation GUI ------;
Gui,ControlsExplanation:Add,Text,x0 y0 w200 h150, F1 - Plays the selected song`nF2 - Pause/Play the song`nF3 - Reloads the application`nF4 - Exits the application`nF5 - Sets window as Player 1`nF6 - Sets window as Player 2`nF7 - Sets window as Player 3`nF8 - Sets window as Player 4`nF9 - Sets window as Player 5`nF10 - Reduces tempo by 5 percent`nF11 - Increases tempo by 5 percent

;------ Octave Explanation GUI ------;
Gui,OctaveDelayExplanation:Add,Text,x0 y0 w200 h150, This Delay is used in Singleplayer scripts to prevent the octave bug. Usually you'll want to set this to roughly 2x your average in-game ping.

;------ AlwaysOnTop Explanation GUI ------;
Gui,AlwaysOnTopExplanation:Add,Text,x0 y0 w200 h150, Sets the application to always be visible. This is useful if you want to play Guild Wars 2 in Fullscreen.

;------ Transparency Explanation GUI ------;
Gui,TransparencyExplanation:Add,Text,x0 y0 w200 h150, Sets the application to be transparent. You may like this if you play Guild Wars 2 in Fullscreen.

Winset, Region, w300 h500