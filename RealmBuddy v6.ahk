;;;;;;;;;;;;;;              HEADER					;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2

;;;;;;;;;;;;;;				BINDING FUNCTION HEADER					;;;;;;;;;;;;;;;;;;;;;;

#InstallKeybdHook
#InstallMouseHook
; Build list of "End Keys" for Input command
EXTRA_KEY_LIST := "{Escape}"	; DO NOT REMOVE! - Used to quit binding
; Standard non-printables
EXTRA_KEY_LIST .= "{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}"
EXTRA_KEY_LIST .= "{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BackSpace}{Pause}{Enter}{Space}{Tab}{PrintScreen}"
; Numpad - Numlock ON
EXTRA_KEY_LIST .= "{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadMult}{NumpadAdd}{NumpadSub}"
; Numpad - Numlock OFF
EXTRA_KEY_LIST .= "{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}"
; Numpad - Common
EXTRA_KEY_LIST .= "{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadDiv}{NumpadEnter}"
; Stuff we may or may not want to trap
;EXTRA_KEY_LIST .= "{Numlock}"
EXTRA_KEY_LIST .= "{Capslock}"
;EXTRA_KEY_LIST .= "{PrintScreen}"
; Browser keys
EXTRA_KEY_LIST .= "{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}{Browser_Favorites}{Browser_Home}"
; Media keys
EXTRA_KEY_LIST .= "{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}"
; App Keys
EXTRA_KEY_LIST .= "{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}"
; BindMode vars
HKModifierState := {} ; The state of the modifiers at the end of the last detection sequence
HKControlType := 0	; The kind of control that the last hotkey was. 0 = regular key, 1 = solitary modifier, 2 = mouse, 3 = joystick
HKSecondaryInput := ""	; Set to button pressed if the last detected bind was a Mouse button, Joystick button or Solitary Modifier
HKLastHotkey := 0	; Time that Escape was pressed to exit key binding. Used to determine if Escape is held (Clear binding)
DefaultHKObject := {hk: "", type: ""}

;;;;;;;;;;;;;;				INI CREATION 				;;;;;;;;;;;;;;;;;;;;;;

ININame := BuildIniName()
NumHotkeys = 41
ifNotExist %ININame%
{
	Loop 10
	{
		if A_Index = 1
			IniWrite, MyServer, %ININAME%, HUD, Slot%A_Index%
		else if A_Index = 2
			IniWrite, OtherKeySub12, %ININAME%, HUD, Slot%A_Index%
		else if A_Index = 3
			IniWrite, OtherKeySub2, %ININAME%, HUD, Slot%A_Index%
		else if A_Index = 4
			IniWrite, OtherKeySub1, %ININAME%, HUD, Slot%A_Index%
		else if A_Index = 5
			IniWrite, LeftToMax, %ININAME%, HUD, Slot%A_Index%
		else if A_Index = 10
			IniWrite, Friends, %ININAME%, HUD, Slot%A_Index%
		else
			IniWrite, Nothing, %ININAME%, HUD, Slot%A_Index%
	}
	IniWrite, ahk_group rotmg, %ININame%,  Settings, WindowTitle
	IniWrite, Yes, %ININame%,  Settings, SwitchTeleport
	IniWrite, Public, %ININame%, Settings, GuildCall
	IniWrite, No, %ININame%, Settings, CustomCursor
	IniWrite, ON, %ININame%, Settings, InstantTrade
	IniWrite, CurrentPlayerNotSet, %ININame%, Settings, CurrentPlayer
	IniWrite, CurrentPlayerNotSet, %ININAME%, Settings, CurrentTP
	IniWrite, 0, %ININame%, Settings, More
	IniWrite, Escape, %ININame%, Settings, DeleteBinding
	IniWrite, 2, %ININame% , Settings, RClick
	IniWrite, 1, %ININame% , Settings, DRClick
	IniWrite, 0, %ININame%, Settings, F5Override
	IniWrite, link.cur, %ININame%, Settings, CursorName
	IniWrite, 0, %ININame%, Settings, Kong
	IniWrite, OFF, %ININame%, Settings, AlwaysOnTop
	IniWrite, 1, %ININame% , Quick Speech Realm Checkbox, Checkboxignore
	IniWrite, 1, %ININame% , Quick Speech Realm Checkbox, Checkboxnexus
	IniWrite, 1, %ININame% , Quick Speech Realm Checkbox, Checkboxtrade
	IniWrite, 1, %ININame% , Quick Speech Realm Checkbox, Checkboxtp
	IniWrite, 0, %ININame% , Quick Speech Realm Checkbox, Checkboxrandom
	Loop % NumHotkeys
	{
		if A_Index = 1
		{
			IniWrite, /teleport CurrentPlayerNotSet, %ININame%, Quick Speech Text, Text%A_Index%
		}
		else if A_Index = 3
		{
			IniWrite, I love you guys! .................................................. s!gnE@Wa!!!!!!!!!!!!!!!!!!!!!!!tg, %ININame%, Quick Speech Text, Text%A_Index%
		}
		else if A_Index = 4
		{
			IniWrite, WAaaWAaaWAaaa@IIIIIIIIIIIIIIIINNNNNNNNNNNNNWAWAWAAAAAAAAAAWAWwwwwwwwwwaaaaaaaaaaaaaaaaaaaaaaaa, %ININame%, Quick Speech Text, Text%A_Index%
		}
		else
		{
			IniWrite, None, %ININame%, Quick Speech Text, Text%A_Index%
		}
		IniWrite, 1, %ININame% , Quick Speech Realm Checkbox, Checkbox%A_Index%
		IniWrite, 0, %ININame% , Quick Speech Realm Checkbox, TabCheckbox%A_Index%
	}
	RealNumHotkeys :=  NumHotkeys + 30
	NumOKey := NumHotkeys + 27
	NumBTKey := NumHotkeys + 28
	NumAKey := NumHotkeys + 29
	NumACKey := NumHotkeys + 30
	NumIKey := NumHotkeys + 3
	NumEGUI := NumHotkeys + 2  ; Event GUI
	NumSPGUI := NumHotkeys + 12  ; Speech GUI
	NumCGUI := NumHotkeys + 13  ; Calls GUI
	NumSGUI := NumHotkeys + 1  ; Server GUI
	NumMGUI := NumHotkeys + 14  ; Macro GUI
	Loop % RealNumHotkeys
	{
		if A_Index = %NumACKey%
			IniWrite, Enter, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumOKey%
			IniWrite, o, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumBTKey%
			 IniWrite, Tab, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumIKey%
			IniWrite, SC00B, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumAKey%
			IniWrite, Space, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumEGUI%
			IniWrite, F1, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumSPGUI%
			IniWrite, F4, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumCGUI%
			IniWrite, F3, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumSGUI%
			IniWrite, F12, %ININame%, Hotkeys, hk_%A_Index%_hk
		else if A_Index = %NumMGUI%
			IniWrite, F2, %ININame%, Hotkeys, hk_%A_Index%_hk
		else
			IniWrite, % "", %ININame%, Hotkeys, hk_%A_Index%_hk
		IniWrite, 0, %ININame%, Hotkeys, hk_%A_Index%_type
	}
	FileSelectFolder, RealmBuddyPath,,, Choose The Folder with RealmBuddy (it's better if you have a path without spaces but it *should* work anyhow)
	Loop, %RealmBuddyPath%, 1, 1
	{
		Path = %A_LoopFileFullPath%
	}
	IniWrite, %Path%, %ININame%, Settings, Path
	GoSub, NewPixels
	msgbox Don't forget to go to Settings first to make your Hotkeys or nothing will work !`nYou need to bind 3 keys (but can be like WIN + ALT + J) for the GUIs !`nGUI stands for Graphical User Interface
}

counter = -1

IfNotExist, macro.INI
{
	HealMeArray := ["Heal me please! I'm hurt!", "Could you press your spacebar, kind healer?", "I need some big heals over there!", "HP please!", "Heal me dude!", "Healer required here!", "I need some heals!", "Where are the priests, I need some healing!", "I could use some heals there :)", "Mind healing me guys?"]
	ThanksArray := ["Thank you Bro, it's really  appreciated ! <3", "You're nice, thanks a bunch! :D", "You have my gratitude, friend! Cheers :)", "Thanks mate!", "That's sweet, thanks :D", "That's nice of you, thanks!", "Many thanks!", "Thanks a lot!", "Cheers, mate :)", "Thank you kind Sir!", "How sweet of you, thank you!", "Thank you for that!", "Wow, thanks!", "Thank you dude!"]
	GLArray := ["Good luck guys! Let's get that fat loot!", "Best of luck fellows!", "Good luck everyone!", "I can sense some whitebag there! :D", "Sorry for stealing the good loot guys :3", "Seems like it's gonna be 0 again xD", "Come on RNGesus, give me an EP now!", "Everyone ready for some fat 0 ? :D", "I feel this loot will be glorious!", "I'm afraid there won't be good loot there sadly :/", "You need loot? Then let's get some ! :D", "May the pixels be with you!", "Deca, I trust you in this one, don't disapoint me now!", "./spawn fat loot", "Looks like there's gonna be some good loot for everyone this time :)", "Are you all ready for some 0? :D", "GL guys, 0 incoming! :p", "Sorry for the bad loot guys :/", "Ready for some mark ? :p", "Whitebag incoming!", "I predict a lot of white bags in this one!", "Here comes some sweet loot!", "I can smell some fat pixels close by!", "Let's believe in the good loot!", "No need luck, I know we'll get pleased in this one :)", "This bag will contain all our dreams and hope for sure!", "Get ready to be pleased by that bag guys!", "My dream foretold me that this bag is gonna be divine!", "Apologize for crushing your souls guys, but this time I'm gonna be the lucky one :p", "Even though I won't be lucky, I know you guys will be in my stead, have fun :D", "Good luck and have fun!"]
	
	IniWrite, https://autohotkey.com/docs/KeyList.htm, macro.ini, Help, HotkeyList
	IniWrite, Numpad9, macro.ini, HotKey, Key
	
	for index, element in HealMeArray
	{
		IniRead, HealMe%A_index%, macro.ini, HealMe, Text%A_index%
		if HealMe%A_index% = ERROR
		{
			IniWrite, % HealMeArray[A_index], macro.ini, HealMe, Text%A_index%
		}
	}
	for index, element in ThanksArray
	{
		IniRead, ThanksArray%A_index%, macro.ini, Thanks, Text%A_index%
		if ThanksArray%A_index% = ERROR
		{
			IniWrite, % ThanksArray[A_index], macro.ini, Thanks, Text%A_index%
		}
	}
	for index, element in GLArray
	{
		IniRead, GLArray%A_index%, macro.ini, GoodLuck, Text%A_index%
		if GLArray%A_index% = ERROR
		{
			IniWrite, % GLArray[A_index], macro.ini, GoodLuck, Text%A_index%
		}
	}
}
else
{
	HealMeArray := []
	ThanksArray := []
	GLArray := []

	Loop
	{
		IniRead, HealMe%A_index%, macro.ini, HealMe, Text%A_index%
		if HealMe%A_index% != ERROR
		{
			HealMeArray.Push(HealMe%A_index%)
		}
		else
		{
			break
		}
	}
	Loop
	{
		IniRead, Thanks%A_index%, macro.ini, Thanks, Text%A_index%
		if Thanks%A_index% != ERROR
		{
			ThanksArray.Push(Thanks%A_index%)
		}
		else
		{
			break
		}
	}
	Loop
	{
		IniRead, GL%A_index%, macro.ini, GoodLuck, Text%A_index%
		if GL%A_index% != ERROR
		{
			GLArray.Push(GL%A_index%)
		}
		else
		{
			break
		}
	}
}

;;;;;;;;;;;;;;				INI READING					;;;;;;;;;;;;;;;;;;;;;;

HotkeyList := []
NumSGUI := NumHotkeys + 1  ; Server GUI
NumEGUI := NumHotkeys + 2  ; Event GUI
NumIKey := NumHotkeys + 3  ; Interact Key
NumSMenu := NumHotkeys + 4  ; Server Menu
NumRCall := NumHotkeys + 5  ; Realm Callout
NumDCall := NumHotkeys + 6  ; Dungeon Callout
NumGS := NumHotkeys + 7  ; Guild Speech
NumRS := NumHotkeys + 8  ; RealmEye Speech
NumAS := NumHotkeys + 9  ; Advanced Speech
NumCF := NumHotkeys + 10  ; Change Focus
NumTC := NumHotkeys + 11  ; Toggle Callout (Public/Guild)
NumSPGUI := NumHotkeys + 12  ; Speech GUI
NumCGUI := NumHotkeys + 13  ; Calls GUI
NumMGUI := NumHotkeys + 14  ; Macro GUI
NumHGUI := NumHotkeys + 15  ; HUD GUI

NumS1 := NumHotkeys + 16
NumS2 := NumHotkeys + 17
NumS3 := NumHotkeys + 18
NumS4 := NumHotkeys + 19
NumS5 := NumHotkeys + 20
NumS6 := NumHotkeys + 21
NumS7 := NumHotkeys + 22
NumS8 := NumHotkeys + 23

NumScr := NumHotkeys + 24
NumPaint := NumHotkeys + 25
NumImgur := NumHotkeys + 26

NumOKey := NumHotkeys + 27 ; Option Key
NumBTKey := NumHotkeys + 28 ; BeginTell Key
NumAKey := NumHotkeys + 29 ; Ability Key
NumACKey := NumHotkeys + 30 ; ActivateChat Key
RealNumHotkeys :=  NumHotkeys + 30  ; NumHotkey only counts the 40 bind functions, RealNumHotkeys count the other bindings as well
RealmNumKeys := NumHotkeys + 26  ; Those above this number are fake bindings, because they are YOUR ingame configuration

Loop % RealNumHotkeys 
{
	; Init array so all items exist
	HotkeyList[A_Index] := DefaultHKObject
	IniRead, val, %ININame% , Hotkeys, hk_%A_Index%_hk,
	IniRead, type, %ININame% , Hotkeys, hk_%A_Index%_type,
	if (val != "ERROR")
	{
		IniRead, type, %ININame% , Hotkeys, hk_%A_Index%_type, 0
		HotkeyList[A_Index] := {hk: val, type: type, status: 0}
	}
}
IniRead, Checkignore, %ININame% , Quick Speech Realm Checkbox, Checkboxignore
IniRead, Checknexus, %ININame% , Quick Speech Realm Checkbox, Checkboxnexus
IniRead, Checktrade, %ININame% , Quick Speech Realm Checkbox, Checkboxtrade
IniRead, Checktp, %ININame% , Quick Speech Realm Checkbox, Checkboxtp
IniRead, Checkrandom, %ININame% , Quick Speech Realm Checkbox, Checkboxrandom

MacroPressed := 0
CallsPressed := 0
CallPressed := 0
ServerPressed := 0
SpeechPressed := 0
HUDPressed := 0
FAST := 0

Global ActiveIcon := A_ScriptDir "\img\Active.ico"
Global PausedIcon := A_ScriptDir "\img\Paused.ico"
;InGamePos := (A_ScreenWidth / 2) - 450

GroupAdd rotmg, realmofthemadgod
GroupAdd rotmg, AssembleeGameClient
GroupAdd rotmg, AGCLoader
GroupAdd rotmg, Realm of the Mad God
GroupAdd rotmg, Adobe Flash Player 

GroupAdd rotmg2, zofnezqnfkqlqsdùfkqsfnqfnqmnodsqmfni==========THOSE.ARE.RANDOM.LETTERS.SO.THAT.F5OVERRIDE.NEVER.FINDS.A.WINDOW.WITH.THIS.NAME.:P===========fsqfsdgfsdgsdfgsdfgsdgdfsgsfdgsdg

IniRead, F5Override, %ININame%, Settings, F5Override
IniRead, WinTitle, %ININame%,  Settings, WindowTitle
if F5Override = 1
{
	GroupAdd rotmg2, realmofthemadgod
	GroupAdd rotmg2, AssembleeGameClient
	GroupAdd rotmg2, AGCLoader
	GroupAdd rotmg2, Realm of the Mad God
	GroupAdd rotmg2, Adobe Flash Player 
}
Loop % NumHotkeys
{
	IniRead, QSText%A_Index%, %ININame%, Quick Speech Text, Text%A_Index%
	IniRead, RealmCheck%A_Index%, %ININame% , Quick Speech Realm Checkbox, Checkbox%A_Index%
	IniRead, TabCheck%A_Index%, %ININame% , Quick Speech Realm Checkbox, TabCheckbox%A_Index%
}
IniRead, CurrentTP, %ININAME%, Settings, CurrentTP
IniRead, SwitchTeleport, %ININame%,  Settings, SwitchTeleport
if SwitchTeleport=Yes
{
	RecentPlayerSaved=Choose1
}
else
{
	RecentPlayerSaved=Choose2
}

IniRead, GuildCall, %ININame%, Settings, GuildCall
if GuildCall = Guild
{
	GuildCallSaved = Choose1
	WhatCall := "/g "
}
else
{
	GuildCallSaved = Choose2
	WhatCall := ""
}

IniRead, cursor, %ININame%, Settings, CustomCursor
if cursor = Yes
{
	CursorSaved = Choose1
}
else
{
	CursorSaved = Choose2
}

IniRead, instant, %ININame%, Settings, InstantTrade
IniRead, CurrentPlayer, %ININame%, Settings, CurrentPlayer
IniRead, FamePixel, %ININame%, Settings, FamePixel
IniRead, CoinPixel, %ININame%, Settings, CoinPixel
; IniRead, EnterPixel, %ININame%, Settings, EnterPixel
IniRead, RClick, %ININame%, Settings, RClick
IniRead, DRClick, %ININame%, Settings, DRClick
IniRead, CUSTOM_CURSOR, %ININame%, Settings, CursorName
IniRead, Kong, %ININame%, Settings, Kong
IniRead, More, %ININame%, Settings, More
IniRead, DeleteBinding, %ININame%, Settings, DeleteBinding
IniRead, Path, %ININame%, Settings, Path
IniRead, AOT, %ININame%, Settings, AlwaysOnTop

Loop 10
{
	IniRead, Slot%A_Index%, %ININAME%, HUD, Slot%A_Index%
}

DeleteBindingKey := DeleteBinding

PG = public
TimeString =
Last = Waiting...
realm = Waiting...
server = Waiting...
CHAR = 0
StopAtCharScreen = 0
counter = -1

;;;;;;;;;;;;;;				GUI CREATION					;;;;;;;;;;;;;;;;;;;;;;

Gui 1:+LabelRealmBuddy
gui, RealmBuddy:font, s9, Tahoma
Gui, RealmBuddy:Add, Text,x5  w80 h15 Center vREALM, %realm%
Gui, RealmBuddy:Add, Text,x5  w80 h15 Center vSERVER, %server%
Gui, RealmBuddy:Add, Text,x5  w80 h15 cGreen Center vERROR, GOOD

gui, RealmBuddy:font, 
Gui, RealmBuddy:Add, Button, x15  w80 h30 gSettings, Settings
Gui, RealmBuddy:Add, Button, x15  w80 h30 gQuickSpeechSettings, QuickSpeech Settings
Gui, RealmBuddy:Add, Button, x15  w80 h30 gHUDSettings, HUD Settings
Gui, RealmBuddy:Add, Button, x15  w80 h30 gMoreStuff, More
Gui, RealmBuddy:Add, Button, x15  w80 h30 vTOP gONTOP, Always on top`n%AOT%

gui, RealmBuddy:font, s7, Tahoma,  Center
Gui, RealmBuddy:Add, StatusBar, gVersion, %A_Space%%A_Space%%A_Space%%A_Space%%A_Space%Realm Buddy v6
Gui, RealmBuddy:Margin, 10, 10


Gui 2:+LabelServerList
gui, ServerList:+ownerRealmBuddy
gui, ServerList:font, s8, Tahoma
Gui, ServerList:Add, Tab2,h24 Buttons,EU/ASIA|US|  ; Tab2 vs. Tab requires v1.0.47.05.
gui, ServerList:font, s7, Tahoma

;;;;;;;;;;;;;;				EU SERVERS BUTTONS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServerList:Add, Button, x5 yp25 w90 h24 vEUW gEUW, EUWest
Gui, ServerList:Add, Button, w90 h24 vEUW2 gEUW2, EUWest2
Gui, ServerList:Add, Button, w90 h24 vEUS gEUS, EUSouth
Gui, ServerList:Add, Button, w90 h24 vEUSW gEUSW, EUSouthWest
Gui, ServerList:Add, Button, w90 h24 vEUN gEUN, EUNorth
Gui, ServerList:Add, Button, w90 h24 vEUN2 gEUN2, EUNorth2
Gui, ServerList:Add, Button, w90 h24 vEUE gEUE, EUEast

Gui ServerList:Font, S1
Gui ServerList:Add, GroupBox, w90 h1,    ; black horizontal line
gui, ServerList:font, s7, Tahoma

;;;;;;;;;;;;;;				ASIA SERVERS BUTTONS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServerList:Add, Button, w90 h24 vASE gASE, AsiaSouthEast
Gui, ServerList:Add, Button, w90 h24 vAE gAE, AsiaEast

;;;;;;;;;;;;;;				US SERVERS BUTTONS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServerList:Tab, 2

Gui, ServerList:Add, Button, x5 yp-248 w90 h24 vUSW gUSW, USWest
Gui, ServerList:Add, Button, w90 h24 vUSW2 gUSW2, USWest2
Gui, ServerList:Add, Button, w90 h24 vUSW3 gUSW3, USWest3
Gui, ServerList:Add, Button, w90 h24 vUSE gUSE, USEast
Gui, ServerList:Add, Button, w90 h24 vUSE2 gUSE2, USEast2
Gui, ServerList:Add, Button, w90 h24 vUSE3 gUSE3, USEast3
Gui, ServerList:Add, Button, w90 h24 vUSS gUSS, USSouth
Gui, ServerList:Add, Button, w90 h24 vUSS2 gUSS2, USSouth2
Gui, ServerList:Add, Button, w90 h24 vUSS3 gUSS3, USSouth3
Gui, ServerList:Add, Button, w90 h24 vUSSW gUSSW, USSouthWest
Gui, ServerList:Add, Button, w90 h24 vUSMW gUSMW, USMidWest
Gui, ServerList:Add, Button, w90 h24 vUSMW2 gUSMW2, USMidWest2
Gui, ServerList:Add, Button, w90 h24 vUSNW gUSNW, USNorthWest

Gui, ServerList:Tab  

Gui, ServerList:Show, w100 Hide,Servers List
Gui, ServerList:+ToolWindow

;;;;;;;;;;;;;;				REALM EVENT BUTTONS					;;;;;;;;;;;;;;;;;;;;;;

Gui 3:+LabelEventList
gui, EventList:+ownerRealmBuddy
Gui, EventList:Add, Button, w80 h35 gSphinx, Grand Sphinx
Gui, EventList:Add, Button, w80 h35 gHermit, Hermit God
Gui, EventList:Add, Button, w80 h35 gCrystal, Crystal
Gui, EventList:Add, Button, w80 h35 gWC, Wine Cellar
Gui, EventList:Add, Button, w80 h35 gLich, Lich
Gui, EventList:Add, Button, w80 h35 gEnt, Ent
Gui, EventList:Add, Button, w80 h35 gShip, Ghost Ship
Gui, EventList:Add, Button, w80 h35 gLord, Lord of the Lost Lands
Gui, EventList:Add, Button, w80 h35 gCube, Cube God
Gui, EventList:Add, Button, w80 h35 gShrine, Skull Shrine
Gui, EventList:Add, Button, w80 h35 gPentaract, Pentaract
Gui, EventList:Add, Button, w80 h35 gDragon, Rock Dragon
Gui, EventList:Add, Button, w80 h35 gAvatar, Avatar of the Forgotten King
Gui, EventList:Add, Button, w80 h35 gLDjinn, Lucky Djinn
Gui, EventList:Add, Button, w80 h35 gLEnt, Lucky Ent
Gui, EventList:Show, Hide,Realm Caller
Gui, EventList:+ToolWindow

;;;;;;;;;;;;;;				DUNGEON EVENT BUTTONS					;;;;;;;;;;;;;;;;;;;;;;

Gui 4:+LabelDungeonList
Gui, DungeonList:+ownerRealmBuddy
Gui, DungeonList:Add, Button, w80 h35 gAbyss, Abyss of Demons
Gui, DungeonList:Add, Button, w80 h35 gUDL, Undead Lair
Gui, DungeonList:Add, Button, w80 h35 gLab, Mad Lab
Gui, DungeonList:Add, Button, w80 h35 gSnake, Snake Pit
Gui, DungeonList:Add, Button, w80 h35 gManor, Manor of the Immortals
Gui, DungeonList:Add, Button, w80 h35 gCemetary, Haunted Cemetary
Gui, DungeonList:Add, Button, w80 h35 gPuppet, Puppet Master's Theatre
Gui, DungeonList:Add, Button, w80 h35 gIce, Ice Cave
Gui, DungeonList:Add, Button, w80 h35 gDJL, Davy Jones's Locker
Gui, DungeonList:Add, Button, w80 h35 gTomb, Tomb of the Ancients
Gui, DungeonList:Add, Button, w80 h35 gTrench, Ocean Trench
Gui, DungeonList:Add, Button, w80 h35 gLoD, Lair of Draconis
Gui, DungeonList:Add, Button, w80 h35 gShatters, The Shatters
Gui, DungeonList:Add, Button, w80 h35 gDEPTHS, Crawling Depths
Gui, DungeonList:Add, Button, w80 h35 gWOOD, Woodland Labyrinth
Gui, DungeonList:Add, Button, w80 h35 gDOCKS, Deadwater Docks
Gui, DungeonList:Show, Hide,Dungeon Caller
Gui, DungeonList:+ToolWindow

;;;;;;;;;;;;;;				SETTINGS					;;;;;;;;;;;;;;;;;;;;;;

Gui 5:+LabelSettings
Gui, Settings:+ownerRealmBuddy
Gui, Settings:Font, 
Gui, Settings:Add, Text, section, Window Name (ahk_group rotmg = Any Realm Window) :
Gui, Settings:Font, Norm cBlue bold s10
Gui, Settings:Add, Text, ym-1 vHELPBOXToolTipWindow gToolTipWindow, ?
Gui, Settings:Font, 

Gui, Settings:Add, Edit, xs w290 -HScroll -VScroll h20 vTitleEdit,%WinTitle%
Gui, Settings:Add, Tab2,h24 yp40 Buttons,Required|Optional|Other
Gui, Settings:Font, cRed bold s10
Gui, Settings:Add, GroupBox, w300 h180 xs, InGame Hotkeys :    REQUIRED ;InGame Hotkeys
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipIGHotkey gToolTipIGHotkey, ?
Gui, Settings:Font, 

Gui, Settings:Add, Button, gBind vBind%NumIKey% w125 yp25 xp-245, Interact/Buy Key: ;Interact Key hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumIKey% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipIKey gToolTipIKey, ? 
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumACKey% w125 yp30 xp-275, ActivateChat Key: ;ActivateChat Key hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumACKey% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipACKey gToolTipACKey, ? 
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumOKey% w125 yp30 xp-275, Show Options Key: ;Options Key hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumOKey% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipOptionKey gToolTipOptionKey, ? 
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumBTKey% w125 yp30 xp-275, Begin Tell Key: ;Begin Tell Key hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumBTKey% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipBTKey gToolTipBTKey, ? 
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumAKey% w125 yp30 xp-275, Use Special Ability Key: ;Ability Key hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumAKey% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipAKey gToolTipAKey, ? 
Gui, Settings:Font, 

Gui, Settings:Font, cRed bold s10
Gui, Settings:Add, GroupBox, w300 h210 xs, GUI Hotkeys :        REQUIRED ;GUI Hotkeys
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipGUIHotkey gToolTipGUIHotkey, ?
Gui, Settings:Font, 

Gui, Settings:Add, Button, gBind vBind%NumEGUI% w125 yp25 xp-245, Event GUI: ;Event Callout GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumEGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipEGUI gToolTipEGUI, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumSPGUI% w125 yp30 xp-275, Speech GUI: ;Speech GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumSPGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipSPGUI gToolTipSPGUI, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumCGUI% w125 yp30 xp-275, Calls GUI: ;Calls GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumCGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipCGUI gToolTipCGUI, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumMGUI% w125 yp30 xp-275, Macro GUI: ;Macro GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumMGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipMGUI gToolTipMGUI, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumHGUI% w125 yp30 xp-275, HUD GUI: ;HUD GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumHGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipHGUI gToolTipHGUI, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumSGUI% w125 yp30 xp-275, Servers GUI: ;Server GUI hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumSGUI% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipSGUI gToolTipSGUI, ?
Gui, Settings:Font, 

Gui, Settings:Tab
Gui, Settings:Add, Button, x15 w100 yp+50 gRBQA, Help
Gui, Settings:Add, Button, xp0 w100 yp30 gBuiltInFunctions, Explanations
Gui, Settings:Add, Button, xp0 w100 yp30 gRBVid, Video
;Gui, Settings:Add, Button, xp0 w100 yp40 gImageVid, Realms Tutorial
Gui, Settings:Add, Checkbox, yp-55 xp150 w100 vActMoreCheck gActMore Checked%More%, Enable More
Gui, Settings:Add, Checkbox, yp30 xp0 w100 vKongCheck gCheckKong Checked%kong%, Enable Kong
Gui, Settings:Add, Checkbox, yp25 xp0 w100 vF5Check gCheckF5 Checked%F5Override%, F5 as Macro`n(need restart)

Gui, Settings:Tab, 2
Gui, Settings:Font, cGreen bold s10
Gui, Settings:Add, GroupBox, w300 h90 xs y97, Extra Hotkeys :        OPTIONAL ;Extra Hotkeys
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipEHotkey gToolTipEHotkey, ?
Gui, Settings:Font, 

Gui, Settings:Add, Button, gBind vBind%NumTC% w125 yp25 xp-245, Toggle Callout: ; Toggle Callout hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumTC% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipTC gToolTipTC, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumCF% w125 yp30 xp-275, Change Focus: ; Change Focus hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumCF% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipCF gToolTipCF, ?
Gui, Settings:Font, 
Gui, Settings:Font, cGreen bold s10
Gui, Settings:Add, GroupBox, w300 h210 xs yp40, Menu Hotkeys :       OPTIONAL ;Menu Hotkeys 
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipMHotkey gToolTipMHotkey, ?
Gui, Settings:Font, 

Gui, Settings:Add, Button, gBind vBind%NumSMenu% w125 yp25 xp-245, Servers Menu: ;Server Menu hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumSMenu% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipSMenu gToolTipSMenu, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumRCall% w125 yp30 xp-275, Event Menu: ;Realm Callout hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumRCall% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipRCMenu gToolTipRCMenu, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumDCall% w125 yp30 xp-275, Dungeon Menu: ;Dungeon Callout hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumDCall% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipDCMenu gToolTipDCMenu, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumGS% w125 yp30 xp-275, Guild Speech: ; Guild Speech hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumGS% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipGSMenu gToolTipGSMenu, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumRS% w125 yp30 xp-275, Realmeye Speech: ;Realmeye Speech hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumRS% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipRSMenu gToolTipRSMenu, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumAS% w125 yp30 xp-275, Advanced Speech: ;Advanced Speech hotkey
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumAS% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipASMenu gToolTipASMenu, ?
Gui, Settings:Font, 

Gui, Settings:Tab, 3
Gui, Settings:Font, cGreen bold s10
Gui, Settings:Add, GroupBox, w300 h270 xs y97, Inventory Swapper Hotkeys : 
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipInvSwap gToolTipInvSwap, ?
Gui, Settings:Font, 


Gui, Settings:Add, Button, gBind vBind%NumS1% w125 yp25 xp-245, Slot 1: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS1% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS1 gToolTipS1, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumS2% w125 yp30 xp-275, Slot 2: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS2% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS2 gToolTipS2, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, gBind vBind%NumS3% w125 yp30 xp-275, Slot 3: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS3% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS3 gToolTipS3, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumS4% w125 yp30 xp-275, Slot 4:
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS4% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS4 gToolTipS4, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumS5% w125 yp30 xp-275, Slot 5: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS5% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS5 gToolTipS5, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumS6% w125 yp30 xp-275, Slot 6: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS6% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS6 gToolTipS6, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumS7% w125 yp30 xp-275, Slot 7: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS7% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS7 gToolTipS7, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumS8% w125 yp30 xp-275, Slot 8: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumS8% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipS8 gToolTipS8, ?
Gui, Settings:Font,

Gui, Settings:Font, cGreen bold s10
Gui, Settings:Add, GroupBox, w300 h125 xs yp40, Screenshot Uploader Hotkeys : 
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp250 vHELPBOXToolTipScreenshot gToolTipScreenshot, ?
Gui, Settings:Font,

Gui, Settings:Add, Button, gBind vBind%NumScr% w125 yp30 xp-245, Screenshot: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumScr% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipScr gToolTipScr, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumPaint% w125 yp30 xp-275, Paint: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumPaint% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipPaint gToolTipPaint, ?
Gui, Settings:Font,
Gui, Settings:Add, Button, gBind vBind%NumImgur% w125 yp30 xp-275, Imgur: 
Gui, Settings:Add, Edit, Disabled vHotkeyName%NumImgur% h20 w140 xp130, None
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp145 vHELPBOXToolTipImgur gToolTipImgur, ?
Gui, Settings:Font,

Gui, Settings:Tab
Gui, Settings:Font, 
Gui, Settings:Add, Text, ym section, Current Target Player :
Gui, Settings:Font, Norm cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipCurTP gToolTipCurTP, ?
Gui, Settings:Font, 
Gui, Settings:Add, Edit, -HScroll -VScroll h20 w130 yp21 xp-120 vCurrentPlayerEdit Disabled, %CurrentPlayer%
Gui, Settings:Font, 
Gui, Settings:Add, Text, xs, Current Teleport Player :
Gui, Settings:Font, Norm cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipCurTPP gToolTipCurTPP, ?
Gui, Settings:Font, 
Gui, Settings:Add, Edit,-HScroll -VScroll h20  w130 yp21 xp-120 vCurrentTPEdit gChangeTP, %CurrentTP%
Gui, Settings:Add, GroupBox, w130 xs, Same Player: ; or ToolTipSwitchTargetPlayer : it means if you keep a specific teleport target or not when using speech GUI
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipSwitchTP gToolTipSwitchTP, ?
Gui, Settings:Font, 
Gui, Settings:Add, DropDownList, w120 yp21 xp-115 gChangeSwitch %RecentPlayerSaved% vSwitchTeleport, Yes|No
Gui, Settings:Add, GroupBox, w130 xs, Guild/Public Callout
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipCC gToolTipCC, ?
Gui, Settings:Font, 
Gui, Settings:Add, DropDownList, w120 yp21 xp-115 %GuildCallSaved% vGuildCall gGuildChange, Guild|Public
Gui, Settings:Add, GroupBox, xs w130, Right Click
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipRC gToolTipRC, ?
Gui, Settings:Font, 
Gui, Settings:Add, DropDownList, w120 yp21 xp-115 AltSubmit vRClick gRClickSub Choose%RClick%, Ability|Double Left Click|Right Click
Gui, Settings:Add, GroupBox, xs w130, Double Right Click
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipDRC gToolTipDRC, ?
Gui, Settings:Font, 
Gui, Settings:Add, DropDownList, w120 yp21 xp-115 AltSubmit vDRClick gDRClickSub Choose%DRClick%, Keep Speedy|Nothing

Gui, Settings:Add, GroupBox, w130 xs, Custom Cursor:
Gui, Settings:Font, cBlue bold s10
Gui, Settings:Add, Text, xp120 yp-1 vHELPBOXToolTipCursor gToolTipCursor, ?
Gui, Settings:Font, 
Gui, Settings:Add, DropDownList, w120 yp21 xp-115 %CursorSaved% vcursor gChangeCursor, Yes|No
Gui, Settings:Add, GroupBox, w130 xs, Cursor Name:
Gui, Settings:Add, Edit,-HScroll -VScroll h20  w120 yp20 xp5 vCursorName Disabled, %CUSTOM_CURSOR%
Gui, Settings:Add, Button, xs+15 w100 yp50 gChangeCursorName, Change Cursor
Gui, Settings:Font, cBlue bold s13
Gui, Settings:Add, Text, xp110 vHELPBOXToolTipIGCursor gToolTipIGCursor, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, xs+15 w100 yp30 gNewPixels, Change Pixels
Gui, Settings:Font, cBlue bold s13
Gui, Settings:Add, Text, xp110 vHELPBOXToolTipCP gToolTipCP, ?
Gui, Settings:Font, 
Gui, Settings:Add, Button, xs+15 w100 yp30 h25 gSaveSettings, Save and Reload

Gui, Settings:+ToolWindow
Gui, Settings:Show, Hide ,Settings

	
MoreX := (A_ScreenWidth - 115)
Gui 6:+LabelMore +OwnerRealmBuddy
gui, More:font, 
Gui, More:Add, Button, x15  w80 h30 gServerList, Server List
Gui, More:Add, Button, x15  w80 h30 gRealmCaller, Realm Caller

Gui, More:+ToolWindow
Gui, More:Show, x%MoreX% y311 Hide, More

;;;;;;;;;;;;;;				Toggle CALL GUI					;;;;;;;;;;;;;;;;;;;;;;

Gui 7:+LabelToggleCallGUION
Gui, ToggleCallGUION:Margin,0,0
Gui, ToggleCallGuiON:Color, 363636
Gui, ToggleCallGUION:Font, S13 cWhite b w450
Gui, ToggleCallGUION:Add, Text, h20 w100 center, Guild Call
Gui, ToggleCallGUION:Add, Picture, yp-4 BackgroundTrans, files/button_bg.png
Gui, ToggleCallGUION:+ToolWindow -Caption +AlwaysOnTop
Gui, ToggleCallGUION:Show, Hide, ToogCallGuiON

Gui 8:+LabelToggleCallGUIOFF
Gui, ToggleCallGUIOFF:Margin,0,0
Gui, ToggleCallGuiOFF:Color, 363636
Gui, ToggleCallGUIOFF:Font, S13 cWhite b w450
Gui, ToggleCallGUIOFF:Add, Text, h20 w100 center, Public Call
Gui, ToggleCallGUIOFF:Add, Picture, yp-4 BackgroundTrans, files/button_bg.png
Gui, ToggleCallGuiOFF:+ToolWindow -Caption +AlwaysOnTop
Gui, ToggleCallGUIOFF:Show, Hide, ToggCallGUIOFF

;;;;;;;;;;;;;;				QUICKSPEECH GUI					;;;;;;;;;;;;;;;;;;;;;;

Gui 9:+LabelHotkeyGUI
Gui, HotkeyGUI:+ownerRealmBuddy
Gui, HotkeyGUI:Add, Tab2,h24 Buttons vQSPage AltSubmit,Page 1|Page 2|Page 3|Page 4|
Gui, HotkeyGUI:Tab
Gui, HotkeyGUI:Font, cRed bold
Gui, HotkeyGUI:Add, Text, x120 y50, HotKey
Gui, HotkeyGUI:Font, cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp50 vHELPBOXToolTipHotkey gToolTipHotkey, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Font, cRed bold
Gui, HotkeyGUI:Add, Text, x357 y50, Quick Speech Text
Gui, HotkeyGUI:Font, cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp120 vHELPBOXToolTipQSText gToolTipQSText, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Add, Text, x627 y15 w30 center, Realm`nOnly
Gui, HotkeyGUI:Font, cBlue bold s10
Gui, HotkeyGUI:Add, Text, xp35 yp5 vHELPBOXToolTipRO gToolTipRO, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Add, Button, xp-37 y45 w35 vChecker1 gCheckAll, All
Gui, HotkeyGUI:Add, Text, x677 y15 w30 center, PM`nBack
Gui, HotkeyGUI:Font, cBlue bold s10
Gui, HotkeyGUI:Add, Text, xp30 yp5 vHELPBOXToolTipTab gToolTipTab, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Add, Button, xp-37 y45 w35 vChecker2 gCheckAll2, All
ypos2 := 80
Gui, HotkeyGUI:Tab, 1
Loop 10 {
	QST := QSText%A_Index%
	RCH := RealmCheck%A_Index%
	TCH := TabCheck%A_Index%
	if A_Index = 1
	{
		Gui, HotkeyGUI:Add, Edit, Disabled vHotkeyName%A_Index% w260 x5 y%ypos2%, None
		Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 Disabled vQSText%A_Index% w260 xp+270, %QST%
		Gui, HotkeyGUI:Add, Button, gBind vBind%A_Index% yp-1 xp+270, Set Hotkey
		Gui, HotkeyGUI:Add, Checkbox, vRealmCheck%A_Index% gOptionChanged xp+90 yp+5 Checked%RCH%
		Gui, HotkeyGUI:Add, Checkbox, Disabled vTabCheck%A_Index% gOptionChanged xp+50 Checked%TCH%
	}
	else if A_Index = 2
	{
		if F5Override = 1
		{
			QST := QSText2
			TCH := TabCheck2
			Gui, HotkeyGUI:Add, Edit, Disabled w260 x5 y%ypos2%, F5 Overridden
			Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText2 w260 xp+270 gOptionChanged, %QST%
			Gui, HotkeyGUI:Add, Button, gOverride vNewBind w65 yp-1 xp+270, Infos
			Gui, HotkeyGUI:Add, Checkbox, Disabled vRealmCheck%A_Index% xp+90 yp+5 Checked
			Gui, HotkeyGUI:Add, Checkbox, vTabCheck%A_Index% gOptionChanged xp+50 Checked%TCH%
		}
		else
		{
			Gui, HotkeyGUI:Add, Edit, Disabled w260 x5 y%ypos2%, Regular F5
			Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText%A_Index% w260 xp+270 gOptionChanged, %QST%
			Gui, HotkeyGUI:Add, Button, gOverride vNewBind w65 yp-1 xp+270, Infos
			Gui, HotkeyGUI:Add, Checkbox, Disabled vRealmCheck%A_Index% gOptionChanged xp+90 yp+5 Checked%RCH%
			Gui, HotkeyGUI:Add, Checkbox, Disabled vTabCheck%A_Index% gOptionChanged xp+50 Checked%TCH%
		}
	}
	else
	{
		Gui, HotkeyGUI:Add, Edit, Disabled vHotkeyName%A_Index% w260 x5 y%ypos2%, None
		Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText%A_Index% w260 xp+270 gOptionChanged, %QST%
		Gui, HotkeyGUI:Add, Button, gBind vBind%A_Index% yp-1 xp+270, Set Hotkey
		Gui, HotkeyGUI:Add, Checkbox, vRealmCheck%A_Index% gOptionChanged xp+90 yp+5 Checked%RCH%
		Gui, HotkeyGUI:Add, Checkbox, vTabCheck%A_Index% gOptionChanged xp+50 Checked%TCH%
	}
	ypos2 += 25
}

Gui, HotkeyGUI:Tab, 2
ypos2 := 80
Loop 10 {
	A_NewIndex := A_Index + 10
	QST := QSText%A_NewIndex%
	RCH := RealmCheck%A_NewIndex%
	TCH := TabCheck%A_NewIndex%
	Gui, HotkeyGUI:Add, Edit, Disabled vHotkeyName%A_NewIndex% w260 x5 y%ypos2%, None
	Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText%A_NewIndex% w260 xp+270 gOptionChanged, %QST%
	Gui, HotkeyGUI:Add, Button, gBind vBind%A_NewIndex% yp-1 xp+270, Set Hotkey
	Gui, HotkeyGUI:Add, Checkbox, vRealmCheck%A_NewIndex% gOptionChanged xp+90 yp+5 Checked%RCH%
	Gui, HotkeyGUI:Add, Checkbox, vTabCheck%A_NewIndex% gOptionChanged xp+50 Checked%TCH%
	ypos2 += 25
}
Gui, HotkeyGUI:Tab, 3
ypos2 := 80
Loop 10 {
	A_NewIndex := A_Index + 20
	QST := QSText%A_NewIndex%
	RCH := RealmCheck%A_NewIndex%
	TCH := TabCheck%A_NewIndex%
	Gui, HotkeyGUI:Add, Edit, Disabled vHotkeyName%A_NewIndex% w260 x5 y%ypos2%, None
	Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText%A_NewIndex% w260 xp+270 gOptionChanged, %QST%
	Gui, HotkeyGUI:Add, Button, gBind vBind%A_NewIndex% yp-1 xp+270, Set Hotkey
	Gui, HotkeyGUI:Add, Checkbox, vRealmCheck%A_NewIndex% gOptionChanged xp+90 yp+5 Checked%RCH%
	Gui, HotkeyGUI:Add, Checkbox, vTabCheck%A_NewIndex% gOptionChanged xp+50 Checked%TCH%
	ypos2 += 25
}
Gui, HotkeyGUI:Tab, 4
ypos2 := 80
Loop 10 {
	A_NewIndex := A_Index + 30
	QST := QSText%A_NewIndex%
	RCH := RealmCheck%A_NewIndex%
	TCH := TabCheck%A_NewIndex%
	Gui, HotkeyGUI:Add, Edit, Disabled vHotkeyName%A_NewIndex% w260 x5 y%ypos2%, None
	Gui, HotkeyGUI:Add, Edit, -HScroll -VScroll h20 vQSText%A_NewIndex% w260 xp+270 gOptionChanged, %QST%
	Gui, HotkeyGUI:Add, Button, gBind vBind%A_NewIndex% yp-1 xp+270, Set Hotkey
	Gui, HotkeyGUI:Add, Checkbox, vRealmCheck%A_NewIndex% gOptionChanged xp+90 yp+5 Checked%RCH%
	Gui, HotkeyGUI:Add, Checkbox, vTabCheck%A_NewIndex% gOptionChanged xp+50 Checked%TCH%
	ypos2 += 25
}
Gui, HotkeyGUI:Tab
Gui, HotkeyGUI:Font, bold
Gui, HotkeyGUI:Add, Checkbox, gOptionChanged vChecktrade x20 yp+30 Checked%Checktrade%, /tr => /trade 
Gui, HotkeyGUI:Font, Norm cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp100 vHELPBOXToolTipTR gToolTipTR, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Font, bold
Gui, HotkeyGUI:Add, Checkbox, gOptionChanged vChecktp yp+2 xp+50 Checked%Checktp%, /tp => /teleport 
Gui, HotkeyGUI:Font, Norm cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp130 vHELPBOXToolTipTP gToolTipTP, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Font, bold
Gui, HotkeyGUI:Add, Checkbox, gOptionChanged vChecknexus xp+50 yp+2 Checked%Checknexus%, @@@ => /nexustutorial 
Gui, HotkeyGUI:Font, Norm cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp170 vHELPBOXToolTipNT gToolTipNT, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Font, bold
Gui, HotkeyGUI:Add, Checkbox, gOptionChanged vCheckignore xp+50 yp+2 Checked%Checkignore%, /ignr => /ignore 
Gui, HotkeyGUI:Font, Norm cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp130 vHELPBOXToolTipIG gToolTipIG, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Font, bold
Gui, HotkeyGUI:Add, Checkbox, gOptionChanged vCheckrandom x20 yp+25 Checked%Checkrandom%, Activate Macro.ini
Gui, HotkeyGUI:Font, Norm cBlue bold s10
Gui, HotkeyGUI:Add, Text, yp-2 xp130 vHELPBOXToolTipRD gToolTipRD, ?
Gui, HotkeyGUI:Font, 
Gui, HotkeyGUI:Add, Button, x350 yp0 gSaveSettings3, Save and Reload

Gui, HotkeyGUI:+ToolWindow
Gui, HotkeyGUI:Show, Hide Center w730 , Quick Speech GUI

;;;;;;;;;;;;;;				SERVER LIST INGAME MENU					;;;;;;;;;;;;;;;;;;;;;;

Gui 21:+LabelServersGUI
Gui, ServersGUI:Margin,0,0
Gui, ServersGUI:Font, S14 cWhite b
Gui, ServersGUI:Add, Text, w105 h40 Left, %A_SPACE% Server List:

Gui, ServersGUI:Font, S10 c84E060 w1000
Gui, ServersGUI:Add, Text,vRealmGUI yp5 xp105 w215 h20 Right,%server%
Gui, ServersGUI:Add, Picture, xp-105 yp-9 h30  BackgroundTrans,files/servers_bg.png

Gui, ServersGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, ServersGUI:Show, Hide, ServersGUI

;;;;;;;;;;;;;;				EU SERVERS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServersGUI:Margin,0,10 
Gui, ServersGUI:Font, S10 cWhite w450
Gui, ServersGUI:Add, Text,	 gEUW h20 w100 yp40 center, EUWest
Gui, ServersGUI:Add, Picture,gEUW yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUW2 h20 w100 center, EUWest2
Gui, ServersGUI:Add, Picture,gEUW2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUS h20 w100 center, EUSouth
Gui, ServersGUI:Add, Picture,gEUS yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUSW h20 w100 center, EUSouthWest
Gui, ServersGUI:Add, Picture,gEUSW yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUN h20 w100 center, EUNorth
Gui, ServersGUI:Add, Picture,gEUN yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUN2 h20 w100 center, EUNorth2
Gui, ServersGUI:Add, Picture,gEUN2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gEUE h20 w100 center, EUEast
Gui, ServersGUI:Add, Picture,gEUE yp-4 BackgroundTrans, files/button_bg.png

;;;;;;;;;;;;;;				US SERVERS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServersGUI:Add, Text,	 gUSW h20 xp+110 yp-182 w100 center, USWest
Gui, ServersGUI:Add, Picture,gUSW yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSW2 h20 w100 center, USWest2
Gui, ServersGUI:Add, Picture,gUSW2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSW3 h20 w100 center, USWest3
Gui, ServersGUI:Add, Picture,gUSW3 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSE h20 w100 center, USEast
Gui, ServersGUI:Add, Picture,gUSE yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSE2 h20 w100 center, USEast2
Gui, ServersGUI:Add, Picture,gUSE2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSE3 h20 w100 center, USEast3
Gui, ServersGUI:Add, Picture,gUSE3 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSS h20 w100 center, USSouth
Gui, ServersGUI:Add, Picture,gUSS yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSS2 h20 w100 center, USSouth2
Gui, ServersGUI:Add, Picture,gUSS2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSS3 h20 w100 center, USSouth3
Gui, ServersGUI:Add, Picture,gUSS3 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSSW h20 w100 center, USSouthWest
Gui, ServersGUI:Add, Picture,gUSSW yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSMW h20 w100 center, USMidWest
Gui, ServersGUI:Add, Picture,gUSMW yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSMW2 h20 w100 center, USMidWest2
Gui, ServersGUI:Add, Picture,gUSMW2 yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gUSNW h20 w100 center, USNorthWest
Gui, ServersGUI:Add, Picture,gUSNW yp-4 BackgroundTrans, files/button_bg.png

;;;;;;;;;;;;;;				ASIA SERVERS					;;;;;;;;;;;;;;;;;;;;;;

Gui, ServersGUI:Add, Text,	 gASE h20 xp+110 yp-368 w100 center, AsiaSouthEast
Gui, ServersGUI:Add, Picture,gASE yp-4 BackgroundTrans, files/button_bg.png
Gui, ServersGUI:Add, Text,	 gAE h20 w100 center vAE, AsiaEast
Gui, ServersGUI:Add, Picture,gAE yp-4 BackgroundTrans, files/button_bg.png

Gui, ServersGUI:Font, S9
Gui, ServersGUI:Color, 363636

Gui, ServersGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, ServersGUI:Show, Hide w320 h430, ServGUI

;;;;;;;;;;;;;;				REALM EVENT INGAME GUI					;;;;;;;;;;;;;;;;;;;;;;

Gui 22:+LabelEventsGUI
Gui, EventsGUI:Add, Picture,gHermit w50 h50,quests/hermit.png
Gui, EventsGUI:Add, Picture,gSphinx w50 h50 xp75, quests/sphinx.png
Gui, EventsGUI:Add, Picture,gShip w50 h50 xp75, quests/ship.png
Gui, EventsGUI:Add, Picture,gLord w50 h50 xp75, quests/lord.png
Gui, EventsGUI:Add, Picture,gAvatar w50 h50 xp75, quests/avatar.png
Gui, EventsGUI:Add, Picture,gDragon w50 h50 xp75, quests/dragon.png
Gui, EventsGUI:Add, Picture,gLDjinn w50 h50 xp75, quests/ldjinn.png
Gui, EventsGUI:Add, Picture,gLEnt w50 h50 xp75, quests/lent.png
Gui, EventsGUI:Add, Picture,gCrystal w50 h50 xp75, quests/crystal.png
Gui, EventsGUI:Add, Picture,gKage w50 h50 xp75, quests/kage.png

Gui, EventsGUI:Add, Picture,gTrench w30 h30 xp-670 yp50, dungeons/trench.png
Gui, EventsGUI:Add, Picture,gTomb w30 h30 xp60, dungeons/tomb.png
Gui, EventsGUI:Add, Picture,gNOTomb w30 h30 xp30, dungeons/no.png
Gui, EventsGUI:Add, Picture,gDJL w30 h30 xp45, dungeons/djl.png
Gui, EventsGUI:Add, Picture,gNODJL w30 h30 xp30, dungeons/no.png
Gui, EventsGUI:Add, Picture,gIce w30 h30 xp45, dungeons/ice.png
Gui, EventsGUI:Add, Picture,gNOIce w30 h30 xp30, dungeons/no.png
Gui, EventsGUI:Add, Picture,gShatters w30 h30 xp45, dungeons/shatters.png
Gui, EventsGUI:Add, Picture,gNOShatters w30 h30 xp30, dungeons/no.png
Gui, EventsGUI:Add, Picture,gLoD w30 h30 xp45, dungeons/LoD.png
Gui, EventsGUI:Add, Picture,gNOLoD w30 h30 xp30, dungeons/no.png
Gui, EventsGUI:Add, Picture,gDEPTHS w30 h30 xp60, dungeons/depths.png
Gui, EventsGUI:Add, Picture,gWOOD w30 h30 xp75, dungeons/woodland.png
Gui, EventsGUI:Add, Picture,gDOCKS w30 h30 xp75, dungeons/docks.png
Gui, EventsGUI:Add, Picture,gManor w30 h30 xp75, dungeons/manor.png

Gui, EventsGUI:Add, Picture,gCube w50 h50 xp-680 yp40, quests/cube.png
Gui, EventsGUI:Add, Picture,gShrine w50 h50 xp75, quests/shrine.png
Gui, EventsGUI:Add, Picture,gPentaract w50 h50 xp75, quests/pent.png
Gui, EventsGUI:Add, Picture,gEnt w50 h50 xp75, quests/ent.png
Gui, EventsGUI:Add, Picture,gLich w50 h50 xp75, quests/lich.png
Gui, EventsGUI:Add, Picture,gWC w50 h50 xp75, quests/oryx.png
Gui, EventsGUI:Add, Picture,gClosed w50 h50 xp75, quests/closed.png
Gui, EventsGUI:Add, Picture,gShake w50 h50 xp75, quests/shake.png
Gui, EventsGUI:Add, Picture,gLastOne w50 h50 xp75, quests/again.png
Gui, EventsGUI:Add, Picture,vGuildPub gPubGuild w50 h50 xp75, quests/%PG%.png

Gui, EventsGUI:Add, Picture,gshaitan w50 h50 xp-680 yp60, quests/shaitan.png
Gui, EventsGUI:Add, Picture,gcland w50 h50 xp75, dungeons/cland.png
Gui, EventsGUI:Add, Picture,gabyss w50 h50 xp75, dungeons/abyss.png
Gui, EventsGUI:Add, Picture,gudl w50 h50 xp75, dungeons/udl.png
Gui, EventsGUI:Add, Picture,gsprite w50 h50 xp75, dungeons/sprite.png
Gui, EventsGUI:Add, Picture,gcemetary w50 h50 xp75, dungeons/cem.png
Gui, EventsGUI:Add, Picture,gpuppet w50 h50 xp75, dungeons/puppet.png
Gui, EventsGUI:Add, Picture,gsnake w50 h50 xp75, dungeons/snake.png
Gui, EventsGUI:Add, Picture,glab w50 h50 xp75, dungeons/lab.png
Gui, EventsGUI:Add, Picture,gpirate w50 h50 xp75, dungeons/pcave.png

Gui, EventsGUI:Add, Text, yp70 xp-680, Current Realm :
Gui, EventsGUI:Add, DropDownList, vRChoice gChoiceRealm xp80 yp0, Left_Bazaar|Right_Bazaar|Guild_Hall|Nexus|Beholder|Medusa|Cyclops|Golem|Ogre|Blob|Impd|Djinn|Flayer
Gui, EventsGUI:Add, Text, yp0 xp140, Server :
Gui, EventsGUI:Add, DropDownList, vSChoice gChoiceServer xp45 yp0, EuWest|EuWest2|EuSouth|EuEast|EuNorth|EuNorth2|EuSouthWest|AsiaEast|AsiaSouthEast|USWest|USWest2|USWest3|USEast|USEast2|USEast3|USSouth|USSouth2|USSouth3|USMidWest|USMidWest2|USSouthWest|USNorthWest

Gui, EventsGUI:Color, 363636
Gui, EventsGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, EventsGUI:Show, Hide, EventsGUI
WinSet, TransColor, 363636 220, EventsGUI

;;;;;;;;;;;;;;				SPEECH INGAME GUI					;;;;;;;;;;;;;;;;;;;;;;

Gui 23:+LabelSpeechGUI
Gui, SpeechGUI:Margin,0,0
Gui, SpeechGUI:Font, S14 c84E060
Gui, SpeechGUI:Add, Text, vSpeechPlayer xp5 h20 w321 Center ,Player Name is : %CurrentPlayer%
Gui, SpeechGUI:Add, Picture,  yp-4 h30  BackgroundTrans,files/servers_bg.png

Gui, SpeechGUI:Margin,0,10 
Gui, SpeechGUI:Font, S10 cWhite w450
Gui, SpeechGUI:Add, Text,	 gChangePlayer xp50 h20 w100 yp50 center, Change Player
Gui, SpeechGUI:Add, Picture,gChangePlayer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gAutomaticChangePlayer h20 w100 xp120 yp4 center, Automatic
Gui, SpeechGUI:Add, Picture,gAutomaticChangePlayer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gTradePlayer h20 w100 yp50 xp-120 center, Trade
Gui, SpeechGUI:Add, Picture,gTradePlayer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gTellPlayer h20 w100 xp120 yp4 center, Tell
Gui, SpeechGUI:Add, Picture,gTellPlayer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gTeleportPlayer h20 w100 yp40 xp-120 center, Teleport
Gui, SpeechGUI:Add, Picture,gTeleportPlayer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gTeleportPlayer10 h20 w100 xp120 yp4 center, Teleport 10 X
Gui, SpeechGUI:Add, Picture,gTeleportPlayer10 yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gIgnore h20 w100 yp50 xp-120 center, Ignore
Gui, SpeechGUI:Add, Picture,gIgnore yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gUnIgnore h20 w100 xp120 yp4 center, UnIgnore
Gui, SpeechGUI:Add, Picture,gUnIgnore yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gCheater h20 w100 yp40 xp-120 center, Cheater
Gui, SpeechGUI:Add, Picture,gCheater yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gNotCheater h20 w100 xp120 yp4 center, Not Cheater
Gui, SpeechGUI:Add, Picture,gNotCheater yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gScammer h20 w100 yp40 xp-120 center, Scammer
Gui, SpeechGUI:Add, Picture,gScammer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gNotScammer h20 w100 xp120 yp4 center, Not Scammer
Gui, SpeechGUI:Add, Picture,gMates yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gMates h20 w100 yp50 xp-120 center, Mates
Gui, SpeechGUI:Add, Picture,gFriends yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gFriends h20 w100 xp120 yp4 center, Friends
Gui, SpeechGUI:Add, Picture,gNotScammer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gMyStats h20 w100 yp50 xp-120 center, My Stats
Gui, SpeechGUI:Add, Picture,gMyStats yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gLeftToMax h20 w100 xp120 yp4 center, Left To Max
Gui, SpeechGUI:Add, Picture,gLeftToMax yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gWho h20 w100 yp50 xp-120 center, Who
Gui, SpeechGUI:Add, Picture,gWho yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gMyServer h20 w100 xp120 yp4 center, My Server
Gui, SpeechGUI:Add, Picture,gMyServer yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gHideGuild h20 w100 yp50 xp-120 center, Hide my Guild
Gui, SpeechGUI:Add, Picture,gHideGuild yp-4 BackgroundTrans, files/button_bg.png
Gui, SpeechGUI:Add, Text,	 gRealmEyeMe h20 w100 xp120 yp4 center, RealmEye
Gui, SpeechGUI:Add, Picture,gRealmEyeMe yp-4 BackgroundTrans, files/button_bg.png

Gui, SpeechGUI:Font, S9
Gui, SpeechGUI:Color, 363636

Gui, SpeechGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, SpeechGUI:Show, Hide, SpeechGUI
WinSet, TransColor, 363636 220, SpeechGUI

;;;;;;;;;;;;;;				Explanations					;;;;;;;;;;;;;;;;;;;;;;

Gui 24:+LabelBuiltIn
Gui, BuiltIn:+OwnerSettings
Gui, BuiltIn:Font, bold
Gui, BuiltIn:Add, Text, cRed, - Changing Delete Binding Key :
Gui, BuiltIn:Font, 
Gui, BuiltIn:Add, Text, yp0 xp500, Click on the blue links to open them :)
Gui, BuiltIn:Add, Text, yp20 xp-480, Go to the .ini and change the DeleteBinding in Settings to the key you want
Gui, BuiltIn:Add, Text, yp20 xp0, You need to write the key in AHK language meaning as in this url
Gui, BuiltIn:Font, Norm bold
Gui, BuiltIn:Add, Text, cBlue gAHKLink yp20 xp0, https://www.autohotkey.com/docs/KeyList.htm
Gui, BuiltIn:Font,
Gui, BuiltIn:Font, bold
Gui, BuiltIn:Add, Text, yp20 xp-20 cRed, - Right Click Button :
Gui, BuiltIn:Font, 
Gui, BuiltIn:Add, Text, yp20 xp20, - Double Click => Triggers SHIFT + Left Click (so it keeps Speedy for Ninja)
Gui, BuiltIn:Add, Text, yp20 xp0, - Single Click => Triggers Ability Key or Double Left Click then Right Click (so it doesn't interfere with the Right Click function) or Right Click
Gui, BuiltIn:Font, bold
Gui, BuiltIn:Add, Text, yp20 xp-20 cRed, - Change Server :
Gui, BuiltIn:Font, 
Gui, BuiltIn:Add, Text, yp20 xp20, - Single Click => Change Server and sends you to Nexus with the same character
Gui, BuiltIn:Add, Text, yp20 xp0, - Double Click => Change Server but stops on Character Selection so you can change character
Gui, BuiltIn:Font, bold
Gui, BuiltIn:Add, Text, yp20 xp-20 cRed, - Server Commands :
Gui, BuiltIn:Font, 
Gui, BuiltIn:Add, Text, yp20 xp20, Writing /euw + Space (or Enter) will switch server to EU West
Gui, BuiltIn:Add, Text, yp20 xp0, Writing /!euw + Space (or Enter) will switch server to EU West but stops on Character Selection 
Gui, BuiltIn:Add, Text, yp20 xp0, - Europe : /euw - /euw2 - /eus - /eusw - /eun -/eun2 - /eue
Gui, BuiltIn:Add, Text, yp20 xp0, - US : /usw - /usw2 - /use - /use2 - /use3 - /uss - /uss2 - /uss3 - /ussw - /usmw - /usmw2 - /usnw
Gui, BuiltIn:Add, Text, yp20 xp0, - Asia : /ae - /ase
Gui, BuiltIn:Font, bold
Gui, BuiltIn:Add, Text, yp20 xp-20 cRed, - Is it Allowed by Kabam ? :
Gui, BuiltIn:Font, 
Gui, BuiltIn:Add, Text, yp20 xp20, Kabam is a big company who need to have strict rules so that the staff hired in Support for example can act efficiently.
Gui, BuiltIn:Add, Text, yp20 xp0, Taking that in account explain why they won't ever officially allow any third-party as useful as it could be for simple reasons
Gui, BuiltIn:Add, Text, yp20 xp0, They don't want to put the ressources to check those tools and they want to protect themselves against anything possible.
Gui, BuiltIn:Add, Text, yp20 xp0, But that being said they are unofficially ok with some of those tools. DashAhead even said (at 17:00) : 
Gui, BuiltIn:Font, italic
Gui, BuiltIn:Add, Text, yp20 xp0, "we know that a lot of these tools are completely innocuous but sadly we can't be drawing a line like that that isn't easily perceivable by any given forum member"
Gui, BuiltIn:Font, Norm bold
Gui, BuiltIn:Add, Text, cBlue gPasteBinLink yp20 xp0, http://pastebin.com/PZrbiUvQ
Gui, BuiltIn:Font,
Gui, BuiltIn:+ToolWindow
Gui, BuiltIn:Show, Hide, Built-In Functions

;;;;;;;;;;;;;;				Help					;;;;;;;;;;;;;;;;;;;;;;

Gui 24:+LabelRBFAQ
Gui, RBFAQ:+OwnerSettings
Gui, RBFAQ:Font, bold
Gui, RBFAQ:Add, Text, cRed, - I can't use Escape as a Hotkey ! :
Gui, RBFAQ:Font, 
Gui, RBFAQ:Add, Text, yp0 xp500, Click on the blue links to open them :)
Gui, RBFAQ:Add, Text, yp20 xp-480, Go to the .ini and change the DeleteBinding in Settings to the key you want
Gui, RBFAQ:Add, Text, yp20 xp0, You need to write the key in AHK language meaning as in this url
Gui, RBFAQ:Font, Norm bold
Gui, RBFAQ:Add, Text, cBlue gAHKLink yp20 xp0, https://www.autohotkey.com/docs/KeyList.htm
Gui, RBFAQ:Font,
Gui, RBFAQ:Font, bold
Gui, RBFAQ:Add, Text, yp20 xp-20 cRed, - My Key isn't recorded ! :
Gui, RBFAQ:Font, 
Gui, RBFAQ:Add, Text, yp20 xp20, It happens with Mouse Buttons/Shift/Control/Alt right ?
Gui, RBFAQ:Add, Text, yp20 xp0, If you use a lonely Shift/Ctrl/Alt just press it then press Escape (or whatever your DeleteBinding Key is)
Gui, RBFAQ:Add, Text, yp20 xp0, If you want Alt + Left Mouse just press both and press Escape at same time
Gui, RBFAQ:Font, bold
Gui, RBFAQ:Add, Text, yp20 xp-20 cRed, - Is it Allowed by Kabam ? :
Gui, RBFAQ:Font, 
Gui, RBFAQ:Add, Text, yp20 xp20, Kabam is a big company who need to have strict rules so that the staff hired in Support for example can act efficiently.
Gui, RBFAQ:Add, Text, yp20 xp0, Taking that in account explain why they won't ever officially allow any third-party as useful as it could be for simple reasons
Gui, RBFAQ:Add, Text, yp20 xp0, They don't want to put the ressources to check those tools and they want to protect themselves against anything possible.
Gui, RBFAQ:Add, Text, yp20 xp0, But that being said they are unofficially ok with some of those tools. DashAhead even said (at 17:00) : 
Gui, RBFAQ:Font, italic
Gui, RBFAQ:Add, Text, yp20 xp0, "we know that a lot of these tools are completely innocuous but sadly we can't be drawing a line like that that isn't easily perceivable by any given forum member"
Gui, RBFAQ:Font, Norm bold
Gui, RBFAQ:Add, Text, cBlue gPasteBinLink yp20 xp0, http://pastebin.com/PZrbiUvQ
Gui, RBFAQ:Font,
Gui, RBFAQ:+ToolWindow
Gui, RBFAQ:Show, Hide, Built-In Functions

;;;;;;;;;;;;;;				HUD GUI					;;;;;;;;;;;;;;;;;;;;;;

Gui 25:+LabelHUD
Gui, HUD:+LastFound -Caption +ToolWindow +AlwaysOnTop
Gui, HUD:Add, Picture, vHUD1 gSlot1 x0 y60 w70 h50, files/%Slot1%.png
Gui, HUD:Add, Picture, vHUD2 gSlot2 xp+85 yp-55 w70 h50, files/%Slot2%.png
Gui, HUD:Add, Picture, vHUD3 gSlot3 xp+85 yp0 w70 h50, files/%Slot3%.png
Gui, HUD:Add, Picture, vHUD4 gSlot4 xp+85 yp+55 w70 h50, files/%Slot4%.png
Gui, HUD:Add, Picture, vHUD5 gSlot5 xp0 yp+55 w70 h50, files/%Slot5%.png
Gui, HUD:Add, Picture, vHUD6 gSlot6 xp0 yp+55 w70 h50, files/%Slot6%.png
Gui, HUD:Add, Picture, vHUD7 gSlot7 xp-85 yp+55 w70 h50, files/%Slot7%.png
Gui, HUD:Add, Picture, vHUD8 gSlot8 xp-85 yp0 w70 h50, files/%Slot8%.png
Gui, HUD:Add, Picture, vHUD9 gSlot9 xp-85 yp-55 w70 h50, files/%Slot9%.png
Gui, HUD:Add, Picture, vHUD10 gSlot10 xp0 yp-55 w70 h50, files/%Slot10%.png
Gui, HUD:Font, S14 c84E060
Gui, HUD:Add, Text, vHUDPlayer yp200 xp0 w321 Center ,Player Name is :  %CurrentPlayer%
Gui, HUD:Add, Picture,  yp-4 h30 BackgroundTrans,files/servers_bg.png
Loop 10
{
	if Slot%A_Index% = Nothing
	{
		GuiControl, HUD:Hide, HUD%A_Index%
	}
}
Gui, HUD:Color, 363636
WinSet, TransColor, 363636
Gui, HUD:Show, Hide

;;;;;;;;;;;;;;				HUD SETTINGS					;;;;;;;;;;;;;;;;;;;;;;

Gui 26:+LabelHUDEdit
Gui, HUDEdit:+OwnerRealmBuddy
Gui, HUDEdit:Margin, 10, 10
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc1 x20 y70 w70 h50, files/%Slot1%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc2 xp+85 yp-55 w70 h50, files/%Slot2%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc3 xp+85 yp0 w70 h50, files/%Slot3%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc4 xp+85 yp+55 w70 h50, files/%Slot4%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc5 xp0 yp+55 w70 h50, files/%Slot5%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc6 xp0 yp+55 w70 h50, files/%Slot6%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc7 xp-85 yp+55 w70 h50, files/%Slot7%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc8 xp-85 yp0 w70 h50, files/%Slot8%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc9 xp-85 yp-55 w70 h50, files/%Slot9%.png
Gui, HUDEdit:Add, Picture, gHUDPic2 vHUDc10 xp0 yp-55 w70 h50, files/%Slot10%.png

Gui, HUDEdit:Font, s10
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg1 x400 y0 w70 h60, files/Nothing.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Nothing
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg2 yp60 xp-80 w70 h60, files/OtherKeySub1.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Change Server
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg3 yp60 xp-80 w70 h60, files/OtherKeySub2.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Call Out
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg4 yp60 xp-80 w70 h60, files/OtherKeySub12.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Speech
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg5 yp60 xp-80 w70 h60, files/MyServer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, My Server
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg6 yp60 xp-80 w70 h60, files/Mates.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Guild Mates
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg7 yp60 xp-80 w70 h60, files/Friends.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, RealmEye Friends
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg8 yp60 xp-80 w70 h60, files/HideGuild.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Hide My Guild
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg9 yp60 xp-80 w70 h60, files/HideMe.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Hide Me

Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg10 x700 y0 w70 h60, files/AutomaticChangePlayer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Change Player Auto
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg11 yp60 xp-80 w70 h60, files/ChangePlayer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Change Player Manual
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg12 yp60 xp-80 w70 h60, files/Cheater.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Cheater
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg13 yp60 xp-80 w70 h60, files/NotCheater.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Not Cheater
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg14 yp60 xp-80 w70 h60, files/Scammer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Scammer
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg15 yp60 xp-80 w70 h60, files/NotScammer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Not Scammer
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg16 yp60 xp-80 w70 h60, files/Ignore.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Ignore
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg17 yp60 xp-80 w70 h60, files/UnIgnore.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, UnIgnore
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg18 yp60 xp-80 w70 h60, files/Who.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Who ?

Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg19 x1000 y0 w70 h50, files/TeleportPlayer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Teleport
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg20 yp60 xp-80 w70 h60, files/TeleportPlayer10.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Teleport X10
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg21 yp60 xp-80 w70 h60, files/TellPlayer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Tell
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg22 yp60 xp-80 w70 h60, files/TradePlayer.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Trade
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg23 yp60 xp-80 w70 h60, files/RealmEyeMe.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, RealmEye Me
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg24 yp60 xp-80 w70 h60, files/MyStats.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, My Stats
Gui, HUDEdit:Add, Picture, gHUDPic vHUDimg25 yp60 xp-80 w70 h60, files/LeftToMax.png
Gui, HUDEdit:Add, Text, xp80 yp20 cRed, Left To Max
Gui, HUDEdit:Add, Button, yp+150 xp-50 gSaveSettings3, Save and Reload

Gui, HUDEdit:Show, Hide, HUD Settings

;;;;;;;;;;;;;;				REALM CALLS INGAME MENU					;;;;;;;;;;;;;;;;;;;;;;

Gui 27:+LabelCallsGUI
Gui, CallsGUI:Add, Picture,gHelives w50 h50,quests/thessal.png
Gui, CallsGUI:Add, Picture,gReady w50 h50 xp60,quests/ghost.png
Gui, CallsGUI:Add, Picture,gMrat w50 h50 xp60,quests/mrat.png
Gui, CallsGUI:Add, Picture,gBlack w50 h50 xp60, quests/black.png
Gui, CallsGUI:Add, Picture,gRed w50 h50 xp60, quests/red.png
Gui, CallsGUI:Add, Picture,gBlue w50 h50 xp60, quests/blue.png
Gui, CallsGUI:Add, Picture,gGreen w50 h50 xp60, quests/green.png
Gui, CallsGUI:Add, Picture,gSkip w50 h50 xp60, quests/shaitan.png
Gui, CallsGUI:Add, Picture,gSarc w50 h50 xp60, quests/sarc.png
Gui, CallsGUI:Add, Picture,gTroom w50 h50 xp60, quests/troom.png
Gui, CallsGUI:Add, Picture,gBes w50 h50 xp60, quests/bes.png
Gui, CallsGUI:Add, Picture,gNut w50 h50 xp60, quests/nut.png
Gui, CallsGUI:Add, Picture,gGeb w50 h50 xp60, quests/geb.png
Gui, CallsGUI:Color, 363636
Gui, CallsGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, CallsGUI:Show, Hide, CallsGUI
WinSet, TransColor, 363636 220, CallsGUI


;;;;;;;;;;;;;;              MASTER RAT GUI                      ;;;;;;;;;;;;;;;;;;;;;;

Gui 29:+LabelMratGUI
Gui, MratGUI:Add, Button, gAnswer1, What time is it?
Gui, MratGUI:Add, Button, gAnswer2, Where is the safest place in the world? 
Gui, MratGUI:Add, Button, gAnswer3, What is fast, quiet and hidden by the night? 
Gui, MratGUI:Add, Button, gAnswer4, How do you like your pizza? 
Gui, MratGUI:Add, Button, gAnswer5, Who did this to me? 
Gui, MratGUI:Color, 363636
Gui, MratGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, MratGUI:Show, Hide, MratGUI
WinSet, TransColor, 363636 220, MratGUI

;;;;;;;;;;;;;;				MACRO INGAME MENU					;;;;;;;;;;;;;;;;;;;;;;

Gui 28:+LabelMacroGUI
Gui, MacroGUI:Add, Picture,gLife w60 h60,macro/life.png
Gui, MacroGUI:Add, Picture,gMana w60 h60 xp75,macro/mana.png
Gui, MacroGUI:Add, Picture,gBoost w60 h60 xp75,macro/boost.png
Gui, MacroGUI:Add, Picture,gThanks w60 h60 xp75, macro/thanks.png
Gui, MacroGUI:Add, Picture,gSorry w60 h60 xp75, macro/sorry.png
Gui, MacroGUI:Add, Picture,gNp w60 h60 xp75, macro/np.png
Gui, MacroGUI:Add, Picture,gGl w60 h60 xp75, macro/gl.png
Gui, MacroGUI:Add, Picture,gStop w60 h60 xp75, macro/stop.png
Gui, MacroGUI:Add, Picture,gGo w60 h60 xp75, macro/go.png
Gui, MacroGUI:Add, Picture,gHelp w60 h60 xp75, macro/help.png
Gui, MacroGUI:Color, 363636
Gui, MacroGUI:+ToolWindow -Caption +AlwaysOnTop
Gui, MacroGUI:Show, Hide, MacroGUI
WinSet, TransColor, 363636 220, MacroGUI

;;;;;;;;;;;;;;				EU Servers List					;;;;;;;;;;;;;;;;;;;;;;

Menu, EUmenu, Add, EUWest, EUW
Menu, EUmenu, Add, EUWest2,  EUW2
Menu, EUmenu, Add, EUSouth,  EUS
Menu, EUmenu, Add, EUSouthWest, EUSW
Menu, EUmenu, Add, EUNorth, EUN
Menu, EUmenu, Add, EUNorth2, EUN2
Menu, EUmenu, Add, EUEast, EUE

Menu, ServersMenu, Add, EU Servers, :EUmenu

;;;;;;;;;;;;;;				US Servers List					;;;;;;;;;;;;;;;;;;;;;;

Menu, USmenu, Add, USWest, USW
Menu, USmenu, Add, USWest2, USW2
Menu, USmenu, Add, USWest3, USW3
Menu, USmenu, Add, USEast, USE
Menu, USmenu, Add, USEast2, USE2
Menu, USmenu, Add, USEast3, USE3
Menu, USmenu, Add, USSouth, USS
Menu, USmenu, Add, USSouth2, USS2
Menu, USmenu, Add, USSouth3, USS3
Menu, USmenu, Add, USSouthWest, USSW
Menu, USmenu, Add, USMidWest, USMW
Menu, USmenu, Add, USMidWest2, USMW2
Menu, USmenu, Add, USNorthWest, USNW

Menu, ServersMenu, Add, US, :USmenu

;;;;;;;;;;;;;;				ASIA/Australia Servers List					;;;;;;;;;;;;;;;;;;;;;;

Menu, ASIAmenu, Add, AsiaSouthEast, ASE
Menu, ASIAmenu, Add, AsiaEast, AE
Menu, ASIAmenu, Add, Australia, AUS

Menu, ServersMenu, Add, ASIA, :ASIAmenu

;;;;;;;;;;;;;;				Realm Caller Menu					;;;;;;;;;;;;;;;;;;;;;;

Menu, RealmCaller, Add, Grand Sphinx, Sphinx
Menu, RealmCaller, Add, Hermit God, Hermit
Menu, RealmCaller, Add, Crystal, Crystal
Menu, RealmCaller, Add, Wine Cellar, WC
Menu, RealmCaller, Add, Lich, Lich
Menu, RealmCaller, Add, Ent, Ent
Menu, RealmCaller, Add, Ghost Ship, Ship
Menu, RealmCaller, Add, Lord, Lord
Menu, RealmCaller, Add, Cube, Cube
Menu, RealmCaller, Add, Shrine, Shrine
Menu, RealmCaller, Add, Pentaract, Pentaract
Menu, RealmCaller, Add, Rock Dragon, Dragon
Menu, RealmCaller, Add, Avatar of the Forgotten King, Avatar

;;;;;;;;;;;;;;				Dungeon Caller Menu					;;;;;;;;;;;;;;;;;;;;;;

Menu, DungeonCaller, Add, Pirate Cave, Pirate
Menu, DungeonCaller, Add, Abyss of Demons, Abyss
Menu, DungeonCaller, Add, Undead Lair, UDL
Menu, DungeonCaller, Add, Mad Lab, Lab
Menu, DungeonCaller, Add, Snake Pit, Snake
Menu, DungeonCaller, Add, Manor of the Immortals, Manor
Menu, DungeonCaller, Add, Haunted Cemetary, Cemetary
Menu, DungeonCaller, Add, Puppet Master's Theatre, Puppet
Menu, DungeonCaller, Add, Ice Cave, Ice
Menu, DungeonCaller, Add, Davy Jones's Locker, DJL
Menu, DungeonCaller, Add, Tomb of the Ancients, Tomb
Menu, DungeonCaller, Add, Ocean Trench, Trench
Menu, DungeonCaller, Add, Lair of Draconis, LoD
Menu, DungeonCaller, Add, The Shatters, Shatters

;;;;;;;;;;;;;;				Advanced Speech Menu					;;;;;;;;;;;;;;;;;;;;;;

Menu, AdvancedSpeech, Add, Trade %CurrentPlayer%, TradePlayer
Menu, AdvancedSpeech, Add, Teleport %CurrentPlayer%, TeleportPlayer
Menu, AdvancedSpeech, Add, Teleport 10X %CurrentPlayer%, TeleportPlayer10
Menu, AdvancedSpeech, Add, Tell %CurrentPlayer%, TellPlayer
Menu, AdvancedSpeech, Add, Automatic Change Targeted Player, AutomaticChangePlayer
Menu, AdvancedSpeech, Add, Change Targeted Player, ChangePlayer
Menu, AdvancedSpeech, Add, Instant Trade is %instant%, InstantTrade

;;;;;;;;;;;;;;				Realmeye Tag Menu					;;;;;;;;;;;;;;;;;;;;;;

Menu, RealmeyeSpeech, Add, TAG        %CurrentPlayer% as Cheater, Cheater
Menu, RealmeyeSpeech, Add, UNTAG  %CurrentPlayer% as Cheater, NotCheater
Menu, RealmeyeSpeech, Add, TAG        %CurrentPlayer% as Scammer, Scammer
Menu, RealmeyeSpeech, Add, UNTAG  %CurrentPlayer% as Scammer, NotScammer
Menu, RealmeyeSpeech, Add, IGNORE        %CurrentPlayer%, Ignore
Menu, RealmeyeSpeech, Add, UNIGNORE  %CurrentPlayer%, UnIgnore
Menu, RealmeyeSpeech, Add, Automatic Change Targeted Player, AutomaticChangePlayer
Menu, RealmeyeSpeech, Add, Change Targeted Player, ChangePlayer

;;;;;;;;;;;;;;				Guild Speech Menu					;;;;;;;;;;;;;;;;;;;;;;

Menu, GuildSpeech, Add, Guild Mates, Mates
Menu, GuildSpeech, Add, Friends, Friends
Menu, GuildSpeech, Add, Hide my Guild, HideGuild
Menu, GuildSpeech, Add, Who, Who
Menu, GuildSpeech, Add, My Stats, MyStats
Menu, GuildSpeech, Add, Left To Max, LeftToMax
Menu, GuildSpeech, Add, My Server, MyServer

;;;;;;;;;;;;;;				Switch Teleport Button					;;;;;;;;;;;;;;;;;;;;;;

if SwitchTeleport=Yes
{
	GuiControl, Settings:Disable, CurrentTPEdit
}

;;;;;;;;;;;;;;				Tray Icon					;;;;;;;;;;;;;;;;;;;;;;

Menu, Tray, Nostandard
Menu, Tray, Add, Show Realm Buddy, GuiShow
Menu, Tray, Default, Show Realm Buddy
Menu, Tray, Add
Menu, Tray, Standard
Menu, Tray, Click, 1

;;;;;;;;;;;;;;				START UP FUNCTIONS					;;;;;;;;;;;;;;;;;;;;;;

; Retrieve scripts PID
Process, Exist
pid_this := ErrorLevel

; Retrieve unique ID number (HWND/handle)
WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%

; Call "HandleMessage" when script receives WM_MOUSEMOVE message
WM_MOUSEMOVE = 0x200
OnMessage(WM_MOUSEMOVE, "HandleMessage")

; Set GUI State
UpdateHotkeyControls() 

;Show RealmBuddy
RealmBuddyX := (A_ScreenWidth - 115)
Gui, RealmBuddy:+ToolWindow
Gui, RealmBuddy:Show, x%RealmBuddyX% y0, Realm Buddy

; Enable defined hotkeys
EnableHotkeys()

IniRead, AOT, %ININame%, Settings, AlwaysOnTop
if AOT = ON
{
	WinSet, AlwaysOnTop, ON, Realm Buddy
}
else
{
}

if Checkrandom = 1
{
	IniRead, Key, macro.ini, HotKey, Key
	Hotkey, ~$%Key%, Macro
}

SuspendOrNot()
return

SuspendOrNot()
{
	While 1
	{
		IfWinActive ahk_group rotmg
		{
			If FileExist(ActiveIcon)
			{
				Menu, Tray, Icon, %ActiveIcon%,, 1
				Suspend, Off
				continue
			}
		}
		IfWinActive ahk_class AutoHotkeyGUI
		{
			If FileExist(ActiveIcon)
			{
				Menu, Tray, Icon, %ActiveIcon%,, 1
				Suspend, Off
				continue
			}
		}
		If FileExist(PausedIcon)
		{
			Menu, Tray, Icon, %PausedIcon%,, 1
		}
		Suspend, On
		;Sleep 100
	}
}
return

Macro:
{
	ifWinActive, ahk_group rotmg
	{
		if counter >= 0 ; setTimer already started, so we log the keypress instead
		{
			counter++
			return
		}
		counter = 0 ; Start setTimer and set the number of logged keypresses to 0
		setTimer,Wawakey, 400
	}
}
return

Wawakey:
{
	setTimer,Wawakey,off
	if counter = 0 ; The key is pressed once
	{
		Random, randomnum , 1, HealMeArray.MaxIndex()
		randomtext := % HealMeArray[randomnum]
		SendInput {Enter}{Raw}%randomtext%
		SendInput {Enter}
	}
	else if counter = 1 ; The key is pressed twice
	{
		Random, randomnum , 1, ThanksArray.MaxIndex()
		randomtext := % ThanksArray[randomnum]
		SendInput {Enter}{Raw}%randomtext%
		SendInput {Enter}
	}
	else if counter = 2 ; The key is pressed thrice
	{
		Random, randomnum , 1, GLArray.MaxIndex()
		randomtext := % GLArray[randomnum]
		SendInput {Enter}{Raw}%randomtext%
		SendInput {Enter}
	}
	counter = -1
}
return

;;;;;;;;;;;;;;				CURSORS					;;;;;;;;;;;;;;;;;;;;;;

ChangeCursor:
GuiControlGet,Cursor,Settings:, Cursor
GuiControlGet,CursorName,Settings:, CursorName
If Cursor = Yes
{
	Loop
	{
		GuiControlGet,Cursor,Settings:, Cursor
		GuiControlGet,CursorName,Settings:, CursorName
		if Cursor = No
			break
		else
		{
			IfWinActive, ahk_group rotmg
			{
				SetSystemCursor("cursors/" . CursorName,0,0)
				WinWaitNotActive
				RestoreCursors()
			}
			else
			{
				RestoreCursors()
				WinWaitActive, ahk_group rotmg
			}
		}
	}
}
return

ChangeCursorName:
{
	InputBox, CursorNewName , Name of the Custom Cursor, What is the name of your cursor ? (With the extension)
	If ErrorLevel = 0
	{
		GuiControl, Settings:, CursorName, %CursorNewName%
	}
}
return

; CREDITS TO Serenity http://www.autohotkey.com/board/topic/32608-changing-the-system-cursor/

SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
   BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
   
   SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
   ,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
   ,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
   ,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
   
   If Cursor = ; empty, so create blank cursor
   {
      VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
      BlankCursor = 1 ; flag for later
   }
   Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
   {
      Loop, Parse, SystemCursors, `,
      {
         CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
         CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
         SystemCursor = 1
         If ( CursorName = Cursor )
         {
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            Break               
         }
      }   
      If CursorHandle = ; invalid cursor name given
      {
         Msgbox,, SetCursor, Error: Invalid cursor name
         CursorHandle = Error
      }
   }   
   Else If FileExist( Cursor )
   {
      SplitPath, Cursor,,, Ext ; auto-detect type
      If Ext = ico
         uType := 0x1   
      Else If Ext in cur,ani
         uType := 0x2      
      Else ; invalid file ext
      {
         Msgbox,, SetCursor, Error: Invalid file type
         CursorHandle = Error
      }      
      FileCursor = 1
   }
   Else
   {   
      Msgbox,, SetCursor, Error: Invalid file path or cursor name
      CursorHandle = Error ; raise for later
   }
   If CursorHandle != Error
   {
      Loop, Parse, SystemCursors, `,
      {
         If BlankCursor = 1
         {
            Type = BlankCursor
            %Type%%A_Index% := DllCall( "CreateCursor"
            , Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }         
         Else If SystemCursor = 1
         {
            Type = SystemCursor
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            %Type%%A_Index% := DllCall( "CopyImage"
            , Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )      
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }
         Else If FileCursor = 1
         {
            Type = FileCursor
            %Type%%A_Index% := DllCall( "LoadImage"
            , UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 )
            DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )         
         }         
      }
   }   
}
return

RestoreCursors()
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}
return

;;;;;;;;;;;;;;;           REALM CHOICE         ;;;;;;;;;;;;;;;;;;
ChoiceRealm:
{
	Gui, EventsGUI:Submit , NoHide
	WinActivate, ahk_group rotmg
	WinGetTitle, Title, A
	IniWrite, %RChoice%, %ININame%, %Title%, Realm
	GuiControl,RealmBuddy:, REALM, %RChoice%
	realm = %RChoice%
	WinActivate, ahk_group rotmg
}
return

ChoiceServer:
{
	Gui, EventsGUI:Submit , NoHide
	WinActivate, ahk_group rotmg
	WinGetTitle, Title, A
	IniWrite, %SChoice%, %ININame%, %Title%, Server
	GuiControl,RealmBuddy:, SERVER, %SChoice%
	server = %SChoice%
	WinActivate, ahk_group rotmg
}
return

;;;;;;;;;;;;;;				HUD					;;;;;;;;;;;;;;;;;;;;;;

Slot1:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot1
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot2:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot2
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot3:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot3
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot4:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot4
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot5:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot5
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot6:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot6
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot7:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot7
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot8:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot8
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot9:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot9
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return
Slot10:
{
	HUDPressed = 0
	Gui, HUD:Submit, Hide
	IniRead, Function, %ININame% , HUD, Slot10
	if Function != Nothing
	{
		GoTo, %Function%
	}
}
return

HUDPic:
{
	Global PicChosen
	Global PicChosen2
	Global ImgChosen
	Global ImgChosen2
	Loop 25
	{
		GuiControlGet, HUDimg%A_Index%, HUDEdit:Pos
		if A_GuiControl = HUDimg%A_Index%
		{
			if %A_GuiControl%W = 70
			{
				GuiControl, HUDEdit:+Border, %A_GuiControl%
				GuiControl, HUDEdit:Move, %A_GuiControl%, w71 h61
				PicChosen = 1
				if A_GuiControl = HUDimg1
				{
					ImgChosen = files/Nothing.png
				}
				if A_GuiControl = HUDimg2
				{
					ImgChosen = files/OtherKeySub1.png
				}
				if A_GuiControl = HUDimg3
				{
					ImgChosen = files/OtherKeySub2.png
				}
				if A_GuiControl = HUDimg4
				{
					ImgChosen = files/OtherKeySub12.png
				}
				if A_GuiControl = HUDimg5
				{
					ImgChosen = files/MyServer.png
				}
				if A_GuiControl = HUDimg6
				{
					ImgChosen = files/Mates.png
				}
				if A_GuiControl = HUDimg7
				{
					ImgChosen = files/Friends.png
				}
				if A_GuiControl = HUDimg8
				{
					ImgChosen = files/HideGuild.png
				}
				if A_GuiControl = HUDimg9
				{
					ImgChosen = files/HideMe.png
				}
				if A_GuiControl = HUDimg10
				{
					ImgChosen = files/AutomaticChangePlayer.png
				}
				if A_GuiControl = HUDimg11
				{
					ImgChosen = files/ChangePlayer.png
				}
				if A_GuiControl = HUDimg12
				{
					ImgChosen = files/Cheater.png
				}
				if A_GuiControl = HUDimg13
				{
					ImgChosen = files/NotCheater.png
				}
				if A_GuiControl = HUDimg14
				{
					ImgChosen = files/Scammer.png
				}
				if A_GuiControl = HUDimg15
				{
					ImgChosen = files/NotScammer.png
				}
				if A_GuiControl = HUDimg16
				{
					ImgChosen = files/Ignore.png
				}
				if A_GuiControl = HUDimg17
				{
					ImgChosen = files/UnIgnore.png
				}
				if A_GuiControl = HUDimg18
				{
					ImgChosen = files/Who.png
				}
				if A_GuiControl = HUDimg19
				{
					ImgChosen = files/TeleportPlayer.png
				}
				if A_GuiControl = HUDimg20
				{
					ImgChosen = files/TeleportPlayer10.png
				}
				if A_GuiControl = HUDimg21
				{
					ImgChosen = files/TellPlayer.png
				}
				if A_GuiControl = HUDimg22
				{
					ImgChosen = files/TradePlayer.png
				}
				if A_GuiControl = HUDimg23
				{
					ImgChosen = files/RealmEyeMe.png
				}
				if A_GuiControl = HUDimg24
				{
					ImgChosen = files/MyStats.png
				}
				if A_GuiControl = HUDimg25
				{
					ImgChosen = files/LeftToMax.png
				}
				if PicChosen2 = 1
				{
					GuiControl, HUDEdit:, %ImgChosen2%, %ImgChosen%
					NewStr := SubStr(ImgChosen, 7, -4)
					NewStr2 := SubStr(ImgChosen2, 5)
					IniWrite, %NewStr%, %ININAME%, HUD, Slot%NewStr2%
				}
			}
			else
			{
				GuiControl, HUDEdit:-Border, %A_GuiControl%
				GuiControl, HUDEdit:Move, %A_GuiControl%, w70 h60
				PicChosen = 0
			}
		}
		else
		{
			if HUDimg%A_Index%W = 71
			{
				GuiControl, HUDEdit:-Border, HUDimg%A_Index%
				GuiControl, HUDEdit:Move, HUDimg%A_Index%, w70 h60
			}
		}
	}
}
return

HUDPic2:
{
	Global PicChosen
	Global PicChosen2
	Global ImgChosen
	Global ImgChosen2
	Loop 10
	{
		GuiControlGet, HUDc%A_Index%, HUDEdit:Pos
		if A_GuiControl = HUDc%A_Index%
		{
			if %A_GuiControl%W = 70
			{
				GuiControl, HUDEdit:+Border, %A_GuiControl%
				GuiControl, HUDEdit:Move, %A_GuiControl%, w71 h51
				PicChosen2 = 1
				ImgChosen2 = %A_GuiControl%
				if PicChosen = 1
				{
					GuiControl, HUDEdit:, %A_GuiControl%, %ImgChosen%
					NewStr := SubStr(ImgChosen, 7, -4)
					NewStr2 := SubStr(ImgChosen2, 5)
					IniWrite, %NewStr%, %ININAME%, HUD, Slot%NewStr2%
				}
			}
			else
			{
				GuiControl, HUDEdit:-Border, %A_GuiControl%
				GuiControl, HUDEdit:Move, %A_GuiControl%, w70 h50
				PicChosen2 = 0
			}
		}
		else
		{
			if HUDc%A_Index%W = 71
			{
				GuiControl, HUDEdit:-Border, HUDc%A_Index%
				GuiControl, HUDEdit:Move, HUDc%A_Index%, w70 h50
			}
		}
	}
}
return

;;;;;;;;;;;;;;				CHECKINGS					;;;;;;;;;;;;;;;;;;;;;;

CheckKong: ; If you use Kongregate
{
	GuiControlGet,KongCheck,Settings:, KongCheck
	IniWrite, %KongCheck%, %ININame%, Settings, Kong
}
return
CheckF5: ; If you wanna override F5
{
	GuiControlGet,F5Check,Settings:, F5Check
	IniWrite, %F5Check%, %ININame%, Settings, F5Override
}
return
RClickSub: ; What you want to do with Right Click
{
	GuiControlGet, RClick, Settings:, RClick 
	IniWrite, %RClick%, %ININame% , Settings, RClick
}
return
DRClickSub: ; What you want to do with Double Right Click
{
	GuiControlGet, DRClick, Settings:, DRClick 
	IniWrite, %DRClick%, %ININame% , Settings, DRClick
}
return
ActMore: ; Activate the More Button only AFTER you checked your options ;)
{
	GuiControlGet,ActMoreCheck,Settings:, ActMoreCheck
	if ActMoreCheck = 1
	{
		IniWrite, 1, %ININame%, Settings, More
	}
	else
	{
		IniWrite, 0, %ININame%, Settings, More
	}
}
return

;;;;;;;;;;;;;;				TOOLTIPS					;;;;;;;;;;;;;;;;;;;;;;

; creating the tooltip function
HandleMessage(p_w, p_l, p_m, p_hw) 
{
global   WM_MOUSEMOVE, 
static   URL_hover, CtrlIsURL, LastCtrl
If (p_m = WM_MOUSEMOVE)
  {
	; Mouse cursor hovers URL text control
	StringLeft, CtrlIsURL, A_GuiControl, 7
	If (CtrlIsURL = "HELPBOX")
	  {
		StringReplace, Helpboxsub, A_GuiControl, HELPBOX
		If URL_hover=
		  {
			URL_hover := true
			GoSub, %Helpboxsub%
		  }                 
	  }
	; Mouse cursor doesn't hover URL text control
	Else
	  {
		If URL_hover
		  {
		   ToolTip
			URL_hover=
		  }
	  }
  }
}
return

; the different tooltips
AHKLink:
{
	ThisUrl = https://www.autohotkey.com/docs/KeyList.htm
	Run, %ThisUrl%
}
return
PasteBinLink:
{
	ThisUrl = http://pastebin.com/PZrbiUvQ
	Run, %ThisUrl%
}
return
GuiShow:
	Gui, RealmBuddy:Show, NA 
Return
RBVid:
{
	ThisUrl = https://www.youtube.com/watch?v=DzhHpSEawY0
	Run, %ThisUrl%
}
return
ImageVid:
{
	ThisUrl = https://www.youtube.com/watch?v=CBjh-CsuDo0
	Run, %ThisUrl%
}
return
ToolTipRC:
{
	ToolTip, Change your Single Right Click
}
return
ToolTipDRC:
{
	ToolTip, Double Right Click keeps Speedy`nOr press Ability if not on Ninja
}
return
ToolTipTR:
{
	ToolTip, Writing /tr (+ Space) in chat will makes you write /trade
}
return
ToolTipTP:
{
	ToolTip, Writing /tp (+ Space) in chat will makes you write /teleport
}
return
ToolTipIG:
{
	ToolTip, Writing /ignr to someone makes you ignore that person
}
return
ToolTipRD:
{
; ToolTip, test
	ToolTip, Default key is Numpad9 (Check the Macro.ini to change it)`nIdea is random macro depending on number of clicks :`n1 click = heal`n2 clicks = thx`n3 clicks = gl
}
return
ToolTipNT:
{
	ToolTip, Typing @@@ (@ 3 times in a row) will send you to Nexus Tutorial
}
return
ToolTipUseless:
{
	ToolTip, You pressed the only useless help box...`nNice I guess ! :P
}
return
ToolTipIGHotkey:
{
	ToolTip, The necessary keys to make Realm Buddy functionnal`nIf your Hotkeys are not the default ones change them here
}
return
ToolTipEHotkey:
{
	ToolTip, If you often switch between public/guild callouts`nOr if you often change your main window
}
return
ToolTipGUIHotkey:
{
	ToolTip, Those are the tools you want to access to !`nGUI stands for Graphical User Interface`nThey are your InGame Interface
}
return
ToolTipMHotkey:
{
	ToolTip, The Menu Version of the GUIs`nYou can use them instead
}
return
ToolTipRO:
{
	ToolTip, Makes the hotkey works only in Realm`nmeaning any Window Title containing :`n- realmofthemadgod or`n- AssembleeGameClient or`n- AGCLoader or`n- Realm of the Mad God or`n- Adobe Flash Player
}
return
ToolTipTab:
{
	ToolTip, It does Begin Tell Key -> Text -> ActivateChat Key`nInstead of ActivateChat Key -> Text -> ActivateChat Key`nIt is really useful for example to answer someone :`n"Sorry I am busy right now I will talk to you later ! :P"
}
return
ToolTipHotkey:
{
	ToolTip, A lot of Hotkeys Combination are possible`nYou can even use Windows button/Joystick/Extra keyboard keys`nTry them out ! :D
}
return
ToolTipQSText:
{
	ToolTip, This is the Text you are going to write with the Hotkey
}
return
ToolTipCP:
{
	ToolTip, The Pixels from the Fame/Gold are used to check your loading state for Server Gui/Menu
}
return
ToolTipCursor:
{
	ToolTip, Choose if you want to use a Custom Cursor (.ico or .cur)`nPut your custom cursor in the "cursors" folder
}
return
ToolTipIGCursor:
{
	ToolTip, Change the name of your Custom Cursor (.ico or .cur)`nPut your custom cursor in the "cursors" folder
}
return
ToolTipCurTP:
{
	ToolTip, The Player used for the Speech GUI/Menu`nYou can change it via the Speech GUI/Menu :`n- With Automatic after Whispering someone`n- With Change Player to do it manually
}
return
ToolTipCurTPP:
{
	ToolTip, The Player used for QuickSpeech Settings`nYou can change via the Same Player box
}
return
ToolTipSwitchTP:
{
	ToolTip, Yes means Current Teleport Player is Current Target Player`nNo let you change the Current Teleport Player manually
}
return
ToolTipWindow:
{
	ToolTip, ahk_group is any Window Title containing :`n- realmofthemadgod or`n- AssembleeGameClient or`n- AGCLoader or`n- Realm of the Mad God or`n- Adobe Flash Player`nIf your Window got a different name change it here
}
return
ToolTipHGUI:
{
	ToolTip, Allows you to use the HUD`nYou need to have a correct "Change Pixels" to make it work
}
return
ToolTipSGUI:
{
	ToolTip, Allows you to change server via InGame GUI`nYou need to have a correct "Show Options Key"`nand "Change Pixels" to make it work
}
return
ToolTipEGUI:
{
	ToolTip, Allows you to make callouts via InGame GUI
}
return
ToolTipSPGUI:
{
	ToolTip, Allows you to do a lot of stuff via InGame GUI`nAfter you clicked on Change Player or Automatic`nYou can check someone's Realmeye`nor Tag/UnTag someone as scammer/cheater`nYou can also ignore/trade/teleport and more`nWhisper someone then click Automatic to set Current Player`n(with the "/tell someone " in chat)
}
return
ToolTipCGUI:
{
	ToolTip, Allows you to shout the sentences useful in dungeons
}
return
ToolTipMGUI:
{
	ToolTip, Allows you to shout the sentences useful in realm
}
return
ToolTipSMenu:
{
	ToolTip, Allows you to change server via InGame Menu`nYou need to have a correct "Show Options Key"`nand "Change Pixels" to make it work
}
return
ToolTipInvSwap:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory
}
return
ToolTipS1:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 1
}
return
ToolTipS2:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 2
}
return
ToolTipS3:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 3
}
return
ToolTipS4:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 4
}
return
ToolTipS5:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 5
}
return
ToolTipS6:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 6
}
return
ToolTipS7:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 7
}
return
ToolTipS8:
{
	ToolTip, Allows you to do create hotkeys to swap items in inventory slot 8
}
return
ToolTipScreenshot:
{
	ToolTip, Allows you to make a Screenshot save it via Paint and upload it via Imgur
}
return
ToolTipScr:
{
	ToolTip, Allows you to make a Screenshot
}
return
ToolTipPaint:
{
	ToolTip, Allows you to save the screenshot through Paint
}
return
ToolTipImgur:
{
	ToolTip, Allows you to upload the screenshot to Imgur
}
return
ToolTipASMenu:
{
	ToolTip, Allows you to do Actions via InGame Menu`nYou can tell/trade/teleport and`n/teleport10X (for when you get the 10sec timer)`nIt will try to teleport you each second for 10 seconds
}
return
ToolTipRSMenu:
{
	ToolTip, Allows you to do RealmEye stuff via InGame Menu`nYou can Tag someone as scammer/cheater`nYou can also ignore
}
return
ToolTipGSMenu:
{
	ToolTip, Allows you to do Guild stuff via InGame Menu`nYou can check your friends/guildmates`nYou can also hide your guild.`nYou can also see My Stats/Left to Max`nYou can also /who and /server
}
return
ToolTipDCMenu:
{
	ToolTip, Allows you to make Dungeons callouts via InGame Menu
}
return
ToolTipRCMenu:
{
	ToolTip, Allows you to make Events callouts via InGame Menu
}
return
ToolTipCF:
{
	ToolTip, Allows you to change focus between different windows : `nUseful so that your "friend's account" (not a mule! :p)`nwon't change the server/realm you are in
}
return
ToolTipTC:
{
	ToolTip, Allows you to change the callout from`nthe Event GUI between Guild/Public
}
return
ToolTipCC:
{
	ToolTip, Choose the default callout from`nthe Event GUI between Guild/Public
}
return
ToolTipOptionKey:
{
	ToolTip, Put your InGame Show Options Key so that`nthe Server GUI/Menu works`nYou can find what your key is by going to :`nOptions -> Hot Keys inside the game
}
return
ToolTipIKey:
{
	ToolTip, Put your InGame Interact/Buy Key so that`nit recognize the portal you entered
}
return
ToolTipACKey:
{
	ToolTip, Put your InGame ActivateChat Key so that`nthe Event GUI/Menu works`nAlso necessary for the QuickSpeech Settings`nYou can find what your key is by going to :`nOptions -> Controls inside the game
}
return
ToolTipAKey:
{
	ToolTip, Put your InGame Use Special Ability Key`nso that the Right Click works`nGo see Built-In Functions for details`nYou can find what your key is by going to :`nOptions -> Chat inside the game
}
return
ToolTipBTKey:
{
	ToolTip, Put your InGame Begin Tell Key so that`nPM Back on QuickSpeech Settings works`nYou can find what your key is by going to :`nOptions -> Chat inside the game
}
return

;;;;;;;;;;;;;;				PIXELS					;;;;;;;;;;;;;;;;;;;;;;

; asking for the pixels
NewPixels:
{
	Global Pixel
	Pixel = Fame
	Hotkey, !x, GetPixel, On
	MsgBox Press ALT + X over your Fame icon (I need to get the orange color of the fame pixel from your screen).`nPress OK when you feel the image on your top left corner is the correct one
	Pixel = Coin
	MsgBox Press ALT + X over your Coin icon (I need to get the yellow color of the coin pixel from your screen).`nPress OK when you feel the image on your top left corner is the correct one
	; Pixel = EnterPortal
	; MsgBox Press ALT + X over an Enter Portal (I need to get the yellow color when your mouse is hovering an Enter Portal).`nPress OK when you feel the image on your top left corner is the correct one`nWhat I mean is that when your mouse is hovering the white Enter button to go through a portal that Enter button becomes yellow. I need that yellow color.
	Hotkey, !x, GetPixel, Off
	MsgBox Ok ALT + X hotkey removed now :D
}
return

; getting the pixels
GetPixel:
{
	Global FamePixel
	Global CoinPixel
	; Global EnterPixel
	Global Pixel
	MouseGetPos,XX,YY
	PixelGetColor, Col,%XX%,%YY%,RGB
	if Pixel = Fame
	{
		FamePixel = %Col%
		;msgbox F = %FamePixel%, %Col%
		Gui, +AlwaysOnTop -Caption -border +Disabled
		Gui, Color, %Col%
		Gui, Show, NA x0 y0 w50 h50
		IniWrite, %Col%, %ININame%, Settings, FamePixel
		WinActivate, ahk_class #32770
		Sleep 1000
	}
	else if Pixel = Coin
	{
		CoinPixel = %Col%
		;msgbox C = %CoinPixel%, %Col%
		Gui, +AlwaysOnTop -Caption -border +Disabled
		Gui, Color, %Col%
		Gui, Show, NA x0 y0 w50 h50
		IniWrite, %Col%, %ININame%, Settings, CoinPixel
		WinActivate, ahk_class #32770
		Sleep 1000
	}
	; else if Pixel = EnterPortal
	; {
		; EnterPixel = %Col%
		; msgbox E = %EnterPixel%, %Col%
		; Gui, +AlwaysOnTop -Caption -border +Disabled
		; Gui, Color, %Col%
		; Gui, Show,NoActivate x0 y0 w50 h50
		; IniWrite, %Col%, %ININame%, Settings, EnterPixel
		; WinActivate, ahk_class #32770
		; Sleep 1000
	; }
	Gui, Show, NA Hide
}
return

;;;;;;;;;;;;;;				Your Settings Keys					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub27: ; Option Key
{
}
return
OtherKeySub28: ; Begin Tell Key
{
}
return
OtherKeySub29: ; Ability Key
{
}
return
OtherKeySub30: ; ActivateChat Key
{
}
return

;;;;;;;;;;;;;;				Inv Swapper Keys					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub16: ; Inv Swap Slot 1
{
	slot = 1	
	goto swap
}
return
OtherKeySub17: ; Inv Swap Slot 2
{
	slot = 2	
	goto swap
}
return
OtherKeySub18: ; Inv Swap Slot 3
{
	slot = 3	
	goto swap
}
return
OtherKeySub19: ; Inv Swap Slot 4
{
	slot = 4	
	goto swap
}
return
OtherKeySub20: ; Inv Swap Slot 5
{
	slot = 5	
	goto swap
}
return
OtherKeySub21: ; Inv Swap Slot 6
{
	slot = 6	
	goto swap
}
return
OtherKeySub22: ; Inv Swap Slot 7
{
	slot = 7	
	goto swap
}
return
OtherKeySub23: ; Inv Swap Slot 8
{
	slot = 8	
	goto swap
}
return

swap:
MouseGetPos, mousePosX, mousePosY
WinGetPos, , , winSizeX, winSizeY, A
SysGet, menuHeight, 15
SysGet, vBorderWidth, 32
SysGet, hBorderWidth, 33
SysGet, titleHeight, 4
ImageSearch, imageLocX, imageLocY, %winSizeX%/2, %winSizeY%/2, %winSizeX%, %winSizeY%, img\inv-low.png
if ErrorLevel {
	ImageSearch, imageLocX, imageLocY, %winSizeX%/2, %winSizeY%/2, %winSizeX%, %winSizeY%, img\inv-high.png
	if ErrorLevel {
		ImageSearch, imageLocX, imageLocY, %winSizeX%/2, %winSizeY%/2, %winSizeX%, %winSizeY%, img\inv-med.png
		if ErrorLevel {
			stretched := true
		}
	}
}
if(stretched){
	posX := 634 + Mod((44 * (slot-1)), (4*44))
	posY := 400 + (44 * ((slot-1)//(4)))
	multiplierX := ((winSizeX-vBorderWidth)/800)
	multiplierY := ((winSizeY-(menuHeight+hBorderWidth+titleHeight))/600)
	posX *= multiplierX
	posY *= multiplierY
} else {
	posX := imageLocX + 30 + Mod((44 * (slot-1)), (4*44)) - vBorderWidth
	posY := imageLocY + 50 + (44 * ((slot-1)//(4))) - (menuHeight+hBorderWidth+titleHeight)
}
CoordMode, Mouse, Client
MouseMove, posX, posY
SendEvent {LButton Down}
SendEvent {LButton Up}
SendEvent {LButton Down}
SendEvent {LButton Up}
CoordMode, Mouse, Window
MouseMove, mousePosX, mousePosY
stretched := false
Return

;;;;;;;;;;;;;;				Screenshot Uploader					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub24: ; Printscreen
{
	;;Send printscreent
	Sendinput {PrintScreen}
	;;Get the TimeStamp
	FormatTime, timestamp, , dd MMM yyyy - HH.mm
}
return

OtherKeySub25: ; Paint
{
	;;If the window "Untitled - Paint" is present
	IfWinExist Paint
	{
		;;Activate window
		WinActivate                                   
	}
	else
	{
		;;Run paint
		Run %A_WinDir%\System32\mspaint.exe
		;;Wait until "Untitled - Paint" is done loading
		WinWait Untitled - Paint
		;;Activate the paint window
		WinActivate                                   
	}
	;;Paste image
	Sendinput ^v
	;;Save image using control s
	Sendinput ^s
	;;Wait until save as dialog is done loading
	WinWait ahk_class #32770
	;;Activate window
	WinActivate
	;;Paste location
	currentnum = 1
	Sendinput %A_ScriptDir%\RotMG - %timestamp% - n°%currentnum%.png{enter}
	currentfilename = %A_ScriptDir%\RotMG - %timestamp% - n°%currentnum%.png
	Sleep 100
	;;If the file name already exist
	Loop
	{
		if WinExist("ahk_class #32770") ;Confirm Save As                   
		{
			WinActivate ahk_class #32770
			;;  Select don't save
			Sendinput {Enter}
			Sendinput {Right}{Left}{Left}{Left}{Left}{Backspace}
			if currentnum > 10
			{
				SendInput {Backspace}
			}
			Sleep 200
			SendInput %currentnum%{enter}
			Sleep 200
			if WinExist("ahk_class #32770") ;Confirm Save As                   
			{
				currentnum += 1
				Sleep 200
			}
			continue
		}
		else
		{
			;;Attempt alt-f4
			If WinExist("ahk_exe mspaint.exe")
			{
				WinActivate ahk_exe mspaint.exe
				Sendinput !{F4}
				Sleep 200
				continue
			}
			else
			{
				currentfilename = %A_ScriptDir%\RotMG - %timestamp% - n°%currentnum%.png
				IniWrite, %currentfilename%, %ININAME%, Screenshot Uploader, Image File Name
				currentnum = 1
				Sleep 200
				break
			}
		}
	}
}
return

OtherKeySub26: ; Imgur
{
	IniRead, currentfilename, %ININAME%, Screenshot Uploader, Image File Name
	IniRead, browseX, %ININAME%, Screenshot Uploader, Browse Position X
	IniRead, browseY, %ININAME%, Screenshot Uploader, Browse Position Y
	;; Run imgur
	Run, http://imgur.com/upload
	WinWait Imgur
	WinActivate Imgur
	Sleep 500
	if (browseX = "ERROR" || browseY = "ERROR")
	{
		Hotkey, !x, GetBrowsePos, On
		msgbox Press ALT + X when your Mouse is on the Browse Button from Imgur`nPress OK when you're done.
		Hotkey, !x, GetBrowsePos, Off
		MsgBox Ok ALT + X hotkey removed now :D
		Reload
		WinActivate Imgur
		Click, %browseX%, %browseY%
	}
	else
	{
		Click, %browseX%, %browseY%
	}
	WinWait ahk_class #32770
	WinActivate 
	Sleep 500
	SendInput %currentfilename%
	Sleep 500
	SendInput {enter}
}
return

GetBrowsePos:
{
	MouseGetPos,browseX,browseY
	IniWrite, %browseX%, %ININAME%, Screenshot Uploader, Browse Position X
	IniWrite, %browseY%, %ININAME%, Screenshot Uploader, Browse Position Y
	WinActivate, ahk_class #32770
}
return

;;;;;;;;;;;;;;				RealmBuddy Close					;;;;;;;;;;;;;;;;;;;;;;

RealmBuddyGuiClose:
MsgBox, 4, Exit RealmBuddy ?, Want to exit RealmBuddy ?
IfMsgBox Yes
{
	WinActivate, ahk_group rotmg
	RestoreCursors()
    ExitApp
}
else IfMsgBox No
return

;;;;;;;;;;;;;;				EMERGENCY EXIT					;;;;;;;;;;;;;;;;;;;;;;

^F8:: ; CTRL + F8 to close the script manually
{
	ExitApp
	RestoreCursors()
}
return

^F9:: ; CTRL + F8 to close the script manually
{
	Reload
}
return

;;;;;;;;;;;;;;				FUNCTIONS WITHOUT THE MENU					;;;;;;;;;;;;;;;;;;;;;;

MyServer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/server
	SendInput {Enter}
	Blockinput, off
}
return
LeftToMax:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall lefttomax
	SendInput {Enter}
	Blockinput, off
}
return
MyStats:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall stats
	SendInput {Enter}
	Blockinput, off
}
return
Who:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/who
	SendInput {Enter}
	SendInput {Enter}
	SendInput {Raw}/c
	SendInput {Enter}
	Blockinput, off
}
return
HideMe:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall hide me
	SendInput {Enter}
	Blockinput, off
}
return
HideGuild:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall hide my guild
	SendInput {Enter}
	Blockinput, off
}
return
Friends:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall friends
	SendInput {Enter}
	Blockinput, off
}
return
Mates:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall mates
	SendInput {Enter}
	Blockinput, off
}
return
Cheater:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall tag cheater %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
NotCheater:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall untag cheater %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
Scammer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall tag scammer %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
NotScammer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell MrEyeBall untag scammer %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
Ignore:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/ignore %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
UnIgnore:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/unignore %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
TeleportPlayer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/teleport %CurrentPlayer%
	SendInput {Enter}
	Blockinput, off
}
return
TeleportPlayer10:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Sleep 100
	WinGet, FirstWindow, ID, A
	count := 0
	While count < 10
	{
		Sleep, 100
		WinGet, SecondWindow, ID, A
		If (FirstWindow = SecondWindow)
		{
			Blockinput, on
			SendInput {%ActivateChat%}
			SendInput {Raw}/teleport %CurrentPlayer%
			SendInput {Enter}
			Blockinput, off
			Sleep 600
			count += 1
			
		}
		else
			break
	}
}
return
TellPlayer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/tell %CurrentPlayer%
	SendInput {Space}
	Blockinput, off
}
return
TradePlayer:
{
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	SendInput {%ActivateChat%}
	SendInput {Raw}/trade %CurrentPlayer%
	if instant = ON
	{
		Sleep, 10
		SendInput {Enter}
	}
	Blockinput, off
}
return
AutomaticChangePlayer:
{
	global CurrentPlayer
	global NumACKey
	ActivateChat := HotkeyList[NumACKey].hk
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	WinWaitActive, ahk_group rotmg
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	Blockinput, on
	clipboard =
	SendInput {%ActivateChat%}
	SendInput ^a
	Sleep, 10
	SendInput ^c
	Sleep 100
	Blockinput, off
	IfInString, clipboard, /tell%A_SPACE%
			StringReplace, clipboard, clipboard, /tell%A_SPACE%,, All
	Sleep 100
	IfInString, clipboard, /trade%A_SPACE%
			StringReplace, clipboard, clipboard, /trade%A_SPACE%,, All
	Sleep 100
	IfInString, clipboard, /teleport%A_SPACE%
			StringReplace, clipboard, clipboard, /teleport%A_SPACE%,, All
	Sleep 100
	IfInString, clipboard, /t%A_SPACE%
			StringReplace, clipboard, clipboard, /t%A_SPACE%,, All
	Sleep 100
	IfInString, clipboard, %A_SPACE%
			StringReplace, clipboard, clipboard, %A_SPACE%,, All
	If  clipboard != %CurrentPlayer%
	{
		OldPlayer := CurrentPlayer
		IfInString, clipboard, %A_SPACE%
			StringReplace, clipboard, clipboard, %A_SPACE%,, All
		CurrentPlayer := clipboard
		Menu, AdvancedSpeech, Rename, Teleport %OldPlayer%, Teleport %CurrentPlayer%
		Menu, AdvancedSpeech, Rename, Teleport 10X %OldPlayer%, Teleport 10X %CurrentPlayer%
		Menu, AdvancedSpeech, Rename, Tell %OldPlayer%, Tell %CurrentPlayer%
		Menu, AdvancedSpeech, Rename, Trade %OldPlayer%, Trade %CurrentPlayer%
		Menu, RealmeyeSpeech, Rename, TAG        %OldPlayer% as Cheater, TAG        %CurrentPlayer% as Cheater
		Menu, RealmeyeSpeech, Rename, UNTAG  %OldPlayer% as Cheater, UNTAG  %CurrentPlayer% as Cheater
		Menu, RealmeyeSpeech, Rename, TAG        %OldPlayer% as Scammer, TAG        %CurrentPlayer% as Scammer
		Menu, RealmeyeSpeech, Rename, UNTAG  %OldPlayer% as Scammer, UNTAG  %CurrentPlayer% as Scammer
		Menu, RealmeyeSpeech, Rename, IGNORE        %OldPlayer%, IGNORE        %CurrentPlayer%
		Menu, RealmeyeSpeech, Rename, UNIGNORE  %OldPlayer%, UNIGNORE  %CurrentPlayer%
		GuiControl, SpeechGUI:, SpeechPlayer, Player Name is : %CurrentPlayer%
		GuiControl, HUD:, HUDPlayer, Player Name is : %CurrentPlayer%
		IniWrite, %CurrentPlayer%, %ININame%,  Settings, CurrentPlayer
		GuiControl, Settings:, CurrentPlayerEdit, %CurrentPlayer%
		if SwitchTeleport = Yes
		{
			IniWrite, %CurrentPlayer%, %ININame%,  Settings, CurrentTP
			GuiControl, Settings:, CurrentTPEdit, %CurrentPlayer%
			GuiControl,HotkeyGUI:, QSText1, /teleport %CurrentPlayer%
			IniWrite, /teleport %CurrentPlayer%, %ININame%, Quick Speech Text, Text1
		}
	}
}
return
ChangePlayer:
{
	global CurrentPlayer
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	InputBox, PlayerSelection, Player Change, What is the new Player name ?
	If  PlayerSelection != %CurrentPlayer%
	{
		OldPlayer := CurrentPlayer
		IfInString, PlayerSelection, %A_SPACE%
			StringReplace, PlayerSelection, PlayerSelection, %A_SPACE%,, All
		CurrentPlayer := PlayerSelection
		Menu, AdvancedSpeech, Rename, Teleport %OldPlayer%, Teleport %PlayerSelection%
		Menu, AdvancedSpeech, Rename, Teleport 10X %OldPlayer%, Teleport 10X %PlayerSelection%
		Menu, AdvancedSpeech, Rename, Tell %OldPlayer%, Tell %PlayerSelection%
		Menu, AdvancedSpeech, Rename, Trade %OldPlayer%, Trade %PlayerSelection%
		Menu, RealmeyeSpeech, Rename, TAG        %OldPlayer% as Cheater, TAG        %PlayerSelection% as Cheater
		Menu, RealmeyeSpeech, Rename, UNTAG  %OldPlayer% as Cheater, UNTAG  %PlayerSelection% as Cheater
		Menu, RealmeyeSpeech, Rename, TAG        %OldPlayer% as Scammer, TAG        %PlayerSelection% as Scammer
		Menu, RealmeyeSpeech, Rename, UNTAG  %OldPlayer% as Scammer, UNTAG  %PlayerSelection% as Scammer
		Menu, RealmeyeSpeech, Rename, IGNORE        %OldPlayer%, IGNORE        %PlayerSelection%
		Menu, RealmeyeSpeech, Rename, UNIGNORE  %OldPlayer%, UNIGNORE  %PlayerSelection%
		GuiControl, SpeechGUI:, SpeechPlayer, Player Name is : %CurrentPlayer%
		GuiControl, HUD:, HUDPlayer, Player Name is : %CurrentPlayer%
		IniWrite, %CurrentPlayer%, %ININame%,  Settings, CurrentPlayer
		GuiControl, Settings:, CurrentPlayerEdit, %CurrentPlayer%
		if SwitchTeleport = Yes
		{
			IniWrite, %CurrentPlayer%, %ININame%,  Settings, CurrentTP
			GuiControl, Settings:, CurrentTPEdit, %CurrentPlayer%
			GuiControl,HotkeyGUI:, QSText1, /teleport %CurrentPlayer%
			IniWrite, /teleport %CurrentPlayer%, %ININame%, Quick Speech Text, Text1
		}
	}
}
return
ChangeTP:
{
	Gui, Settings:Submit, NoHide
	IniWrite, %CurrentTPEdit%, %ININame%, Settings, CurrentTP
	Gui, HotkeyGUI:Submit, NoHide
	GuiControl,HotkeyGUI:, QSText1, /teleport %CurrentTPEdit%
	IniWrite, /teleport %CurrentTPEdit%, %ININame%, Quick Speech Text, Text1
}
return
ChangeSwitch:
{
	Gui, Settings:Submit, NoHide
	IniWrite, %SwitchTeleport%, %ININame%, Settings, SwitchTeleport
	if SwitchTeleport = No
	{
		GuiControl, Settings:Enable, CurrentTPEdit
	}
	else
	{
		GuiControl, Settings:Disable, CurrentTPEdit
		IniWrite, %CurrentPlayer%, %ININame%,  Settings, CurrentTP
		GuiControl, Settings:, CurrentTPEdit, %CurrentPlayer%
		GuiControl,HotkeyGUI:, QSText1, /teleport %CurrentPlayer%
		IniWrite, /teleport %CurrentPlayer%, %ININame%, Quick Speech Text, Text1
	}
}
return
PubGuild:
{
	WinActivate, ahk_group rotmg
	WinGetTitle, Title, A
	if PG = public
	{
		PG = guild
		GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
		WhatCall := "/g "
		IniWrite, %WhatCall%, %ININame%, Settings, WhatCall
	}
	else
	{
		PG = public
		GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
		WhatCall := ""
		IniWrite, %WhatCall%, %ININame%, Settings, WhatCall
	}
}
return
GuildChange:
{
	WinActivate, ahk_group rotmg
	Gui, Settings:Submit, NoHide
	WinGetTitle, Title, A
	if GuildCall = Guild
	{
		WhatCall := "/g "
		IniWrite, %WhatCall%, %ININame%, Settings, WhatCall
		PG = guild
		GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
	}
	else
	{
		WhatCall := ""
		IniWrite, %WhatCall%, %ININame%, Settings, WhatCall
		PG = public
		GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
	}
}
return
InstantTrade:
{
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	if instant = ON
	{
		instant = OFF
		Menu, AdvancedSpeech, Rename, Instant Trade is ON, Instant Trade is OFF
	}
	else if instant = OFF
	{
		instant = ON
		Menu, AdvancedSpeech, Rename, Instant Trade is OFF, Instant Trade is ON
	}
}
return
RealmEyeMe:
{
	Gui, SpeechGUI:Show, NA Hide
	SpeechPressed := 0
	ThisUrl = http://www.realmeye.com/player/%CurrentPlayer%
	Run, %ThisUrl%
}
return

;;;;;;;;;;;;;;				SPECIALS BINDINGS					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub10: ; Change Focus
{
	Global WinTitle
	MouseGetPos,,, OutputVarWin
	WinTitle = ahk_id %OutputVarWin%
	WinActivate, %WinTitle%
	MsgBox Focus Changed !
}
return
OtherKeySub11: ; Toggle Callout
{
	GetPosition()
	WinGetTitle, Title, A
	XToggle := xpos2 + (0.5 * width2)
	YToggle := ypos2 + (0.5 * height2)
	if WhatCall = 
	{
		GuiControl, Settings:Choose, GuildCall, 1
		Gui, ToggleCallGUION:Show, NA x%XToggle% y%YToggle%
		WinSet, TransColor, 363636 255, ToggCallGUION
		WhatCall := "/g "
		IniWrite, %WhatCall%, %ININame%, %Title%, WhatCall
		WinActivate, ahk_group rotmg
		Sleep 1000
		Gui, ToggleCallGUION:Show, NA Hide
	}
	else
	{
		GuiControl, Settings:Choose, GuildCall, 2
		WinSet, TransColor, 363636 255, ToogCallGUIOFF
		WhatCall := ""
		IniWrite, %WhatCall%, %ININame%, %Title%, WhatCall
		Gui, ToggleCallGUIOFF:Show, NA x%XToggle% y%YToggle%
		WinActivate, ahk_group rotmg
		Sleep 1000
		Gui, ToggleCallGUIOFF:Show, NA Hide
	}
}
return

;;;;;;;;;;;;;;				MENU BINDINGS					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub4:
{
	Menu, ServersMenu, Show, NA 
}
return
OtherKeySub5:
{
	Menu, RealmCaller, Show, NA 
}
return
OtherKeySub6:
{
	Menu, DungeonCaller, Show, NA 
}
return
OtherKeySub7:
{
	Menu, GuildSpeech, Show, NA 
}
return
OtherKeySub8:
{
	Menu, RealmeyeSpeech, Show, NA 
}
return
OtherKeySub9:
{
	Menu, AdvancedSpeech, Show, NA 
}
return

;;;;;;;;;;;;;;				REALMBUDDY SHOW GUI					;;;;;;;;;;;;;;;;;;;;;;

ServerList:
{
	Gui, ServerList:Show, NA 
}
return
RealmCaller:
{
	Gui, EventList:Show, NA 
}
return
DungeonCaller:
{
	Gui, DungeonList:Show, NA 
}
return
SpeechCaller:
{
	Gui, SpeechGUI:Show, NA 
}
return
Settings:
{
	Gui, Settings:Show, NA 
	ControlSetText, CurrentPlayerEdit, %CurrentPlayer%, Settings
}
return
QuickSpeechSettings:
{
	Gui, HotKeyGUI:Show, NA 
}
return
HUDSettings:
{
	Gui, HUDEdit:Show, NA 
}
return
BuiltInFunctions:
{
	Gui, BuiltIn:Show, NA 
}
return
RBQA:
{
	Gui, RBFAQ:Show, NA 
}
return
MoreStuff:
{
	IniRead, More, %ININame%, Settings, More
	if More = 0
	{
		MsgBox, 0, Settings Not done !, Go make your Settings first ! :S`nYou need to bind keys to the required fields !
	}
	else if More = 1
	{
	Gui, More:Show, NA 
	}
}
return

;;;;;;;;;;;;;;				SETTINGS CHECKING					;;;;;;;;;;;;;;;;;;;;;;

ONTOP:
{
	WinSet, AlwaysOnTop, toggle, Realm Buddy
	IniRead, AOT, %ININame%, Settings, AlwaysOnTop
	if AOT = OFF
	{
		GuiControl,, TOP, Always on top`nON
		IniWrite, ON, %ININame%, Settings, AlwaysOnTop
	}
	else 
	{
		GuiControl,, TOP, Always on top`nOFF
		IniWrite, OFF, %ININame%, Settings, AlwaysOnTop
	}
	Gui, RealmBuddy:Submit, NoHide
}
return

;;;;;;;;;;;;;;				SAVE SETTINGS					;;;;;;;;;;;;;;;;;;;;;;

SaveSettings:
{
	Gui, Settings:Submit, Hide
	IniWrite, %TitleEdit%, %ININame%,  Settings, WindowTitle
	IniWrite, %SwitchTeleport%, %ININame%, Settings, SwitchTeleport
	IniWrite, %CurrentPlayer%, %ININame%, Settings, CurrentPlayer
	IniWrite, %GuildCall%, %ININame%,  Settings, GuildCall
	IniWrite, %cursor%, %ININame%,  Settings, CustomCursor
	IniWrite, %instant%, %ININame%,  Settings, InstantTrade
	IniWrite, %CursorName%, %ININame%, Settings, CursorName
	IniWrite, %CurrentTPEdit%, %ININame%, Settings, CurrentTP
	; IniWrite, %ActivateChat%, %ININame%, Realm Keys, ActivateChat
	; IniWrite, %OptionKey%, %ININame%, Realm Keys, OptionKey
	
	RestoreCursors()
	Gosub, SaveSettings3
}
return

;;;;;;;;;;;;;;				EU SERVERS FUNCTIONS					;;;;;;;;;;;;;;;;;;;;;;

EUW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.45
	server = EuWest
	Gosub, ChangeServer
}
return
EUW2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.6
	MultiplierY := 0.35
	server = EuWest2
	Gosub, ChangeServer
}
return
EUS:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.55
	server = EuSouth
	Gosub, ChangeServer
}
return
EUSW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.6
	MultiplierY := 0.45
	server = EuSouthWest
	Gosub, ChangeServer
}
return
EUN:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.65
	server = EuNorth
	Gosub, ChangeServer
}
return
EUN2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.6
	MultiplierY := 0.55
	server = EuNorth2
	Gosub, ChangeServer
}
return
EUE:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.6
	MultiplierY := 0.65
	server = EuEast
	Gosub, ChangeServer
}
return

;;;;;;;;;;;;;;				US SERVERS FUNCTIONS					;;;;;;;;;;;;;;;;;;;;;;

USW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.45
	server = USWest
	Gosub, ChangeServer
}
return
USW2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.35
	server = USWest2
	Gosub, ChangeServer
}
return
USW3:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.35
	server = USWest3
	Gosub, ChangeServer
}
return
USE:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.35
	server = USEast
	Gosub, ChangeServer
}
return
USE2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.8
	server = USEast2
	Gosub, ChangeServer
}
return
USE3:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.8
	server = USEast3
	Gosub, ChangeServer
}
return
USS:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.6
	server = USSouth
	Gosub, ChangeServer
}
return
USS2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.5
	server = USSouth2
	Gosub, ChangeServer
}
return
USS3:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.5
	server = USSouth3
	Gosub, ChangeServer
}
return
USSW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.45
	server = USSouthWest
	Gosub, ChangeServer
}
return
USMW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.7
	server = USMidWest
	Gosub, ChangeServer
}
return
USMW2:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.2
	MultiplierY := 0.7
	server = USMidWest2
	Gosub, ChangeServer
}
return
USNW:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 0
	MultiplierX := 0.6
	MultiplierY := 0.6
	server = USNorthWest
	Gosub, ChangeServer
}
return

;;;;;;;;;;;;;;				ASIA/AUSTRALIA SERVERS FUNCTIONS					;;;;;;;;;;;;;;;;;;;;;;

ASE:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.6
	MultiplierY := 0.75
	server = AsiaSouthEast
	Gosub, ChangeServer
}
return
AE:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.8
	server = AsiaEast
	Gosub, ChangeServer
}
return
AUS:
{
	Global FAST
	Global CHAR
	if FAST
	{
		CHAR := 1
	}
	else
	{
		KeyWait, LButton			; wait for Ctrl to be released
		KeyWait, LButton, D T0.2	; and pressed again within 0.2 seconds
		if ErrorLevel ; timed-out (only a single press)
		{
			CHAR := 0
		}
		else
		{
			CHAR := 1
		}
	}
	FAST = 0
	Gui, RealmBuddy:Submit, NoHide
	Gui, ServersGUI:Submit, Hide
	scroll = 1
	MultiplierX := 0.2
	MultiplierY := 0.75
	server = Australia
	Gosub, ChangeServer
}
return

;;;;;;;;;;;;;;				CHANGE SERVER FUNCTION					;;;;;;;;;;;;;;;;;;;;;;
GetPosition()
{
	Global xpos
	Global ypos
	Global width
	Global height
	Global xpos2
	Global ypos2
	Global width2
	Global height2
	Global Kong
	; CoordMode, Mouse, Screen
	WinWaitActive ahk_group rotmg
	{
		WinGetClass, ClassList, ahk_group rotmg
		if ClassList = Chrome_WidgetWin_1 ; Chrome / Opera
		{
			ControlGetPos, xpos, ypos, width, height, , ahk_group rotmg ; Get width and height of A(ctive) window
			; CoordMode, Mouse
			WinGetPos, xpos2, ypos2, width2, height2, ahk_group rotmg ; Get width and height of A(ctive) window
			if Kong != 1
			{
				xpos += (width / 2) - 400
				ypos += 0
				width = 800
				height = 600
				xpos2 = %xpos%
				ypos2 = %ypos%
				width2 = %width%
				height2 = %height%
			}
		}
		else if ClassList = IEFrame ; IE
		{
			ControlGetPos, xpos, ypos, width, height, MacromediaFlashPlayerActiveX1, ahk_group rotmg ; Get width and height of A(ctive) window
			; CoordMode, Mouse
			ControlGetPos, xpos2, ypos2, width2, height2, MacromediaFlashPlayerActiveX1, ahk_group rotmg ; Get width and height of A(ctive) window
		}
		else if ClassList = MozillaWindowClass ; Firefox
		{
			SysGet, HBar, 55 ; alt bar
			SysGet, HBut, 31 ; buttons
			SysGet, HBor, 33 ; border
			SysGet, WBor, 32 ; border
			ControlGetPos, xpos, ypos, width, height, , ahk_group rotmg
			if (width != A_ScreenWidth && height != A_ScreenHeight)
			{
				xpos := xpos + WBor
				ypos := ypos + HBor + HBar + Hbut
				width := width - WBor - WBor
				height := height - HBar - HBut - HBor - HBor
			}
			ControlGetPos, xpos2, ypos2, width2, height2, , ahk_group rotmg
			if Kong != 1
			{
				xpos += ((width2 + 3*width)/ 2) - 400
				ypos += 68
				width = 800
				height = 600
				xpos2 = %xpos%
				ypos2 = %ypos%
				width2 = %width%
				height2 = %height%
			}
			; if WinActive("Waterfox")
			; {
				; ControlGetPos, xpos, ypos, width, height, GeckoPluginWindow1, ahk_group rotmg ; Get width and height of A(ctive) window
			; }
			; else
			; {
				; ControlGetPos, xpos, ypos, width, height, GeckoFPSandboxChildWindow1, ahk_group rotmg ; Get width and height of A(ctive) window
			; }
			; if NeedOCR = 1
			; {
				; xpos2 = %xpos%
				; ypos2 = %ypos%
				; width2 = %width%
				; height2 = %height%
			; }
		}
		else if (ClassList = "ApolloRuntimeContentWindow") ; Steam
		{
			ControlGetPos, xpos, ypos, width, height, , ahk_group rotmg
			WinGetPos, xpos2, ypos2, width2, height2, ahk_group rotmg
		}
		else if (ClassList = "ShockwaveFlash") ; Flash Player
		{
			; SysGet, HBar, 55 ; alt bar
			; SysGet, HBut, 31 ; buttons
			; SysGet, HBor, 33 ; border
			; SysGet, WBor, 32 ; border
			ControlGetPos, xpos, ypos, width, height, , ahk_group rotmg
			; if (width != A_ScreenWidth && height != A_ScreenHeight)
			; {
				; xpos := xpos + WBor
				; ypos := ypos + HBor + HBar + Hbut
				; width := width - WBor - WBor
				; height := height - HBar - HBut - HBor - HBor
			; }
			
			WinGetPos, xpos2, ypos2, width2, height2, ahk_group rotmg
			; msgbox x1 %xpos% y1 %ypos% w1 %width% h1 %height% // x2 %xpos2% y2 %ypos2% w2 %width2% h2 %height2%
		}
		else if ClassList = ShockwaveFlashFullScreen ; Youtube
		{
			RestoreCursors()
			WinWaitActive, ahk_group rotmg
		}
		else
		{
			;MsgBox Error, %ClassList% is not found
		}
	}
}
return

ChangeServer:
global HotkeyList
global NumOKey
If WinExist("ahk_group rotmg")
{
		WinWaitActive, ahk_group rotmg
		{
			Gui, Font, cGreen  
			GuiControl, Font, ERROR  
			GuiControl,, ERROR, GOOD
			
			OptionKey := HotkeyList[NumOKey].hk
			if (%CoinPixel% = "ERROR" || %FamePixel% = "ERROR")
			{
				msgbox You have to do the "Change Pixels" in Settings for it to work
				return
			}
			GetPosition()
			WinActivate, ahk_group rotmg
			Sleep 100
			WinWaitActive, ahk_group rotmg
			MinimapX := xpos + (0.85 * width)
			MinimapY := ypos + (0.2 * height)
			Sleep 300
			MouseGetPos, oldx, oldy
			Click %MinimapX% %MinimapY%
			MouseMove, %oldx%, %oldy%
			SendInput {%OptionKey%}
			Loop
			{
				ControlGetPos, xpos, ypos, width, height,, A ; Get width and height of A(ctive) window
				width += xpos
				height += ypos
				PixelSearch, PCx, PCy, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
				If ErrorLevel
				{
					PixelSearch, PCx, PCy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
					If ErrorLevel
						break
				}
				Else
					Continue
			}
			GetPosition()
			HomeX := xpos + (0.86 * width) ; coordinate X of your Back to Home button
			HomeY := ypos + (0.91 * height) ; coordinate Y of your Back to Home button
			Sleep 300
			MouseGetPos, oldx, oldy
			Click %HomeX%, %HomeY%
			MouseMove, %oldx%, %oldy%
			Gosub, ChangeServer2
			return
		}
}
return

ChangeServer2:
Global CHAR
If WinExist("ahk_group rotmg")
{
		WinWaitActive, ahk_group rotmg
		{
			KillScript = 0
			ControlGetPos, xpos, ypos, width, height,, A ; Get width and height of A(ctive) window
			width += xpos
			height += ypos
			Loop
			{
				PixelSearch, Px, Py, xpos, ypos, width, height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
				if ErrorLevel ; If not found
				{
					if a_index > 500
					{
						KillScript = 1
						break
					}
					else
					{
						KillScript = 0
						continue
					}
				}
				else 
				{
					PixelSearch, Px, Py, xpos, ypos, width, height, %FamePixel%, 10, Fast RGB ; orange (fame)
					if ErrorLevel ; If not found
					{
						if a_index > 500
						{
							KillScript = 1
							break
						}
						else
						{
							KillScript = 0
							continue
						}
					}
				}
				break
			}
			if KillScript = 1
			{
				Gui, RealmBuddy:Font, cRed 
				GuiControl, RealmBuddy:Font, ERROR 
				GuiControl ,RealmBuddy:, ERROR, ERROR
				Return
			}
			else
			{
				IfWinActive, %WinTitle%
				{
					WinGetTitle, Title, A
					Gui, RealmBuddy:Font, cGreen  
					GuiControl, RealmBuddy:Font, ERROR  
					GuiControl,RealmBuddy:, ERROR, GOOD
					GuiControl,RealmBuddy:, SERVER, %server%
					GuiControl,RealmBuddy:, REALM, Nexus
					realm = Nexus
					IniWrite, %server%, %ININame%, %Title%, Server
					IniWrite, %realm%, %ININame%, %Title%, Realm
				}
				if StopAtCharScreen = 0 
				{
					GetPosition()
					MainButtonX := xpos + (0.4 * width) ; coordinate X of your Main button
					MainButtonY := ypos + (0.92 * height) ; coordinate Y of your Main button
					Sleep 300
					MouseGetPos, oldx, oldy
					Click %MainButtonX%, %MainButtonY%
					MouseMove, %oldx%, %oldy%
					Sleep 300
					MouseGetPos, oldx, oldy
					Click %MainButtonX%, %MainButtonY%
					MouseMove, %oldx%, %oldy%
					if scroll = 1
					{
						GetPosition()
						Scroll1X := xpos + (0.978 * width) ; coordinate X of your Scroll button 
						Scroll1Y := ypos + (0.35 * height) ; coordinate Y of your Scroll button (begin)
						Scroll2Y := ypos + (0.7 * height) ; coordinate Y of your Scroll button (end)
						Sleep 300
						MouseGetPos, oldx, oldy
						Click down %Scroll1X%, %Scroll1Y%
						Sleep 300
						Click up %Scroll1X%, %Scroll2Y%
						MouseMove, %oldx%, %oldy%
					}
					GetPosition()
					serverX := xpos + (MultiplierX * width)
					serverY := ypos + (MultiplierY * height)
					Sleep 300
					MouseGetPos, oldx, oldy
					Click %serverX%, %serverY%
					MouseMove, %oldx%, %oldy%
					GetPosition()
					DoneX := xpos + (width / 2) ; coordinate X of your Done button
					DoneY := ypos + (0.92 * height) ; coordinate Y of your Done button
					Sleep 300
					MouseGetPos, oldx, oldy
					Click %DoneX%, %DoneY%
					MouseMove, %oldx%, %oldy%
					Sleep 300
					MouseGetPos, oldx, oldy
					Click %DoneX%, %DoneY%
					MouseMove, %oldx%, %oldy%
					if CHAR = 0 
					{
						MouseGetPos, oldx, oldy
						Click %DoneX%, %DoneY%
						MouseMove, %oldx%, %oldy%
					}
				}
			StopAtCharScreen = 0
			Return
			}
		}
}
return

;;;;;;;;;;;;;;				FIND REALM FUNCTION					;;;;;;;;;;;;;;;;;;;;;;
$~LButton::
{
	IfWinActive, %WinTitle%
	{
		WinGetTitle, Title, A
		IniRead, Path, %ININame%, Settings, Path
		IniRead, TheRealm, %ININame%, %Title%, Realm
		IniRead, TheServer, %ININame%, %Title%, Server
		IniRead, TheWhatCall, %ININame%, Settings, WhatCall
		IniRead, TimerOn, %ININame%, %Title%, TimerOn
		GuiControl,RealmBuddy:, REALM, %TheRealm%
		GuiControl,RealmBuddy:, SERVER, %TheServer%
		if TheWhatCall = 
		{
			GuildCallSaved = Choose2
			GuiControl, Settings:Choose, GuildCall, 2
			WhatCall := ""
			PG = public
			GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
		}
		else
		{
			GuildCallSaved = Choose1
			GuiControl, Settings:Choose, GuildCall, 1
			WhatCall := "/g "
			PG = guild
			GuiControl, EventsGUI:, GuildPub, quests/%PG%.png
		}
		realm = %TheRealm%
		server = %TheServer%
	}
}
return

;;;;;;;;;;;;;;				INTERACT FUNCTION					;;;;;;;;;;;;;;;;;;;;;;
InteractButton:
{
}
return

;;;;;;;;;;;;;;				INGAME HUD GUI					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub15:
if HUDPressed = 1
{
	Gui, HUD:Submit, Hide
	HUDPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	HUDGuiX := xpos + (0.3 * width)
	HUDGuiY := ypos + (0.3 * height)
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		Gui, HUD:Show, NA x%HUDGuiX% y%HUDGuiY%, HUD
		HUDPressed = 1
		
		Gui, MacroGUI:Submit, Hide
		;Gui, HUDGUI:Submit, Hide
		Gui, ServersGUI:Submit, Hide
		Gui, EventsGUI:Submit, Hide
		Gui, SpeechGUI:Submit, Hide
		Gui, CallsGUI:Submit, Hide
		MacroPressed = 0
		;HUDPressed = 0
		ServerPressed = 0
		CallPressed = 0
		CallsPressed = 0
		SpeechPressed = 0
		
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				INGAME MACRO GUI					     ;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub14:
if MacroPressed = 1
{
	Gui, MacroGUI:Submit, Hide
	MacroPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		MacroGUIX := xpos2 + (0.01 * width2)
		MacroGUIY := ypos2 + (0.1 * height2)
		Gui, MacroGUI:Show, NA x%MacroGUIX% y%MacroGUIY%, MacroGUI
		
		;Gui, MacroGUI:Submit, Hide
		Gui, HUDGUI:Submit, Hide
		Gui, ServersGUI:Submit, Hide
		Gui, EventsGUI:Submit, Hide
		Gui, SpeechGUI:Submit, Hide
		Gui, CallsGUI:Submit, Hide
		;MacroPressed = 0
		HUDPressed = 0
		ServerPressed = 0
		CallPressed = 0
		CallsPressed = 0
		SpeechPressed = 0
		
		WinSet, TransColor, 363636 255, MacroGUI
		MacroPressed = 1
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				INGAME SERVER CHANGE GUI					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub1:
if ServerPressed = 1
{
	Gui, ServersGUI:Submit, Hide
	ServerPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		ServGuiX := xpos2 + (0.3 * width2)
		ServGuiY := ypos2 + (0.1 * height2)
		GuiControl,ServersGUI:, RealmGUI,%server% %realm%
		Gui, ServersGUI:Show, NA x%ServGuiX% y%ServGuiY%, ServGUI
		WinSet, TransColor, 363636 255, ServGUI
		ServerPressed = 1
		
		Gui, MacroGUI:Submit, Hide
		Gui, HUDGUI:Submit, Hide
		;Gui, ServersGUI:Submit, Hide
		Gui, EventsGUI:Submit, Hide
		Gui, SpeechGUI:Submit, Hide
		Gui, CallsGUI:Submit, Hide
		MacroPressed = 0
		HUDPressed = 0
		;ServerPressed = 0
		CallPressed = 0
		CallsPressed = 0
		SpeechPressed = 0
		
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				INGAME SPEECH GUI					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub12:
if SpeechPressed = 1
{
	Gui, SpeechGUI:Submit, Hide
	SpeechPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		SpeechGuiX := xpos2 + (0.3 * width2)
		SpeechGuiY := ypos2 + (0.1 * height2)
		Gui, SpeechGUI:Show, NA x%SpeechGuiX% y%SpeechGuiY%, SpeechGUI
		WinSet, TransColor, 363636 255, SpeechGUI
		SpeechPressed = 1
		
		Gui, MacroGUI:Submit, Hide
		Gui, HUDGUI:Submit, Hide
		Gui, ServersGUI:Submit, Hide
		Gui, EventsGUI:Submit, Hide
		;Gui, SpeechGUI:Submit, Hide
		Gui, CallsGUI:Submit, Hide
		MacroPressed = 0
		HUDPressed = 0
		ServerPressed = 0
		CallPressed = 0
		CallsPressed = 0
		;SpeechPressed = 0
		
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				INGAME CALLOUTS GUI					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub2:
if CallPressed = 1
{
	Gui, EventsGUI:Submit, Hide
	CallPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		WinGetTitle, Title, A
		; IniRead, Path, %ININame%, Settings, Path
		IniRead, TheRealm, %ININame%, %Title%, Realm
		IniRead, TheServer, %ININame%, %Title%, Server
		; IniRead, TheWhatCall, %ININame%, %Title%, WhatCall
		GuiControl, EventsGUI:ChooseString, RChoice, %TheRealm%
		GuiControl, EventsGUI:ChooseString, SChoice, %TheServer%
		GuiControl,RealmBuddy:, REALM, %TheRealm%
		GuiControl,RealmBuddy:, SERVER, %TheServer%
		EventsGuiX := xpos2 + (0.01 * width2)
		EventsGuiY := ypos2 + (0.1 * height2)
		Gui, EventsGUI:Show, NA x%EventsGuiX% y%EventsGuiY%, EventsGUI
		WinSet, TransColor, 363636 255, EventsGUI
		CallPressed = 1
		
		Gui, MacroGUI:Submit, Hide
		Gui, HUDGUI:Submit, Hide
		Gui, ServersGUI:Submit, Hide
		;Gui, EventsGUI:Submit, Hide
		Gui, SpeechGUI:Submit, Hide
		Gui, CallsGUI:Submit, Hide
		MacroPressed = 0
		HUDPressed = 0
		ServerPressed = 0
		;CallPressed = 0
		CallsPressed = 0
		SpeechPressed = 0
		
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				INGAME CALLS GUI					;;;;;;;;;;;;;;;;;;;;;;

OtherKeySub13:
if CallsPressed = 1
{
	Gui, CallsGUI:Submit, Hide
	CallsPressed = 0
	Sleep 10
}
else
{
	GetPosition()
	PixelSearch, Px, Py, xpos, ypos, xpos + width, ypos + height, %CoinPixel%, 10, Fast RGB ; yellow (coin)
	Sleep 10
	if ErrorLevel = 0
	{
		Sleep 10
		PixelSearch, PMx, PMy, xpos, ypos, xpos + width, ypos + height, %FamePixel%, 10, Fast RGB ; orange (fame)
		if ErrorLevel = 0
		{
			InGame = 1
		}	
	}
	else
	{
		InGame = 0
	}
	if InGame = 1
	{
		CallsGUIX := xpos2 + (0.01 * width2)
		CallsGUIY := ypos2 + (0.1 * height2)
		Gui, CallsGUI:Show, NA x%CallsGUIX% y%CallsGUIY%, CallsGUI
		WinSet, TransColor, 363636 255, CallsGUI
		CallsPressed = 1
		
		Gui, MacroGUI:Submit, Hide
		Gui, HUDGUI:Submit, Hide
		Gui, ServersGUI:Submit, Hide
		Gui, EventsGUI:Submit, Hide
		Gui, SpeechGUI:Submit, Hide
		;Gui, CallsGUI:Submit, Hide
		MacroPressed = 0
		HUDPressed = 0
		ServerPressed = 0
		CallPressed = 0
		;CallsPressed = 0
		SpeechPressed = 0
		
		Sleep 10
	}
}
return

;;;;;;;;;;;;;;				CALLOUTS FUNCTION					;;;;;;;;;;;;;;;;;;;;;;

FastChat:
global HotkeyList
global NumACKey
ActivateChat := HotkeyList[NumACKey].hk
Gui, EventsGUI:Submit, Hide
Gui, CallsGUI:Submit, Hide
Gui, MacroGUI:Submit, Hide
WinActivate, ahk_group rotmg
WinGetTitle, Title, A
GetPosition()
CallPressed = 0
CallsPressed = 0
MacroPressed = 0
TextToSend = %WhatCall%%MyEvent% %server% %realm%
Last = %MyEvent% %server% %realm%
WinActivate, ahk_group rotmg
Sleep 100
WinWaitActive, ahk_group rotmg
MinimapX := xpos + (0.85 * width)
MinimapY := ypos + (0.2 * height)
MouseGetPos, oldx, oldy
Click %MinimapX% %MinimapY%
MouseMove, %oldx%, %oldy%
Blockinput, on
SendInput {%ActivateChat%}
SendInput ^a
SendInput {Raw}%TextToSend%
SendInput {Enter}
Blockinput, off
return

LastOne:
global HotkeyList
global NumACKey
ActivateChat := HotkeyList[NumACKey].hk
Gui, EventsGUI:Submit, Hide
Gui, CallsGUI:Submit, Hide
Gui, MacroGUI:Submit, Hide
WinActivate, ahk_group rotmg
GetPosition()
CallPressed = 0
CallsPressed = 0
MacroPressed = 0
WinActivate, ahk_group rotmg
Sleep 100
WinWaitActive, ahk_group rotmg
MinimapX := xpos + (0.85 * width)
MinimapY := ypos + (0.2 * height)
MouseGetPos, oldx, oldy
Click %MinimapX% %MinimapY%
MouseMove, %oldx%, %oldy%
Blockinput, on
SendInput {%ActivateChat%}
SendInput ^a
SendInput {Raw}%WhatCall%%Last%
SendInput {Enter}
Blockinput, off
return

SmallChat:
global HotkeyList
global NumACKey
ActivateChat := HotkeyList[NumACKey].hk
Gui, EventsGUI:Submit, Hide
Gui, CallsGUI:Submit, Hide
Gui, MacroGUI:Submit, Hide
WinActivate, ahk_group rotmg
GetPosition()
CallPressed = 0
CallsPressed = 0
MacroPressed = 0
WinActivate, ahk_group rotmg
Sleep 100
WinWaitActive, ahk_group rotmg
MinimapX := xpos + (0.85 * width)
MinimapY := ypos + (0.2 * height)
MouseGetPos, oldx, oldy
Click %MinimapX% %MinimapY%
MouseMove, %oldx%, %oldy%
Blockinput, on
SendInput {%ActivateChat%}
SendInput ^a
SendInput {Raw}%WhatCall%%CallText%
SendInput {Enter}
Blockinput, off
return

CallChat:
global HotkeyList
global NumACKey
ActivateChat := HotkeyList[NumACKey].hk
Gui, EventsGUI:Submit, Hide
Gui, CallsGUI:Submit, Hide
Gui, MacroGUI:Submit, Hide
WinActivate, ahk_group rotmg
GetPosition()
CallPressed = 0
CallsPressed = 0
MacroPressed = 0
WinActivate, ahk_group rotmg
Sleep 100
WinWaitActive, ahk_group rotmg
MinimapX := xpos + (0.85 * width)
MinimapY := ypos + (0.2 * height)
MouseGetPos, oldx, oldy
Click %MinimapX% %MinimapY%
MouseMove, %oldx%, %oldy%
Blockinput, on
SendInput {%ActivateChat%}
SendInput ^a
SendInput {Raw}%CallText%
SendInput {Enter}
Blockinput, off
return

;;;;;;;;;;;;;;			  	 CALLS LIST					    ;;;;;;;;;;;;;;;;;;;;;;

HeLives:
{
	CallText := "He lives and reigns and conquers the world"
	GoSub, CallChat
}
return

Ready:
{
	CallText := "100% ready !!!"
	GoSub, CallChat
}
return

Answer1:
{
	CallText := "It's pizza time!" 
	GoSub, CallChat
	Gui, MratGUI:Show, Hide
}
return
Answer2:
{
	CallText := "Inside my shell."
	GoSub, CallChat
	Gui, MratGUI:Show, Hide
}
return
Answer3:
{
	CallText := "A ninja of course!"
	GoSub, CallChat
	Gui, MratGUI:Show, Hide
}
return
Answer4:
{
	CallText := "Extra cheese, hold the anchovies."
	GoSub, CallChat
	Gui, MratGUI:Show, Hide
}
return
Answer5:
{
	CallText := "Dr Terrible, the Mad Scientist."
	GoSub, CallChat
	Gui, MratGUI:Show, Hide
}
return
Mrat:
{
	Gui, MratGUI:Show, NA
}
return

Skip:
{
	CallText := "Skip"
	GoSub, CallChat
}
return

Sarc:
{
	CallText := "Sarcophagus here!"
	GoSub, CallChat
}
return

Troom:
{
	CallText := "Treasure Room here!"
	GoSub, CallChat
}
return

Black:
{
	CallText := "Black!"
	GoSub, CallChat
	CallText := "Black!"
	GoSub, CallChat
	CallText := "Black!"
	GoSub, CallChat
}
return

Blue:
{
	CallText := "Blue!"
	GoSub, CallChat
	CallText := "Blue!"
	GoSub, CallChat
	CallText := "Blue!"
	GoSub, CallChat
}
return

Red:
{
	CallText := "Red!"
	GoSub, CallChat
	CallText := "Red!"
	GoSub, CallChat
	CallText := "Red!"
	GoSub, CallChat
}
return

Green:
{
	CallText := "Green!"
	GoSub, CallChat
	CallText := "Green!"
	GoSub, CallChat
	CallText := "Green!"
	GoSub, CallChat
}
return

Bes:
{
	CallText := "BES!!!"
	GoSub, CallChat
}
return

Nut:
{
	CallText := "NUT!!!"
	GoSub, CallChat
}
return

Geb:
{
	CallText := "GEB!!!"
	GoSub, CallChat
}
return

;;;;;;;;;;;;;;				MACRO LIST					;;;;;;;;;;;;;;;;;;;;;;

Life:
{
	CallText := "Could you please heal me ?"
	GoSub, CallChat
}
return
Mana:
{
	CallText := "I'm out of mana!"
	GoSub, CallChat
}
return
Boost:
{
	CallText := "Let's boost guys!"
	GoSub, CallChat
}
return
Sorry:
{
	CallText := "Sorry, I failed, my apologies :("
	GoSub, CallChat
}
return
Thanks:
{
	CallText := "Thanks, it's really appreciated!"
	GoSub, CallChat
}
return
Np:
{
	CallText := "No Problemo :D"
	GoSub, CallChat
}
return
Gl:
{
	CallText := "Good Luck everyone !"
	GoSub, CallChat
}
return
Go:
{
	CallText := "3 2 1 Let's go guys!"
	GoSub, CallChat
}
return
Stop:
{
	CallText := "WAIT!! WAIT!! WAIT!!"
	GoSub, CallChat
}
return
Help:
{
	CallText := "Anyone would be kind enough to come help me ? :/"
	GoSub, CallChat
}
return
;;;;;;;;;;;;;;				CALLOUTS LIST					;;;;;;;;;;;;;;;;;;;;;;

SPHINX:
{
	MyEvent := "Sphinx"
	GoSub, FastChat
}
return
TOMB:
{
	MyEvent := "Tomb"
	GoSub, FastChat
}
return
NOTOMB:
{
	MyEvent := "Nomb"
	GoSub, FastChat
}
return
HERMIT:
{
	MyEvent := "Hermit"
	GoSub, FastChat
}
return
TRENCH:
{
	MyEvent := "Trench"
	GoSub, FastChat
}
return
WC:
{
	MyEvent := "Wine Cellar"
	GoSub, FastChat
}
return
CRYSTAL:
{
	MyEvent := "Crystal"
	GoSub, FastChat
}
return
DOCKS:
{
	MyEvent := "Docks"
	GoSub, FastChat
}
return
LICH:
{
	MyEvent := "Liches"
	GoSub, FastChat
}
return
ENT:
{
	MyEvent := "Ents"
	GoSub, FastChat
}
return
LORD:
{
	MyEvent := "Lotll"
	GoSub, FastChat
}
return
Ship:
{
	MyEvent := "Ship"
	GoSub, FastChat
}
return
DJL:
{
	MyEvent := "Davy"
	GoSub, FastChat
}
return
NODJL:
{
	MyEvent := "Navy"
	GoSub, FastChat
}
return
Cube:
{
	MyEvent := "Cube"
	GoSub, FastChat
}
return
Shrine:
{
	MyEvent := "Skull"
	GoSub, FastChat
}
return
Pentaract:
{
	MyEvent := "Pentaract"
	GoSub, FastChat
}
return
Dragon:
{
	MyEvent := "Rock Dragon"
	GoSub, FastChat
}
return
LoD:
{
	MyEvent := "LoD"
	GoSub, FastChat
}
return
NOLoD:
{
	MyEvent := "NoD"
	GoSub, FastChat
}
return
Avatar:
{
	MyEvent := "Avatar"
	GoSub, FastChat
}
return
Shatters:
{
	MyEvent := "Shatters"
	GoSub, FastChat
}
return
NOShatters:
{
	MyEvent := "Natters"
	GoSub, FastChat
}
return
Ice:
{
	MyEvent := "Ice Cave"
	GoSub, FastChat
}
return
NOIce:
{
	MyEvent := "No Ice Cave"
	GoSub, FastChat
}
return
LDjinn:
{
	MyEvent := "Lucky Djinn"
	GoSub, FastChat
}
return
LEnt:
{
	MyEvent := "Lucky Ent"
	GoSub, FastChat
}
return
DEPTHS:
{
	MyEvent := "Depths"
	GoSub, FastChat
}
return
WOOD:
{
	MyEvent := "Woodland"
	GoSub, FastChat
}
return
Kage:
{
	MyEvent := "Kage"
	GoSub, FastChat
}
return
Manor:
{
	MyEvent := "Manor"
	GoSub, FastChat
}
return
Closed:
{
	MyEvent := "Realm Closed"
	GoSub, FastChat
}
return
Shake:
{
	MyEvent := "Realm Shaking"
	GoSub, FastChat
}
return
Cland:
{
	MyEvent := "Candy Land"
	GoSub, FastChat
}
return
Shaitan:
{
	MyEvent := "Shaitan"
	GoSub, FastChat
}
return
;;;;;;;;;;;;;; LESSER DUNGEONS ;;;;;;;;;;;;;;;;
Pirate:
{
	CallText := "Pirate Cave"
	GoSub, SmallChat
}
return
Abyss:
{
	CallText := "Abyss"
	GoSub, SmallChat
}
return
UDL:
{
	CallText := "UDL"
	GoSub, SmallChat
}
return
Sprite:
{
	CallText := "Sprite"
	GoSub, SmallChat
}
return
Lab:
{
	CallText := "Mad Lab"
	GoSub, SmallChat
}
return
Snake:
{
	CallText := "Snake Pit"
	GoSub, SmallChat
}
return
Cemetary:
{
	CallText := "Cemetary"
	GoSub, SmallChat
}
return
Puppet:
{
	CallText := "Puppet"
	GoSub, SmallChat
}
return


;;;;;;;;;;;;;;				REALMBUDDY QUICKSPEECH SETTINGS					;;;;;;;;;;;;;;;;;;;;;;

; CheckAll Buttons
CheckingAll(ThisVar, NumberVar)
{
	Gui,HotkeyGUI:Submit, NoHide
	GuiControlGet, QSPage, HotkeyGUI:, QSPage
	AllChecked := 0
	NormalAll := 10
	if QSPage = 1
	{
		NewIndex := 0
	}
	else if QSPage = 2
	{
		NewIndex := 10
	}
	else if QSPage = 3
	{
		NewIndex := 20
	}
	else if QSPage = 4
	{
		NewIndex := 30
	}
	Loop 10
	{
		TabIndex := NewIndex + A_Index
		GuiControlGet, VarDisabled, HotkeyGUI:Enabled, %ThisVar%%TabIndex%
		if (%ThisVar%%TabIndex% = 1 && VarDisabled = 1)
		{
			AllChecked += 1
		}
		if VarDisabled = 0
		{
			NormalAll -= 1
			msgbox %TabIndex% + %A_Index%
		}
	}
	Test1b := Round(NormalAll / 2)
	Test1a := NormalAll - AllChecked
	if (Test1a = 0 || Test1a > Test1b && Test1a != NormalAll)
	{
		Loop 10
		{
			TabIndex := NewIndex + A_Index
			GuiControlGet, VarDisabled, HotkeyGUI:Enabled, %ThisVar%%TabIndex%
			if (%ThisVar%%TabIndex% != ERROR && %ThisVar%%TabIndex% != 0 && VarDisabled = 1)
			{
				GuiControl,HotkeyGUI: , %ThisVar%%TabIndex%, 0
			}
		}
		GuiControl,HotkeyGUI: , Checker%NumberVar%, All
	}
	else
	{
		Loop 10
		{
			TabIndex := NewIndex + A_Index
			GuiControlGet, VarDisabled, HotkeyGUI:Visible, %ThisVar%%TabIndex%
			if (%ThisVar%%TabIndex% != ERROR && %ThisVar%%TabIndex% != 1 && VarDisabled = 1)
			{
				GuiControl,HotkeyGUI: , %ThisVar%%TabIndex%, 1
			}
		}
		GuiControl,HotkeyGUI: , Checker%NumberVar%, None
	}
	OptionChanged("checkall")
}
return  
CheckAll:
{
	CheckingAll("RealmCheck", 1)
}
return
CheckAll2:
{
	CheckingAll("TabCheck", 2)
}
return

;;;;;;;;;;;;;;				QUICKSPEECH FUNCTION LIST					;;;;;;;;;;;;;;;;;;;;;;

KeySub1:
{
	global HotkeyList
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck1, %ININame% , Quick Speech Realm Checkbox, Checkbox1
	if RealmCheck1 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			IniRead, CurrentTP, %ININame%, Settings, CurrentTP
			SendInput {%ActivateChat%}{Raw}/teleport %CurrentTP%
			SendInput {Enter}
		}
	}
	else
	{
		IniRead, CurrentTP, %ININame%, Settings, CurrentTP
		SendInput {%ActivateChat%}{Raw}/teleport %CurrentTP%
		SendInput {Enter}
	}
}
return
KeySub2: 
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck2, %ININame% , Quick Speech Realm Checkbox, Checkbox2
	IniRead, TabCheck2, %ININame% , Quick Speech Realm Checkbox, TabCheckbox2
	if RealmCheck2 = 0
	{
		if TabCheck2 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText2%
			SendInput {Enter}
		}
		else if TabCheck2 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText2%
			SendInput {Enter}
		}
	}
	else if RealmCheck2 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck2 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText2%
				SendInput {Enter}
			}
			else if TabCheck2 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText2%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub3:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck3, %ININame% , Quick Speech Realm Checkbox, Checkbox2
	IniRead, TabCheck3, %ININame% , Quick Speech Realm Checkbox, TabCheckbox3
	if RealmCheck3 = 0
	{
		if TabCheck3 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText3%
			SendInput {Enter}
		}
		else if TabCheck3 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText3%
			SendInput {Enter}
		}
	}
	else if RealmCheck3 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck3 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText3%
				SendInput {Enter}
			}
			else if TabCheck3 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText3%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub4:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck4, %ININame% , Quick Speech Realm Checkbox, Checkbox4
	IniRead, TabCheck4, %ININame% , Quick Speech Realm Checkbox, TabCheckbox4
	if RealmCheck4 = 0
	{
		if TabCheck4 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText4%
			SendInput {Enter}
		}
		else if TabCheck4 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText4%
			SendInput {Enter}
		}
	}
	else if RealmCheck4 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck4 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText4%
				SendInput {Enter}
			}
			else if TabCheck4 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText4%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub5:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck5, %ININame% , Quick Speech Realm Checkbox, Checkbox5
	IniRead, TabCheck5, %ININame% , Quick Speech Realm Checkbox, TabCheckbox5
	if RealmCheck5 = 0
	{
		if TabCheck5 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText5%
			SendInput {Enter}
		}
		else if TabCheck5 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText5%
			SendInput {Enter}
		}
	}
	else if RealmCheck5 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck5 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText5%
				SendInput {Enter}
			}
			else if TabCheck5 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText5%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub6:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck6, %ININame% , Quick Speech Realm Checkbox, Checkbox6
	IniRead, TabCheck6, %ININame% , Quick Speech Realm Checkbox, TabCheckbox6
	if RealmCheck6 = 0
	{
		if TabCheck6 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText6%
			SendInput {Enter}
		}
		else if TabCheck6 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText6%
			SendInput {Enter}
		}
	}
	else if RealmCheck6 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck6 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText6%
				SendInput {Enter}
			}
			else if TabCheck6 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText6%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub7:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck7, %ININame% , Quick Speech Realm Checkbox, Checkbox7
	IniRead, TabCheck7, %ININame% , Quick Speech Realm Checkbox, TabCheckbox7
	if RealmCheck7 = 0
	{
		if TabCheck7 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText7%
			SendInput {Enter}
		}
		else if TabCheck7 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText7%
			SendInput {Enter}
		}
	}
	else if RealmCheck7 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck7 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText7%
				SendInput {Enter}
			}
			else if TabCheck7 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText7%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub8:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck8, %ININame% , Quick Speech Realm Checkbox, Checkbox8
	IniRead, TabCheck8, %ININame% , Quick Speech Realm Checkbox, TabCheckbox8
	if RealmCheck8 = 0
	{
		if TabCheck8 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText8%
			SendInput {Enter}
		}
		else if TabCheck8 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText8%
			SendInput {Enter}
		}
	}
	else if RealmCheck8 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck8 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText8%
				SendInput {Enter}
			}
			else if TabCheck8 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText8%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub9:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck9, %ININame% , Quick Speech Realm Checkbox, Checkbox9
	IniRead, TabCheck9, %ININame% , Quick Speech Realm Checkbox, TabCheckbox9
	if RealmCheck9 = 0
	{
		if TabCheck9 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText9%
			SendInput {Enter}
		}
		else if TabCheck9 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText9%
			SendInput {Enter}
		}
	}
	else if RealmCheck9 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck9 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText9%
				SendInput {Enter}
			}
			else if TabCheck9 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText9%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub10:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck10, %ININame% , Quick Speech Realm Checkbox, Checkbox10
	IniRead, TabCheck10, %ININame% , Quick Speech Realm Checkbox, TabCheckbox10
	if RealmCheck10 = 0
	{
		if TabCheck10 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText10%
			SendInput {Enter}
		}
		else if TabCheck10 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText10%
			SendInput {Enter}
		}
	}
	else if RealmCheck10 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck10 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText10%
				SendInput {Enter}
			}
			else if TabCheck10 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText10%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub11:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck11, %ININame% , Quick Speech Realm Checkbox, Checkbox11
	IniRead, TabCheck11, %ININame% , Quick Speech Realm Checkbox, TabCheckbox11
	if RealmCheck11 = 0
	{
		if TabCheck11 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText11%
			SendInput {Enter}
		}
		else if TabCheck11 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText11%
			SendInput {Enter}
		}
	}
	else if RealmCheck11 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck11 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText11%
				SendInput {Enter}
			}
			else if TabCheck11 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText11%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub12:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck12, %ININame% , Quick Speech Realm Checkbox, Checkbox12
	IniRead, TabCheck12, %ININame% , Quick Speech Realm Checkbox, TabCheckbox12
	if RealmCheck12 = 0
	{
		if TabCheck12 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText12%
			SendInput {Enter}
		}
		else if TabCheck12 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText12%
			SendInput {Enter}
		}
	}
	else if RealmCheck12 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck12 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText12%
				SendInput {Enter}
			}
			else if TabCheck12 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText12%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub13:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck13, %ININame% , Quick Speech Realm Checkbox, Checkbox13
	IniRead, TabCheck13, %ININame% , Quick Speech Realm Checkbox, TabCheckbox13
	if RealmCheck13 = 0
	{
		if TabCheck13 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText13%
			SendInput {Enter}
		}
		else if TabCheck13 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText13%
			SendInput {Enter}
		}
	}
	else if RealmCheck13 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck13 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText13%
				SendInput {Enter}
			}
			else if TabCheck13 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText13%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub14:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck14, %ININame% , Quick Speech Realm Checkbox, Checkbox14
	IniRead, TabCheck14, %ININame% , Quick Speech Realm Checkbox, TabCheckbox14
	if RealmCheck14 = 0
	{
		if TabCheck14 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText14%
			SendInput {Enter}
		}
		else if TabCheck14 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText14%
			SendInput {Enter}
		}
	}
	else if RealmCheck14 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck14 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText14%
				SendInput {Enter}
			}
			else if TabCheck14 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText14%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub15:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck15, %ININame% , Quick Speech Realm Checkbox, Checkbox15
	IniRead, TabCheck15, %ININame% , Quick Speech Realm Checkbox, TabCheckbox15
	if RealmCheck15 = 0
	{
		if TabCheck15 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText15%
			SendInput {Enter}
		}
		else if TabCheck15 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText15%
			SendInput {Enter}
		}
	}
	else if RealmCheck15 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck15 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText15%
				SendInput {Enter}
			}
			else if TabCheck15 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText15%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub16:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck16, %ININame% , Quick Speech Realm Checkbox, Checkbox16
	IniRead, TabCheck16, %ININame% , Quick Speech Realm Checkbox, TabCheckbox16
	if RealmCheck16 = 0
	{
		if TabCheck16 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText16%
			SendInput {Enter}
		}
		else if TabCheck16 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText16%
			SendInput {Enter}
		}
	}
	else if RealmCheck16 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck16 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText16%
				SendInput {Enter}
			}
			else if TabCheck16 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText16%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub17:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck17, %ININame% , Quick Speech Realm Checkbox, Checkbox17
	IniRead, TabCheck17, %ININame% , Quick Speech Realm Checkbox, TabCheckbox17
	if RealmCheck17 = 0
	{
		if TabCheck17 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText17%
			SendInput {Enter}
		}
		else if TabCheck17 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText17%
			SendInput {Enter}
		}
	}
	else if RealmCheck17 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck17 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText17%
				SendInput {Enter}
			}
			else if TabCheck17 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText17%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub18:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck18, %ININame% , Quick Speech Realm Checkbox, Checkbox18
	IniRead, TabCheck18, %ININame% , Quick Speech Realm Checkbox, TabCheckbox18
	if RealmCheck18 = 0
	{
		if TabCheck18 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText18%
			SendInput {Enter}
		}
		else if TabCheck18 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText18%
			SendInput {Enter}
		}
	}
	else if RealmCheck18 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck18 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText18%
				SendInput {Enter}
			}
			else if TabCheck18 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText18%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub19:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck19, %ININame% , Quick Speech Realm Checkbox, Checkbox19
	IniRead, TabCheck19, %ININame% , Quick Speech Realm Checkbox, TabCheckbox19
	if RealmCheck19 = 0
	{
		if TabCheck19 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText19%
			SendInput {Enter}
		}
		else if TabCheck19 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText19%
			SendInput {Enter}
		}
	}
	else if RealmCheck19 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck19 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText19%
				SendInput {Enter}
			}
			else if TabCheck19 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText19%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub20:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck20, %ININame% , Quick Speech Realm Checkbox, Checkbox20
	IniRead, TabCheck20, %ININame% , Quick Speech Realm Checkbox, TabCheckbox20
	if RealmCheck20 = 0
	{
		if TabCheck20 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText20%
			SendInput {Enter}
		}
		else if TabCheck20 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText20%
			SendInput {Enter}
		}
	}
	else if RealmCheck20 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck20 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText20%
				SendInput {Enter}
			}
			else if TabCheck20 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText20%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub21:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck21, %ININame% , Quick Speech Realm Checkbox, Checkbox21
	IniRead, TabCheck21, %ININame% , Quick Speech Realm Checkbox, TabCheckbox21
	if RealmCheck21 = 0
	{
		if TabCheck21 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText21%
			SendInput {Enter}
		}
		else if TabCheck21 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText21%
			SendInput {Enter}
		}
	}
	else if RealmCheck21 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck21 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText21%
				SendInput {Enter}
			}
			else if TabCheck21 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText21%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub22: 
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck22, %ININame% , Quick Speech Realm Checkbox, Checkbox22
	IniRead, TabCheck22, %ININame% , Quick Speech Realm Checkbox, TabCheckbox22
	if RealmCheck22 = 0
	{
		if TabCheck22 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText22%
			SendInput {Enter}
		}
		else if TabCheck22 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText22%
			SendInput {Enter}
		}
	}
	else if RealmCheck22 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck22 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText22%
				SendInput {Enter}
			}
			else if TabCheck22 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText22%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub23:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck23, %ININame% , Quick Speech Realm Checkbox, Checkbox23
	IniRead, TabCheck23, %ININame% , Quick Speech Realm Checkbox, TabCheckbox23
	if RealmCheck23 = 0
	{
		if TabCheck23 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText23%
			SendInput {Enter}
		}
		else if TabCheck23 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText23%
			SendInput {Enter}
		}
	}
	else if RealmCheck23 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck23 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText23%
				SendInput {Enter}
			}
			else if TabCheck23 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText23%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub24:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck24, %ININame% , Quick Speech Realm Checkbox, Checkbox24
	IniRead, TabCheck24, %ININame% , Quick Speech Realm Checkbox, TabCheckbox24
	if RealmCheck24 = 0
	{
		if TabCheck24 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText24%
			SendInput {Enter}
		}
		else if TabCheck24 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText24%
			SendInput {Enter}
		}
	}
	else if RealmCheck24 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck24 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText24%
				SendInput {Enter}
			}
			else if TabCheck24 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText24%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub25:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck25, %ININame% , Quick Speech Realm Checkbox, Checkbox25
	IniRead, TabCheck25, %ININame% , Quick Speech Realm Checkbox, TabCheckbox25
	if RealmCheck25 = 0
	{
		if TabCheck25 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText25%
			SendInput {Enter}
		}
		else if TabCheck25 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText25%
			SendInput {Enter}
		}
	}
	else if RealmCheck25 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck25 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText25%
				SendInput {Enter}
			}
			else if TabCheck25 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText25%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub26:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck26, %ININame% , Quick Speech Realm Checkbox, Checkbox26
	IniRead, TabCheck26, %ININame% , Quick Speech Realm Checkbox, TabCheckbox26
	if RealmCheck26 = 0
	{
		if TabCheck26 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText26%
			SendInput {Enter}
		}
		else if TabCheck26 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText26%
			SendInput {Enter}
		}
	}
	else if RealmCheck26 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck26 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText26%
				SendInput {Enter}
			}
			else if TabCheck26 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText26%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub27:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck27, %ININame% , Quick Speech Realm Checkbox, Checkbox27
	IniRead, TabCheck27, %ININame% , Quick Speech Realm Checkbox, TabCheckbox27
	if RealmCheck27 = 0
	{
		if TabCheck27 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText27%
			SendInput {Enter}
		}
		else if TabCheck27 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText27%
			SendInput {Enter}
		}
	}
	else if RealmCheck27 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck27 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText27%
				SendInput {Enter}
			}
			else if TabCheck27 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText27%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub28:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck28, %ININame% , Quick Speech Realm Checkbox, Checkbox28
	IniRead, TabCheck28, %ININame% , Quick Speech Realm Checkbox, TabCheckbox28
	if RealmCheck28 = 0
	{
		if TabCheck28 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText28%
			SendInput {Enter}
		}
		else if TabCheck28 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText28%
			SendInput {Enter}
		}
	}
	else if RealmCheck28 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck28 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText28%
				SendInput {Enter}
			}
			else if TabCheck28 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText28%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub29:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck29, %ININame% , Quick Speech Realm Checkbox, Checkbox29
	IniRead, TabCheck29, %ININame% , Quick Speech Realm Checkbox, TabCheckbox29
	if RealmCheck29 = 0
	{
		if TabCheck29 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText29%
			SendInput {Enter}
		}
		else if TabCheck29 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText29%
			SendInput {Enter}
		}
	}
	else if RealmCheck29 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck29 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText29%
				SendInput {Enter}
			}
			else if TabCheck29 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText29%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub30:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck30, %ININame% , Quick Speech Realm Checkbox, Checkbox30
	IniRead, TabCheck30, %ININame% , Quick Speech Realm Checkbox, TabCheckbox30
	if RealmCheck30 = 0
	{
		if TabCheck30 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText30%
			SendInput {Enter}
		}
		else if TabCheck30 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText30%
			SendInput {Enter}
		}
	}
	else if RealmCheck30 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck30 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText30%
				SendInput {Enter}
			}
			else if TabCheck30 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText30%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub31:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck31, %ININame% , Quick Speech Realm Checkbox, Checkbox31
	IniRead, TabCheck31, %ININame% , Quick Speech Realm Checkbox, TabCheckbox31
	if RealmCheck31 = 0
	{
		if TabCheck31 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText31%
			SendInput {Enter}
		}
		else if TabCheck31 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText31%
			SendInput {Enter}
		}
	}
	else if RealmCheck31 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck31 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText31%
				SendInput {Enter}
			}
			else if TabCheck31 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText31%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub32: 
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck32, %ININame% , Quick Speech Realm Checkbox, Checkbox32
	IniRead, TabCheck32, %ININame% , Quick Speech Realm Checkbox, TabCheckbox32
	if RealmCheck32 = 0
	{
		if TabCheck32 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText32%
			SendInput {Enter}
		}
		else if TabCheck32 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText32%
			SendInput {Enter}
		}
	}
	else if RealmCheck32 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck32 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText32%
				SendInput {Enter}
			}
			else if TabCheck32 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText32%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub33:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck33, %ININame% , Quick Speech Realm Checkbox, Checkbox33
	IniRead, TabCheck33, %ININame% , Quick Speech Realm Checkbox, TabCheckbox33
	if RealmCheck33 = 0
	{
		if TabCheck33 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText33%
			SendInput {Enter}
		}
		else if TabCheck33 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText33%
			SendInput {Enter}
		}
	}
	else if RealmCheck33 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck33 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText33%
				SendInput {Enter}
			}
			else if TabCheck33 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText33%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub34:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck34, %ININame% , Quick Speech Realm Checkbox, Checkbox34
	IniRead, TabCheck34, %ININame% , Quick Speech Realm Checkbox, TabCheckbox34
	if RealmCheck34 = 0
	{
		if TabCheck34 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText34%
			SendInput {Enter}
		}
		else if TabCheck34 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText34%
			SendInput {Enter}
		}
	}
	else if RealmCheck34 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck34 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText34%
				SendInput {Enter}
			}
			else if TabCheck34 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText34%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub35:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck35, %ININame% , Quick Speech Realm Checkbox, Checkbox35
	IniRead, TabCheck35, %ININame% , Quick Speech Realm Checkbox, TabCheckbox35
	if RealmCheck35 = 0
	{
		if TabCheck35 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText35%
			SendInput {Enter}
		}
		else if TabCheck35 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText35%
			SendInput {Enter}
		}
	}
	else if RealmCheck35 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck35 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText35%
				SendInput {Enter}
			}
			else if TabCheck35 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText35%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub36:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck36, %ININame% , Quick Speech Realm Checkbox, Checkbox36
	IniRead, TabCheck36, %ININame% , Quick Speech Realm Checkbox, TabCheckbox36
	if RealmCheck36 = 0
	{
		if TabCheck36 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText36%
			SendInput {Enter}
		}
		else if TabCheck36 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText36%
			SendInput {Enter}
		}
	}
	else if RealmCheck36 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck36 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText36%
				SendInput {Enter}
			}
			else if TabCheck36 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText36%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub37:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck37, %ININame% , Quick Speech Realm Checkbox, Checkbox37
	IniRead, TabCheck37, %ININame% , Quick Speech Realm Checkbox, TabCheckbox37
	if RealmCheck37 = 0
	{
		if TabCheck37 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText37%
			SendInput {Enter}
		}
		else if TabCheck37 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText37%
			SendInput {Enter}
		}
	}
	else if RealmCheck37 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck37 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText37%
				SendInput {Enter}
			}
			else if TabCheck37 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText37%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub38:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck38, %ININame% , Quick Speech Realm Checkbox, Checkbox38
	IniRead, TabCheck38, %ININame% , Quick Speech Realm Checkbox, TabCheckbox38
	if RealmCheck38 = 0
	{
		if TabCheck38 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText38%
			SendInput {Enter}
		}
		else if TabCheck38 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText38%
			SendInput {Enter}
		}
	}
	else if RealmCheck38 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck38 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText38%
				SendInput {Enter}
			}
			else if TabCheck38 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText38%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub39:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck39, %ININame% , Quick Speech Realm Checkbox, Checkbox39
	IniRead, TabCheck39, %ININame% , Quick Speech Realm Checkbox, TabCheckbox39
	if RealmCheck39 = 0
	{
		if TabCheck39 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText39%
			SendInput {Enter}
		}
		else if TabCheck39 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText39%
			SendInput {Enter}
		}
	}
	else if RealmCheck39 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck39 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText39%
				SendInput {Enter}
			}
			else if TabCheck39 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText39%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub40:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck40, %ININame% , Quick Speech Realm Checkbox, Checkbox40
	IniRead, TabCheck40, %ININame% , Quick Speech Realm Checkbox, TabCheckbox40
	if RealmCheck40 = 0
	{
		if TabCheck40 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText40%
			SendInput {Enter}
		}
		else if TabCheck40 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText40%
			SendInput {Enter}
		}
	}
	else if RealmCheck40 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck40 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText40%
				SendInput {Enter}
			}
			else if TabCheck40 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText40%
				SendInput {Enter}
			}
		}
	}
}
return
KeySub41:
{
	global HotkeyList
	global NumBTKey
	global NumACKey
	GetPosition()
	MinimapX := xpos + (0.85 * width)
	MinimapY := ypos + (0.2 * height)
	MouseGetPos, oldx, oldy
	Click %MinimapX% %MinimapY%
	MouseMove, %oldx%, %oldy%
	BeginTell := HotkeyList[NumBTKey].hk
	ActivateChat := HotkeyList[NumACKey].hk
	IniRead, RealmCheck41, %ININame% , Quick Speech Realm Checkbox, Checkbox41
	IniRead, TabCheck41, %ININame% , Quick Speech Realm Checkbox, TabCheckbox41
	if RealmCheck41 = 0
	{
		if TabCheck41 = 0
		{
			SendInput {%ActivateChat%}{Raw}%QSText41%
			SendInput {Enter}
		}
		else if TabCheck41 = 1
		{
			SendInput {%BeginTell%}{Raw}%QSText41%
			SendInput {Enter}
		}
	}
	else if RealmCheck41 = 1
	{
		ifWinActive, ahk_group rotmg
		{
			if TabCheck41 = 0
			{
				SendInput {%ActivateChat%}{Raw}%QSText41%
				SendInput {Enter}
			}
			else if TabCheck41 = 1
			{
				SendInput {%BeginTell%}{Raw}%QSText41%
				SendInput {Enter}
			}
		}
	}
}
return

;;;;;;;;;;;;;;				RIGHT BUTTON HOTKEY					;;;;;;;;;;;;;;;;;;;;;;
$RButton:: ; Right Button key
{
	global HotkeyList
	global NumAKey
	AbilityKey := HotkeyList[NumAKey].hk
	KeyWait, RButton			; wait for RButton to be released
	ifWinActive, ahk_group rotmg
	{
		WinGetPos, WinX, WinY, WinWidth, WinHeight, ahk_group rotmg
		MouseGetPos, MouseX, MouseY
		; msgbox %WinX%, %WinY%, %WinWidth%, %WinHeight% : %MouseX%, %MouseY%
		if (MouseX < WinWidth && MouseY < WinHeight)
		{
			KeyWait, RButton, D T0.1	; and pressed again within 0.1 seconds
			if (ErrorLevel = 1) ; not pressed again
			{
				IniRead, RClick, %ININame%, Settings, RClick
				; CoordMode, Mouse
				GetPosition()
				MouseGetPos, MX, MY
				BoxX := xpos + (0.75 * width)
				BoxY := ypos + (0.32 * height)
				if (RClick = 1)
				{
					SendInput {%AbilityKey%}
				}
				else if (RClick = 2)
				{
					; msgbox MX = %MX% / %BoxX% MY = %MY% / %BoxY%
					if (MX > BoxX && MY > BoxY)
					{
						Click 2
					}
					else
					{
						Click right
					}
				}
			}
			else
			{
				IniRead, DRClick, %ININame%, Settings, DRClick
				if (DRClick = 1)
				{
					SendInput, {Shift down}{LButton}
					Sleep, 10
					SendInput, {Shift up}
					Click right
				}
			}
		}
		else
		{
			Click right
		}
	}
}
return

;;;;;;;;;;;;;;				INGAME SPECIAL HOTKEYS					;;;;;;;;;;;;;;;;;;;;;;


:c1*:@@@:: ; Tutorial quick key
{
	if Checknexus = 1
	{
		ifWinActive, ahk_group rotmg
		{
			SendInput {Raw}/nexustutorial
			SendInput {Enter}
		}
		else
		{
			SendInput {Raw}@@@
		}
	}
	else
	{
		SendInput {Raw}@@@
	}
}
return
; :c1*:/s:: ; /s ==> /server
; {
	; ifWinActive, ahk_group rotmg
	; {
		; SendInput {Raw}/server
		; SendInput {Enter}
	; }
	; else
	; {
		; SendInput {Raw}/s
		; SendInput {Space}
	; }
; }
; Return
:c1*:/tp:: ; /tp ==> /teleport
{
	if Checktp = 1
	{
		ifWinActive, ahk_group rotmg
		{
			SendInput {Raw}/teleport
			SendInput {Space}
		}
		else
		{
			SendInput {Raw}/tp
			SendInput {Space}
		}
	}
	else
	{
		SendInput {Raw}/tp
		SendInput {Space}
	}
}
Return
:c1*:/tr:: ; /tr ==> /trade
{
	if Checktrade = 1
	{
		ifWinActive, ahk_group rotmg
		{
			SendInput {Raw}/trade
			SendInput {Space}
		}
		else
		{
			SendInput {Raw}/tr
			SendInput {Space}
		}
	}
	else
	{
		SendInput {Raw}/tr
		SendInput {Space}
	}
}
Return
:c1*:/ignr:: ; /ignr ==> /ignore
{
	if Checkignore = 1
	{
		#ifWinActive, ahk_group rotmg
		{
			SendInput, ^{left}{left}{bs 6}/ignore{enter}
		}
	}
	else
	{
		SendInput {Raw}/ignr
	}
}
Return

;;;;;;;;;;;;;;				INGAME SERVER CHANGE HOTKEYS					;;;;;;;;;;;;;;;;;;;;;;

; EU Hotstring
:c1:/euw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUW
	}
	else
	{
		SendInput {Raw}/euw
		SendInput {Space}
	}
}
Return
:c1:/euw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUW2
	}
	else
	{
		SendInput {Raw}/euw2
		SendInput {Space}
	}
}
Return
:c1:/eus:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUS
	}
	else
	{
		SendInput {Raw}/eus
		SendInput {Space}
	}
}
Return
:c1:/eusw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUSW
	}
	else
	{
		SendInput {Raw}/eusw
		SendInput {Space}
	}
}
Return
:c1:/eun:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUN
	}
	else
	{
		SendInput {Raw}/eun
		SendInput {Space}
	}
}
Return
:c1:/eun2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUN2
	}
	else
	{
		SendInput {Raw}/eun2
		SendInput {Space}
	}
}
Return
:c1:/eue:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, EUE
	}
	else
	{
		SendInput {Raw}/eue
		SendInput {Space}
	}
}
Return

:c1:/!euw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUW
	}
	else
	{
		SendInput {Raw}/euw
		SendInput {Space}
	}
}
Return
:c1:/!euw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUW2
	}
	else
	{
		SendInput {Raw}/euw2
		SendInput {Space}
	}
}
Return
:c1:/!eus:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUS
	}
	else
	{
		SendInput {Raw}/eus
		SendInput {Space}
	}
}
Return
:c1:/!eusw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUSW
	}
	else
	{
		SendInput {Raw}/eusw
		SendInput {Space}
	}
}
Return
:c1:/!eun:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUN
	}
	else
	{
		SendInput {Raw}/eun
		SendInput {Space}
	}
}
Return
:c1:/!eun2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUN2
	}
	else
	{
		SendInput {Raw}/eun2
		SendInput {Space}
	}
}
Return
:c1:/!eue:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, EUE
	}
	else
	{
		SendInput {Raw}/eue
		SendInput {Space}
	}
}
Return

; US Hotstring
:c1:/usw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USW
	}
	else
	{
		SendInput {Raw}/usw
		SendInput {Space}
	}
}
Return
:c1:/usw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USW2
	}
	else
	{
		SendInput {Raw}/usw2
		SendInput {Space}
	}
}
Return
:c1:/usw3:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USW3
	}
	else
	{
		SendInput {Raw}/usw3
		SendInput {Space}
	}
}
Return
:c1:/use:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USE
	}
	else
	{
		SendInput {Raw}/use
		SendInput {Space}
	}
}
Return
:c1:/use2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USE2
	}
	else
	{
		SendInput {Raw}/use2
		SendInput {Space}
	}
}
Return
:c1:/use3:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USE3
	}
	else
	{
		SendInput {Raw}/use3
		SendInput {Space}
	}
}
Return
:c1:/uss:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USS
	}
	else
	{
		SendInput {Raw}/uss
		SendInput {Space}
	}
}
Return
:c1:/uss2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USS2
	}
	else
	{
		SendInput {Raw}/uss2
		SendInput {Space}
	}
}
Return
:c1:/uss3:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USS3
	}
	else
	{
		SendInput {Raw}/uss3
		SendInput {Space}
	}
}
Return
:c1:/ussw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USSW
	}
	else
	{
		SendInput {Raw}/ussw
		SendInput {Space}
	}
}
Return
:c1:/usmw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USMW
	}
	else
	{
		SendInput {Raw}/usmw
		SendInput {Space}
	}
}
Return
:c1:/usmw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USMW2
	}
	else
	{
		SendInput {Raw}/usmw2
		SendInput {Space}
	}
}
Return
:c1:/usnw:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, USNW
	}
	else
	{
		SendInput {Raw}/usnw
		SendInput {Space}
	}
}
Return

:c1:/!usw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USW
	}
	else
	{
		SendInput {Raw}/usw
		SendInput {Space}
	}
}
Return
:c1:/!usw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USW2
	}
	else
	{
		SendInput {Raw}/usw2
		SendInput {Space}
	}
}
Return
:c1:/!usw3:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USW3
	}
	else
	{
		SendInput {Raw}/usw3
		SendInput {Space}
	}
}
Return
:c1:/!use:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USE
	}
	else
	{
		SendInput {Raw}/use
		SendInput {Space}
	}
}
Return
:c1:/!use2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USE2
	}
	else
	{
		SendInput {Raw}/use2
		SendInput {Space}
	}
}
Return
:c1:/!use3:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USE3
	}
	else
	{
		SendInput {Raw}/use3
		SendInput {Space}
	}
}
Return
:c1:/!uss:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USS
	}
	else
	{
		SendInput {Raw}/uss
		SendInput {Space}
	}
}
Return
:c1:/!uss2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USS2
	}
	else
	{
		SendInput {Raw}/uss2
		SendInput {Space}
	}
}
Return
:c1:/!uss3:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USS3
	}
	else
	{
		SendInput {Raw}/uss3
		SendInput {Space}
	}
}
Return
:c1:/!ussw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USSW
	}
	else
	{
		SendInput {Raw}/ussw
		SendInput {Space}
	}
}
Return
:c1:/!usmw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USMW
	}
	else
	{
		SendInput {Raw}/usmw
		SendInput {Space}
	}
}
Return
:c1:/!usmw2:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USMW2
	}
	else
	{
		SendInput {Raw}/usmw2
		SendInput {Space}
	}
}
Return
:c1:/!usnw:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, USNW
	}
	else
	{
		SendInput {Raw}/usnw
		SendInput {Space}
	}
}
Return

; Asia/Australia Hotstring
:c1:/ase:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, ASE
	}
	else
	{
		SendInput {Raw}/ase
		SendInput {Space}
	}
}
Return
:c1:/ae:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, AE
	}
	else
	{
		SendInput {Raw}/ae
		SendInput {Space}
	}
}
Return
:c1:/aus:: 
{
	ifWinActive, ahk_group rotmg
	{
		GoSub, AUS
	}
	else
	{
		SendInput {Raw}/aus
		SendInput {Space}
	}
}
Return

:c1:/!ase:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, ASE
	}
	else
	{
		SendInput {Raw}/ase
		SendInput {Space}
	}
}
Return
:c1:/!ae:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, AE
	}
	else
	{
		SendInput {Raw}/ae
		SendInput {Space}
	}
}
Return
:c1:/!aus:: 
{
	ifWinActive, ahk_group rotmg
	{
		FAST = 1
		GoSub, AUS
	}
	else
	{
		SendInput {Raw}/aus
		SendInput {Space}
	}
}
Return

;;;;;;;;;;;;;;				BINDING FUNCTIONS					;;;;;;;;;;;;;;;;;;;;;;
	
; Something changed - rebuild
OptionChanged:
OptionChanged("optionsub")
return
SaveSettings3:
{
	global HotkeyList
	Gui, Settings:Submit, NoHide
	; Disable Hotkeys
	DisableHotkeys()
	EnableHotkeys()
	SaveSettings2("save3")
	Reload
}
return
OptionChanged(thatvar){
	global HotkeyList
	Gui, HotkeyGUI:Submit, NoHide
	; Disable Hotkeys
	DisableHotkeys()
	EnableHotkeys()
	SaveSettings2("option")
	;msgbox %thatvar%
}
; Detects a pressed key combination
Bind:
Bind(substr(A_GuiControl,5))
return
Bind(ctrlnum){
	global HKModifierState
	global BindMode
	global EXTRA_KEY_LIST
	global HKControlType
	global HKSecondaryInput
	global HKLastHotkey
	global HotkeyList
	global RealmNumKeys
	global DeleteBindingKey
	; init vars
	HKControlType := 0
	HKModifierState := {ctrl: 0, alt: 0, shift: 0, win: 0}
	; Disable existing hotkeys
	DisableHotkeys()
	; Enable Joystick detection hotkeys
	JoystickDetection(1)
	; Start Bind Mode - this starts detection for mouse buttons and modifier keys
	BindMode := 1
	; Show the prompt
	prompt := "Please press the desired key combination.`n`n"
	prompt .= "Supports most keyboard keys and all mouse buttons. Also Ctrl, Alt, Shift, Win as modifiers or individual keys.`n"
	prompt .= "Joystick buttons are also supported, but currently not with modifiers.`n"
	prompt .= "`nHit Escape to cancel."
	prompt .= "`nHold Escape to clear a binding."
	Gui, HotkeyGUI2:Add, text, center, %prompt%
	Gui, HotkeyGUI2:-Border +AlwaysOnTop
	Gui, HotkeyGUI2:Show, NA 
	outhk := ""
	Input, detectedkey, L1 M, %EXTRA_KEY_LIST%
	if (substr(ErrorLevel,1,7) == "EndKey:"){
		; A "Special" (Non-printable) key was pressed
		tmp := substr(ErrorLevel,8)
		detectedkey := tmp
		if (tmp = DeleteBindingKey){
			; Detection ended by Escape
			if (HKControlType > 0){
				; The Escape key was sent because a special button was used
				detectedkey := HKSecondaryInput
			} else {
				detectedkey := ""
				; Start listening to key up event for Escape, to see if it was held
				HKLastHotkey := ctrlnum
				hotkey, %DeleteBindingKey% up, EscapeReleased, ON
				SetTimer, DeleteHotkey, 800
			}
		}
	}
	else
	{
		if (detectedkey = DeleteBindingKey){
			; Detection ended by Escape
			if (HKControlType > 0){
				; The Escape key was sent because a special button was used
				detectedkey := HKSecondaryInput
			} else {
				detectedkey := ""
				; Start listening to key up event for Escape, to see if it was held
				HKLastHotkey := ctrlnum
				hotkey, %DeleteBindingKey% up, EscapeReleased, ON
				SetTimer, DeleteHotkey, 800
			}
		}
	}
	; Stop listening to mouse, keyboard etc
	BindMode := 0
	JoystickDetection(0)
	; Hide prompt
	Gui, HotkeyGUI2:Submit
	; Process results
	
	modct := CurrentModifierCount()
	StringReplace, detectedkey, detectedkey, ~, , All
	StringReplace, detectedkey, detectedkey, *, , All
	StringReplace, detectedkey, detectedkey, $, , All
	if (detectedkey && modct && HKControlType == 3){
		msgbox ,,Error, Modifiers (Ctrl, Alt, Shift, Win) are currently not supported with Joystick buttons.
		detectedkey := ""
	}
	if (detectedkey){
		; Update the hotkey object
		outhk := BuildHotkeyString(detectedkey,HKControlType)
		tmp := {hk: outhk, type: HKControlType, status: 0}
		clash := 0
		Loop % HotkeyList.MaxIndex(){
			if (A_Index == ctrlnum){
				continue
			}
			if (StripPrefix(HotkeyList[A_Index].hk) == StripPrefix(tmp.hk)){ 
				clash := 1
			}
		}
		if (clash){
			msgbox You cannot bind the same hotkey to two different actions. Aborting...
		} else {
			HotkeyList[ctrlnum] := tmp
		}
		; Rebuild rest of hotkey object, save settings etc
		OptionChanged("bind")
		; Update the GUI control
		UpdateHotkeyControls()
	} else {
		; Escape was pressed - restore original hotkey, if any
		EnableHotkeys()
	}
	return
}

DeleteHotkey:
SetTimer, DeleteHotkey, Off
DeleteHotKey(HKLastHotkey)
return

DeleteHotkey(hk){
	global HotkeyList
	global DefaultHKObject
	soundbeep
	DisableHotkeys()
	HotkeyList[hk] := DefaultHKObject
	OptionChanged("del")
	UpdateHotkeyControls()
	return
}

EscapeReleased:
global DeleteBindingKey
hotkey, %DeleteBindingKey% up, EscapeReleased, OFF
SetTimer, DeleteHotkey, Off
return
; Enables User-Defined Hotkeys
EnableHotkeys(){
	global HotkeyList
	global NumHotkeys
	global RealmNumKeys
	global NumIKey
	global NumAKey
	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hk := HotkeyList[A_Index].hk
		if (hk != "" && status == 0){
			if A_Index = %NumIKey%
			{
				hotkey, $!%hk%, InteractButton, ON
				HotkeyList[A_Index].status := 1
			}
			; else if A_Index = %NumAKey%
			; {
				; Hotkey, $%hk%, NinjaWay, ON
				; HotkeyList[A_Index].status := 1
			; }
			else if A_Index <= %NumHotkeys%
			{
				prefix := BuildPrefix(HotkeyList[A_Index])
				hotkey, %prefix%%hk%, KeySub%A_Index%, ON
				HotkeyList[A_Index].status := 1
			}
			else if A_Index <= %RealmNumKeys%
			{
				NewIndex := A_Index - NumHotkeys
				prefix := BuildPrefix(HotkeyList[A_Index])
				hotkey, %prefix%%hk%, OtherKeySub%NewIndex%, ON
				HotkeyList[A_Index].status := 1
			}
		}
	}
}
return
; Disables User-Defined Hotkeys
DisableHotkeys(){
	global HotkeyList
	global NumHotkeys
	global RealmNumKeys
	global NumIKey
	global NumAKey
	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hk := HotkeyList[A_Index].hk
		if (hk != "" && status == 1){
			if A_Index = %NumIKey%
			{
				hotkey, ~$%hk%, InteractButton, OFF
				HotkeyList[A_Index].status := 0
			}
			; else if A_Index = %NumAKey%
			; {
				; Hotkey, $%hk%, NinjaWay, OFF
				; HotkeyList[A_Index].status := 0
			; }
			else if A_Index <= %NumHotkeys%
			{
				prefix := BuildPrefix(HotkeyList[A_Index])
				hotkey, %prefix%%hk%, KeySub%A_Index%, OFF
				HotkeyList[A_Index].status := 0
			}
			else if A_Index <= %RealmNumKeys%
			{
				NewIndex := A_Index - NumHotkeys
				prefix := BuildPrefix(HotkeyList[A_Index])
				hotkey, %prefix%%hk%, OtherKeySub%NewIndex%, OFF
				HotkeyList[A_Index].status := 0
			}
		}
	}
}
return
; Builds the prefix for a given hotkey object
BuildPrefix(hk){
	prefix := "~"
	return prefix
}
; Removes ~ * etc prefixes (But NOT modifiers!) from a hotkey object for comparison
StripPrefix(hk){
	Loop {
		chr := substr(hk,1,1)
		if (chr == "~" || chr == "*" || chr == "$"){
			hk := substr(hk,2)
		} else {
			break
		}
	}
	return hk
}
; Write settings to the INI
SaveSettings2(thatvar){
	global ININame
	global HotkeyList
	global RealNumHotkeys
	global NumHotkeys
	ThisNumber := NumHotkeys
	Loop % HotkeyList.MaxIndex(){
		callouttext := QSText%A_Index%
		checkvar := RealmCheck%A_Index%
		checktabenter := TabCheck%A_Index%
		hk := HotkeyList[A_Index].hk
		type := HotkeyList[A_Index].type
		iniwrite, %hk%, %ININame%, Hotkeys, hk_%A_Index%_hk
		if type !=
			iniwrite, %type%, %ININame%, Hotkeys, hk_%A_Index%_type
		if A_Index <= %ThisNumber% 
		{
			if callouttext != 
				iniwrite, %callouttext%, %ININame%, Quick Speech Text, Text%A_Index%
			else
				iniwrite, None, %ININame%, Quick Speech Text, Text%A_Index%
			if checkvar != 
				iniwrite, %checkvar%, %ININame%, Quick Speech Realm Checkbox, Checkbox%A_Index%
			if checktabenter !=
				iniwrite, %checktabenter%, %ININame%, Quick Speech Realm Checkbox, TabCheckbox%A_Index%
		}
	}
	GuiControlGet, Checktrade, , Checktrade
	GuiControlGet, Checktp, , Checktp
	GuiControlGet, Checknexus, , Checknexus
	GuiControlGet, Checkignore, , Checkignore
	GuiControlGet, Checkrandom, , Checkrandom
	if Checkignore != 
		iniwrite, %Checkignore%, %ININame%, Quick Speech Realm Checkbox, Checkboxignore
	if Checktrade != 
		iniwrite, %Checktrade%, %ININame%, Quick Speech Realm Checkbox, Checkboxtrade
	if Checktp != 
		iniwrite, %Checktp%, %ININame%, Quick Speech Realm Checkbox, Checkboxtp
	if Checknexus != 
		iniwrite, %Checknexus%, %ININame%, Quick Speech Realm Checkbox, Checkboxnexus
	if Checkrandom != 
		iniwrite, %Checkrandom%, %ININame%, Quick Speech Realm Checkbox, Checkboxrandom
}
return

; Update the GUI controls with the hotkey names
UpdateHotkeyControls(){
	global HotkeyList
	global NumHotkeys
	global RealmNumKeys
	Loop % HotkeyList.MaxIndex(){
		if (HotkeyList[A_Index].hk != ""){
			tmp := BuildHotkeyName(HotkeyList[A_Index].hk,HotkeyList[A_Index].type)
			if A_Index <= %NumHotkeys%
			{
				GuiControl,HotkeyGUI:, HotkeyName%A_Index%, %tmp%
			}
			else if A_Index <= %RealmNumKeys%
			{
				GuiControl,Settings:, HotkeyName%A_Index%, %tmp%
			}
			else
			{
				GuiControl,Settings:, HotkeyName%A_Index%, %tmp%
				NewIndex := A_Index - NumHotkeys
				GoSub, OtherKeySub%NewIndex%
			}
		} 
		else 
		{
			if A_Index <= %NumHotkeys%
			{
				GuiControl,HotkeyGUI:, HotkeyName%A_Index%, None
			}
			else if A_Index <= %RealmNumKeys%
			{
				GuiControl,Settings:, HotkeyName%A_Index%, None
			}
			else
			{
				GuiControl,Settings:, HotkeyName%A_Index%, None
				NewIndex := A_Index - NumHotkeys
				GoSub, OtherKeySub%NewIndex%
			}
		}
	}
}
return
; Builds an AHK String (eg "^c" for CTRL + C) from the last detected hotkey
BuildHotkeyString(str, type := 0){
	global HKModifierState
	outhk := ""
	modct := CurrentModifierCount()
	if (type == 1){
		; Solitary modifier key used (eg Left / Right Alt)
		outhk := str
	} else {
		if (modct){
			; Modifiers used in combination with something else - List modifiers in a specific order
			modifiers := ["CTRL","ALT","SHIFT","WIN"]
			Loop, 4 {
				key := modifiers[A_Index]
				value := HKModifierState[modifiers[A_Index]]
				if (value){
					if (key == "CTRL"){
						outhk .= "^"
					} else if (key == "ALT"){
						outhk .= "!"
					} else if (key == "SHIFT"){
						outhk .= "+"
					} else if (key == "WIN"){
						outhk .= "#"
					}
				}
			}
		} ; Modifiers etc processed, complete the string
		outhk .= str
	}
	return outhk
}
; Builds a Human-Readable form of a Hotkey string (eg "^C" -> "CTRL + C")
BuildHotkeyName(hk,ctrltype){
global DeleteBindingKey
	outstr := ""
	modctr := 0
	stringupper, hk, hk
	Loop % strlen(hk) {
		chr := substr(hk,1,1)
		mod := 0
		if (chr == "^"){
			; Ctrl
			mod := "CTRL"
			modctr++
		} else if (chr == "!"){
			; Alt
			mod := "ALT"
			modctr++
		} else if (chr == "+"){
			; Shift
			mod := "SHIFT"
			modctr++
		} else if (chr == "#"){
			; Win
			mod := "WIN"
			modctr++
		} else {
			break
		}
		if (mod){
			if (modctr > 1){
				outstr .= " + "
			}
			outstr .= mod
			; shift character out
			hk := substr(hk,2)
			}
	}
	if (modctr){
		outstr .= " + "
	}
	if (ctrltype == 1){
		; Solitary Modifiers
		pfx := substr(hk,1,1)
		if (pfx == "L"){
			outstr .= "LEFT "
		} else {
			outstr .= "RIGHT "
		}
		outstr .= substr(hk,2)
	} else if (ctrltype == 2){
		; Mouse Buttons
		if (hk == "LBUTTON") {
			outstr .= "LEFT MOUSE"
		} else if (hk == "RBUTTON") {
			outstr .= "RIGHT MOUSE"
		} else if (hk == "MBUTTON") {
			outstr .= "MIDDLE MOUSE"
		} else if (hk == "XBUTTON1") {
			outstr .= "MOUSE THUMB 1"
		} else if (hk == "XBUTTON2") {
			outstr .= "MOUSE THUMB 2"
		} else if (hk == "WHEELUP") {
			outstr .= "MOUSE WHEEL U"
		} else if (hk == "WHEELDOWN") {
			outstr .= "MOUSE WHEEL D"
		} else if (hk == "WHEELLEFT") {
			outstr .= "MOUSE WHEEL L"
		} else if (hk == "WHEELRIGHT") {
			outstr .= "MOUSE WHEEL R"
		} 
	} else if (ctrltype == 3){
		; Joystick Buttons
		pos := instr(hk,"JOY")
		id := substr(hk,1,pos-1)
		button := substr(hk,5)
		outstr .= "JOYSTICK " id " BTN " button
	} else {
		; Keyboard Keys
		tmp := instr(hk,"NUMPAD")
		if (tmp){
			outstr .= "NUMPAD " substr(hk,7)
		} else {
			; Replace underscores with spaces (In case of key name like MEDIA_PLAY_PAUSE)
			;StringReplace, hk, hk, _ , %A_SPACE%, All
			outstr .= hk
		}
	}
	return outstr
}
; Detects Modifiers and Mouse Buttons in BindMode
#If BindMode
; Detect key down of modifier keys
*lctrl::
*rctrl::
*lalt::
*ralt::
*lshift::
*rshift::
*lwin::
*rwin::
mod := substr(A_ThisHotkey,2)
SetModifier(mod,1)
return
; Detect key up of modifier keys
*lctrl up::
*rctrl up::
*lalt up::
*ralt up::
*lshift up::
*rshift up::
*lwin up::
*rwin up::
; Strip * from beginning, " up" from end etc
mod := substr(substr(A_ThisHotkey,2),1,strlen(A_ThisHotkey) -4)
if (CurrentModifierCount() == 1){
	; If CurrentModifierCount is 1 when an up is received, then that is a Solitary Modifier
	; It cannot be a modifier + normal key, as this code would have quit on keydown of normal key
	HKControlType := 1
	HKSecondaryInput := mod
	; Send Escape - This will cause the Input command to quit with an EndKey of Escape
	; But we stored the modifier key, so we will know it was not really escape
	Send {%DeleteBindingKey%}
}
SetModifier(mod,0)
return
; Detect Mouse buttons
global DeleteBindingKey
lbutton::
rbutton::
mbutton::
xbutton1::
xbutton2::
wheelup::
wheeldown::
wheelleft::
wheelright::
HKControlType := 2
HKSecondaryInput := A_ThisHotkey
Send {%DeleteBindingKey%}
return
#If
; Adds / removes hotkeys to detect Joystick Buttons in BindMode
global DeleteBindingKey
JoystickDetection(mode := 1){
	if (mode){
		mode := "ON"
	} else {
		mode := "OFF"
	}
	Loop , 16 {
		stickid := A_Index
		Loop, 32 {
		buttonid := A_Index
		hotkey, %stickid%Joy%buttonid%, JoystickPressed, %mode%
		}
	}
}
; A Joystick button was pressed while in Binding mode
JoystickPressed:
HKControlType := 3
HKSecondaryInput := A_ThisHotkey
Send {%DeleteBindingKey%}
return
; Sets the state of the HKModifierState object to reflect the state of the modifier keys
SetModifier(hk,state){
	global HKModifierState
	if (hk == "lctrl" || hk == "rctrl"){
		HKModifierState.ctrl := state
	} else if (hk == "lalt" || hk == "ralt"){
		HKModifierState.alt := state
	} else if (hk == "lshift" || hk == "rshift"){
		HKModifierState.shift := state
	} else if (hk == "lwin" || hk == "rwin"){
		HKModifierState.win := state
	}
	return
}
; Counts how many modifier keys are currently held
CurrentModifierCount(){
	global HKModifierState
	return HKModifierState.ctrl + HKModifierState.alt + HKModifierState.shift + HKModifierState.win
}
; Takes the start of the file name (before .ini or .exe and replaces it with .ini)
BuildIniName(){
tmp := A_Scriptname
Stringsplit, tmp, tmp,.
ini_nameini_name := ""
last := ""
Loop, % tmp0
{
	; build the string up to the last period (.)
	if (last != ""){
		if (ini_name != ""){
			ini_name := ini_name "."
		}
		ini_name := ini_name last
	}
	last := tmp%A_Index%
}
return ini_name ".ini"
}

;;;;;;;;;;;;;;				F5 OVERRIDE					;;;;;;;;;;;;;;;;;;;;;;

Override:
{
	MsgBox Go check your Settings to Toggle this behavior (Check/Uncheck F5 as Macro)
}
return

#ifWinActive, ahk_group rotmg2
{
	F5:: ; F5 Override
	{
		global HotkeyList
		global NumBTKey
		global NumACKey
		GetPosition()
		MinimapX := xpos + (0.85 * width)
		MinimapY := ypos + (0.2 * height)
		MouseGetPos, oldx, oldy
		Click %MinimapX% %MinimapY%
		MouseMove, %oldx%, %oldy%
		BeginTell := HotkeyList[NumBTKey].hk
		ActivateChat := HotkeyList[NumACKey].hk
		IniRead, TabCheck2, %ININame% , Quick Speech Realm Checkbox, TabCheckbox2
		ThisText := QSText2
		if TabCheck2 = 0
		{
			SendInput {%ActivateChat%}{Raw}%ThisText%
			SendInput {Enter}
		}
		else if TabCheck2 = 1
		{
			SendInput {TAB}{Raw}%ThisText%
			SendInput {Enter}
		}
	}
	return
}
return
#ifWinActive
;ifWinActive
return

;;;;;;;;;;;;;;				CREDITS TO ATREDES FOR MAKING THE FIRST VERSION !					;;;;;;;;;;;;;;;;;;;;;;

Version:
{
MsgBox Wawawa's Version (Thanks Atredes for making the first version!)
}
return