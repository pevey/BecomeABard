Scriptname _LP_BardConfigQuestScript extends SKI_ConfigBase

; Let me take this opportunity to say that the whole SkyUI team just absolutely rocks!!!

; PROPERTIES -------------------------------------------------------------------------------------

Actor Property PlayerREF Auto
Armor Property _LP_BardLuteArmor Auto
Book Property _LP_BardSongbookCustom Auto
Faction Property _LP_BardDoNotPlayFaction Auto
FormList Property _LP_BardTavernCounts Auto
FormList Property _LP_BardTavernLocations Auto
FormList Property _LP_BardKnownSongbooks Auto
FormList Property _LP_BardSongbooksRegional Auto
FormList Property _LP_BardSongbooksUnique Auto
FormList Property _LP_BardSongbooks Auto
FormList Property _LP_BardSongbookSpells Auto
FormList Property _LP_BardSongbookSpellsRegional Auto
FormList Property _LP_BardSongbookSpellsUnique Auto
FormList Property _LP_BardCustomSongbookInstrumentsA Auto
FormList Property _LP_BardCustomSongbookInstrumentsB Auto
FormList Property _LP_BardCustomSongbookLengths Auto
FormList Property _LP_BardCustomSongbookNames Auto
MiscObject Property _LP_BardCustomSongbookTitle Auto
GlobalVariable Property _LP_BardSpeech Auto
GlobalVariable Property _LP_BardPreferredInstrument Auto
GlobalVariable Property _LP_BardCustomFit Auto
GlobalVariable Property _LP_BardCourting Auto
GlobalVariable Property _LP_BardDancing Auto
GlobalVariable Property _LP_BardFactionAggression Auto
GlobalVariable Property _LP_BardKeepJournal Auto
GlobalVariable Property _LP_BardSongbookCheat Auto
GlobalVariable Property _LP_BardConsolidateSongbook Auto
GlobalVariable Property _LP_BardSkill Auto
Quest Property _LP_BardJournalQuest Auto
ReferenceAlias Property Journal Auto
ReferenceAlias Property Follower00 Auto
ReferenceAlias Property Follower01 Auto
ReferenceAlias Property Follower02 Auto
ReferenceAlias Property Follower03 Auto
ReferenceAlias Property Follower04 Auto
Spell Property _LP_BardSongbookAbility Auto
Spell Property _LP_BardSongbookCustomAbility Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------

String[] Pages
String[] Instruments
Int StoreFit
Int StoreJournal
Int StoreConsolidate
Int SpeechToggle
Int CourtingToggle
Int DancingToggle
Int FactionAggressionToggle
Int PreferredInstrumentText
Int JournalToggle
Int CustomFitText
Int ConsolidateToggle
Int SongbookCheatToggle
Int CustomSongbookToggle
Int[] TavernCounts
Int[] SongbookRegionalToggles
Int[] SongbookUniqueToggles
Int[] CustomLengthSliders
Int[] CustomInstrumentsA
Int[] CustomInstrumentsB
Int CSPageSwitchTitle
Int CSPageSwitchNames
Int CSPageSwitchLengths
Int CSPageSwitchInstruments
Int CSPageCloseTitle
Int[] CSPageCloseNames
Int CSRenameIndex
String MyPage
String CSPage
String CSOptionPage
Int[] FollowerToggles
Actor[] Followers

; INITIALIZATION ----------------------------------------------------------------------------------

Event OnConfigInit()
	Pages = new String[5]
	Pages[0] = "Options"
	Pages[1] = "Songbooks"
	Pages[2] = "Custom Songbook"
	Pages[3] = "Performance Log"
	Pages[4] = "Followers"
	Instruments = new String[5]
	Instruments[0] = "None"
	Instruments[1] = "Drum"
	Instruments[2] = "Flute"
	Instruments[3] = "Lute"
	Instruments[4] = "Voice"
	TavernCounts = new Int[30]
	SongbookRegionalToggles = new Int[20]
	SongbookUniqueToggles = new Int[30]
	CustomLengthSliders = new Int[9]
	CustomInstrumentsA = new Int[9]
	CustomInstrumentsB = new Int[9]
	CSPageCloseNames = new Int[9]	
	FollowerToggles = new Int[5]
	Followers = new Actor[5]
EndEvent

; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigOpen()
	StoreFit = _LP_BardCustomFit.GetValue() As Int
	StoreJournal = _LP_BardKeepJournal.GetValue() As Int
	StoreConsolidate = _LP_BardConsolidateSongbook.GetValue() As Int

	Followers[0] = Follower00.GetActorRef()
	Followers[1] = Follower01.GetActorRef()
	Followers[2] = Follower02.GetActorRef()
	Followers[3] = Follower03.GetActorRef()
	Followers[4] = Follower04.GetActorRef()

EndEvent

Event OnConfigClose()

	If StoreFit > _LP_BardCustomFit.GetValue() As Int
		Bool Equip = False
		If PlayerREF.IsEquipped(_LP_BardLuteArmor)
			PlayerREF.UnEquipItem(_LP_BardLuteArmor, 0, 1)
			Equip = True
		EndIf
		ArmorAddon _LP_BardLuteArmorAA = _LP_BardLuteArmor.GetNthArmorAddon(0)
		_LP_BardLuteArmorAA.SetModelPath("LP\\instruments\\luteAA.nif", false, false) ; male
		_LP_BardLuteArmorAA.SetModelPath("LP\\instruments\\luteAA.nif", false, true) ; female
		If Equip
			PlayerREF.EquipItem(_LP_BardLuteArmor, 0, 1)
		EndIf
	ElseIf _LP_BardCustomFit.GetValue() As Int > StoreFit
		Bool Equip = False
		If PlayerREF.IsEquipped(_LP_BardLuteArmor)
			PlayerREF.UnEquipItem(_LP_BardLuteArmor, 0, 1)
			Equip = True
		EndIf
		ArmorAddon _LP_BardLuteArmorAA = _LP_BardLuteArmor.GetNthArmorAddon(0)
		_LP_BardLuteArmorAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, false) ; male
		_LP_BardLuteArmorAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, true) ; female
		If Equip
			PlayerREF.EquipItem(_LP_BardLuteArmor, 0, 1)
		EndIf
	EndIf

	If StoreJournal > _LP_BardKeepJournal.GetValue() As Int
		If Journal.GetReference()
			PlayerREF.RemoveItem(Journal.GetReference(), 1, 1)
			Utility.Wait(0.5)
			_LP_BardJournalQuest.Stop()
		EndIf
	ElseIf _LP_BardKeepJournal.GetValue() As Int > StoreJournal
		_LP_BardJournalQuest.Start()
	EndIf

	If StoreConsolidate > _LP_BardConsolidateSongbook.GetValue() As Int
		ExpandSongbook()
	ElseIf _LP_BardConsolidateSongbook.GetValue() As Int > StoreConsolidate
		ConsolidateSongbook()
	EndIf

EndEvent

Event OnTextInputOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	String CurrentName = ""
	If CSRenameIndex > -1
		CurrentName = (_LP_BardCustomSongbookNames.GetAt(CSRenameIndex) As MiscObject).GetName()
	Else
		CurrentName = _LP_BardCustomSongbookTitle.GetName()
	EndIf
	UILIB_1.TextInputMenu_SetData("Rename " + CurrentName + " to...")
EndEvent

Event OnTextInputClose(String asEventName, String asText, Float afCancelled, Form akSender)
	UILIB_1.TextInputMenu_Release(Self)
	If !(afCancelled as Bool) ; The input was not cancelled
		If CSRenameIndex > -1
			_LP_BardCustomSongbookNames.GetAt(CSRenameIndex).SetName(asText)
		Else
			_LP_BardCustomSongbookTitle.SetName(asText)
		EndIf		
	EndIf
EndEvent

Event OnPageReset(String Page)
	MyPage = Page

	; Load custom logo in DDS format
	If (Page == "")
		; Image size 256x256
		; X offset = 376 - (height / 2) = 258
		; Y offset = 223 - (width / 2) = 95
		LoadCustomContent("skyui/res/mcm_logo.dds", 258, 95)
		Return
	Else
		UnloadCustomContent()
	EndIf

	If (Page == "Options")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Main Options")
		PreferredInstrumentText = AddTextOption("Preferred Instrument", Instruments[_LP_BardPreferredInstrument.GetValue() As Int])
		CourtingToggle = AddToggleOption("Courting", _LP_BardCourting.GetValue() As Int)
		DancingToggle = AddToggleOption("NPC Dancing", _LP_BardDancing.GetValue() As Int)
		FactionAggressionToggle = AddToggleOption("Factions Respond to Songs", _LP_BardFactionAggression.GetValue() As Int)
		SpeechToggle = AddToggleOption("Music Increases Speechcraft", _LP_BardSpeech.GetValue() As Int)
		JournalToggle = AddToggleOption("Keep a Journal in Inventory", _LP_BardKeepJournal.GetValue() As Int)
		If _LP_BardCustomFit.GetValue() As Int == 0
			CustomFitText = AddTextOption("Wanderer's Lute Custom Fit", "Loose")
		Else
			CustomFitText = AddTextOption("Wanderer's Lute Custom Fit", "Snug")
		EndIf
		AddEmptyOption()
		AddHeaderOption("Songbook Options")
		If Game.GetModByName("UIExtensions.esp") != 255
			ConsolidateToggle = AddToggleOption("Consolidate Songbooks", _LP_BardConsolidateSongbook.GetValue() As Int)
		Else
			ConsolidateToggle = AddToggleOption("Consolidate Songbooks", 0, OPTION_FLAG_DISABLED)
		EndIf
		SongbookCheatToggle = AddToggleOption("Enable Songbook Cheat Menu", _LP_BardSongbookCheat.GetValue() As Int)
		SetCursorPosition(1)
		AddTextOption("Mod Version No.", "6.1.1", OPTION_FLAG_DISABLED)															 ; CHANGE THIS WITH EACH RELEASE
		AddTextOption("Compatible Plugins Detected:", "", OPTION_FLAG_DISABLED)
		If Game.GetModByName("Dragonborn.esm") != 255
			AddToggleOption("Dragonborn", 1, OPTION_FLAG_DISABLED)
		EndIf
		If Game.GetModByName("WindhelmSSE.esp") != 255
			AddToggleOption("Capital Windhelm Expansion", 1, OPTION_FLAG_DISABLED)
		EndIf
		If Game.GetModByName("LPMerchants.esp") != 255
			AddToggleOption("Become a Merchant", 1, OPTION_FLAG_DISABLED)
		EndIf
		If Game.GetModByName("Chesko_Frostfall.esp") != 255
			AddToggleOption("Frostfall", 1, OPTION_FLAG_DISABLED)
		EndIf

	ElseIf (Page == "Songbooks")
		If _LP_BardSongbookCheat.GetValue() As Int == 0
			AddTextOption("Disabled on Options Page", "", OPTION_FLAG_DISABLED) 
		Else
			SetCursorFillMode(TOP_TO_BOTTOM)
			AddHeaderOption("Regional Songbooks")
			Int NumBooks = _LP_BardSongbooksRegional.GetSize()
			Int i = 0
			While i < NumBooks
				SongbookRegionalToggles[i] = AddToggleOption((_LP_BardSongbooksRegional.GetAt(i) As _LP_BardSongbookScript).Title, (PlayerREF.HasSpell(_LP_BardSongbookSpellsRegional.GetAt(i) As Spell) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbooksRegional.GetAt(i))) As Int)
				i += 1
			EndWhile
			SetCursorPosition(1)
			AddHeaderOption("Unique Songbooks")
			NumBooks = _LP_BardSongbooksUnique.GetSize()
			i = 0
			While i < NumBooks
				SongbookUniqueToggles[i] = AddToggleOption((_LP_BardSongbooksUnique.GetAt(i) As _LP_BardSongbookScript).Title, (PlayerREF.HasSpell(_LP_BardSongbookSpellsUnique.GetAt(i) As Spell) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbooksUnique.GetAt(i))) As Int)
				i += 1
			EndWhile
		EndIf
		
	ElseIf (Page == "Custom Songbook")
	
		If (CSPage == "")
			CSOptionPage = ""
			SetTitleText("Custom Songbook")
			SetCursorFillMode(TOP_TO_BOTTOM)
			AddHeaderOption("Custom Songbook")
			Int CustomSongbook
			If PlayerREF.HasSpell(_LP_BardSongbookCustomAbility) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbookCustom)
				CustomSongbook = 1
			EndIf
			CustomSongbookToggle = AddToggleOption("Enable", CustomSongbook)
			CSPageSwitchTitle = AddTextOption("Set Songbook Title", "")
			CSPageSwitchNames = AddTextOption("Set Song Names", "")
			CSPageSwitchLengths = AddTextOption("Set Song Lengths", "")
			CSPageSwitchInstruments = AddTextOption("Set Song Instruments", "")
			
		ElseIf (CSPage == "Custom Songbook Title")
			CSOptionPage = "Custom Songbook Title"
			CSPage = ""
			SetTitleText("Rename Custom Songbook")
			SetCursorFillMode(TOP_TO_BOTTOM)
			CSPageCloseTitle = AddTextOption(_LP_BardCustomSongbookTitle.GetName(), "Rename")

		ElseIf (CSPage == "Custom Song Names")
			CSOptionPage = "Custom Song Names"
			CSPage = ""
			SetTitleText("Rename Custom Songs")
			SetCursorFillMode(TOP_TO_BOTTOM)
			AddHeaderOption("Song Names")
			Int i = 0
			While i < 9
				CSPageCloseNames[i] = AddTextOption((_LP_BardCustomSongbookNames.GetAt(i) As MiscObject).GetName(), "Rename")
				i += 1
			EndWhile
			SetCursorPosition(1)
			AddHeaderOption("File Names")
			i = 0
			While i < 9
				AddTextOption("Custom0" +( i + 1) + ".xwm", "", OPTION_FLAG_DISABLED)
				i += 1
			EndWhile
			
		ElseIf (CSPage == "Custom Song Lengths")
			CSOptionPage = "Custom Song Lengths"
			CSPage = ""
			SetTitleText("Custom Song Lenths")
			SetCursorFillMode(TOP_TO_BOTTOM)
			AddHeaderOption("Length in Seconds")
			Int i = 0
			While i < 9
				CustomLengthSliders[i] = AddSliderOption("Custom0" + (i + 1) +".xwm", (_LP_BardCustomSongbookLengths.GetAt(i) As GlobalVariable).GetValue() As Int, "{0} seconds")
				i += 1
			EndWhile

		ElseIf (CSPage == "Custom Song Instruments")
			CSOptionPage = "Custom Song Instruments"
			CSPage = ""
			SetTitleText("Custom Song Instruments")
			SetCursorFillMode(TOP_TO_BOTTOM)
			AddHeaderOption("Primary Instrument")
			Int i = 0
			While i < 9
				CustomInstrumentsA[i] = AddTextOption("Custom0" +( i + 1) +".xwm Instrument A", Instruments[(_LP_BardCustomSongbookInstrumentsA.GetAt(i) As GlobalVariable).GetValue() As Int])
				i += 1
			EndWhile
			SetCursorPosition(1)
			AddHeaderOption("Secondary Instrument")
			 i = 0
			While i < 9
				CustomInstrumentsB[i] = AddTextOption("Custom0" +( i + 1) +".xwm Instrument B", Instruments[(_LP_BardCustomSongbookInstrumentsB.GetAt(i) As GlobalVariable).GetValue() As Int])
				i += 1
			EndWhile
		EndIf
		
	ElseIf (Page == "Performance Log")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Skill Level")
		AddTextOption("Bard Skill", _LP_BardSkill.GetValue() As Int)
		AddHeaderOption("Tavern Counts")
		Int i = 0
		Int j = 0
		While i < _LP_BardTavernLocations.GetSize()  && j < 9
			TavernCounts[i] = AddTextOption(_LP_BardTavernLocations.GetAt(i).GetName(), (_LP_BardTavernCounts.GetAt(i) As GlobalVariable).GetValue() As Int)
			j += 1
			i += 1
		EndWhile
		SetCursorPosition(1)
		While i < _LP_BardTavernLocations.GetSize()
			TavernCounts[i] = AddTextOption(_LP_BardTavernLocations.GetAt(i).GetName(), (_LP_BardTavernCounts.GetAt(i) As GlobalVariable).GetValue() As Int)
			i += 1
		EndWhile
		
	ElseIf (Page == "Followers")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Bard Followers")	
		Int i = 0
		While i < 5
			If Followers[i]
				FollowerToggles[i] = AddToggleOption(Followers[i].GetActorBase().GetName(), !Followers[i].IsInFaction(_LP_BardDoNotPlayFaction))
			EndIf
			i += 1
		EndWhile
		SetCursorPosition(1)
		AddTextOption("The follower list is refreshed each time", "", OPTION_FLAG_DISABLED) 
		AddTextOption("you play.", "", OPTION_FLAG_DISABLED) 
		AddEmptyOption()
		AddTextOption("To see newly-added followers in this list,", "", OPTION_FLAG_DISABLED) 
		AddTextOption("play any song.", "", OPTION_FLAG_DISABLED) 
	EndIf
	
EndEvent

Event OnOptionHighlight(Int Option)
	If MyPage == "Options"
		If (Option == SpeechToggle)
			SetInfoText("Enables playing music to increase your speechcraft skill")
		ElseIf (Option == PreferredInstrumentText)
			SetInfoText("Your preferred instrument for multi-part songs")
		ElseIf (Option == FactionAggressionToggle)
			SetInfoText("Enables Stormcloak songs to enrage Imperials, and vice versa")
		ElseIf (Option == CourtingToggle)
			SetInfoText("Enables performances to influence relationship rank with NPCs")
		ElseIf (Option == DancingToggle)
			SetInfoText("Enables NPC dancing while you are playing songs")
		ElseIf (Option == CustomFitText)
			SetInfoText("Whether the lute sits far away or very close to the back  (Select Loose option if you wear bulky armor or arrows)  Exit the MCM for changes to be applied")
		ElseIf (Option == SongbookCheatToggle)
			SetInfoText("Enables the songbook cheat page on the next page of the MCM")
		ElseIf (Option == ConsolidateToggle)
			SetInfoText("Whether to consolidate all songbook powers into one.  Requires UIExtensions.  Consolidated songbook can be convenient, but is a little slower to fire and has a limit of 128 entries.")
		EndIf
	
	ElseIf MyPage == "Performance Log"
		Int NumTaverns = _LP_BardTavernLocations.GetSize()
		Int i = 0
		While i < NumTaverns
			If Option == TavernCounts[i]
				SetInfoText("Number of times you've performed at the " + _LP_BardTavernLocations.GetAt(i).GetName())
			EndIf
			i += 1
		EndWhile
	
	ElseIf (MyPage == "Custom Songbook")
		If CSOptionPage == ""
			If (Option == CSPageSwitchTitle)
				SetInfoText("Rename the Custom Songbook")
			ElseIf (Option == CSPageSwitchNames)
				SetInfoText("Set the name of each song in your Custom Songbook")
			ElseIf (Option == CSPageSwitchLengths)
				SetInfoText("Set the length of each song in your Custom Songbook")
			ElseIf (Option == CSPageSwitchInstruments)
				SetInfoText("Set the instruments to use with each song in your Custom Songbook")
			Else
				SetInfoText("Place these custom songs in the folder Skyrim\\Data\\Sound\\FX\\Mus\\Bard\\Custom")
			EndIf
		ElseIf CSOptionPage == "Custom Songbook Title" || CSOptionPage == "Custom Song Names"
			SetInfoText("Selecting RENAME will close the MCM and open a text box.  DO NOT change the file name in your data folder (Custom01.xwm, etc).  This only changes the name in-game.")
		ElseIf CSOptionPage == "Custom Song Lengths" || CSOptionPage == "Custom Song Instruments"
			SetInfoText("Place these custom songs in the folder Skyrim\\Data\\Sound\\FX\\Mus\\Bard\\Custom")
		EndIf
		
	ElseIf MyPage == "Songbooks"
		SetInfoText("Songbooks are abilities, just like special racial abilities.  Select them in your spell menu and press Z to use.")
		
	ElseIf MyPage == "Followers"
		SetInfoText("Followers left unchecked will not play music with you and will join the audience.")
	EndIf
EndEvent

Event OnOptionSliderOpen(Int Option)
	If CSOptionPage == "Custom Song Lengths" 
		Int i = 0
		While i < 9
			If Option == CustomLengthSliders[i]
			SetSliderDialogStartValue((_LP_BardCustomSongbookLengths.GetAt(i) As GlobalVariable).GetValue() As Int)
			SetSliderDialogDefaultValue(60)
			SetSliderDialogRange(1, 300)
			SetSliderDialogInterval(1)
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnOptionSliderAccept(Int Option, Float Value)
	If CSOptionPage == "Custom Song Lengths" 
		Int i = 0
		While i < 9
			If Option == CustomLengthSliders[i]
				(_LP_BardCustomSongbookLengths.GetAt(i) As GlobalVariable).SetValue(Value)
				SetSliderOptionValue(Option, Value, "{0} seconds")
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnOptionSelect(Int Option)

	If MyPage == "Options"
		If (Option == SpeechToggle)
			If _LP_BardSpeech.GetValue() As Int == 0
				_LP_BardSpeech.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardSpeech.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == CourtingToggle)
			If _LP_BardCourting.GetValue() As Int == 0
				_LP_BardCourting.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardCourting.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == DancingToggle)
			If _LP_BardDancing.GetValue() As Int == 0
				_LP_BardDancing.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardDancing.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == FactionAggressionToggle)
			If _LP_BardFactionAggression.GetValue() As Int == 0
				_LP_BardFactionAggression.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardFactionAggression.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == JournalToggle)
			If _LP_BardKeepJournal.GetValue() As Int == 0
				_LP_BardKeepJournal.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardKeepJournal.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == SongbookCheatToggle)
			If _LP_BardSongbookCheat.GetValue() As Int == 0
				_LP_BardSongbookCheat.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardSongbookCheat.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == ConsolidateToggle)
			If _LP_BardConsolidateSongbook.GetValue() As Int == 0
				_LP_BardConsolidateSongbook.SetValue(1)
				SetToggleOptionValue(Option, 1)
			Else
				_LP_BardConsolidateSongbook.SetValue(0)
				SetToggleOptionValue(Option, 0)
			EndIf
		ElseIf (Option == PreferredInstrumentText)
			Int Current = _LP_BardPreferredInstrument.GetValue() As Int
			If Current < 4
				_LP_BardPreferredInstrument.SetValue(Current + 1)
				SetTextOptionValue(Option, Instruments[Current + 1])
			ElseIf Current == 4
				_LP_BardPreferredInstrument.SetValue(1)
				SetTextOptionValue(Option, Instruments[1])
			EndIf
		ElseIf (Option == CustomFitText)
			If _LP_BardCustomFit.GetValue() As Int == 0
				_LP_BardCustomFit.SetValue(1)
				SetTextOptionValue(Option, "Snug")
			Else
				_LP_BardCustomFit.SetValue(0)
				SetTextOptionValue(Option, "Loose")
			EndIf
		EndIf

	ElseIf MyPage == "Custom Songbook"
		If CSOptionPage == ""
			If (Option == CSPageSwitchTitle)
				CSPage = "Custom Songbook Title"
				ForcePageReset()
			ElseIf (Option == CSPageSwitchNames)
				CSPage = "Custom Song Names"
				ForcePageReset()
			ElseIf (Option == CSPageSwitchLengths)
				CSPage = "Custom Song Lengths"
				ForcePageReset()
			ElseIf (Option == CSPageSwitchInstruments)
				CSPage = "Custom Song Instruments"
				ForcePageReset()
			ElseIf (Option == CustomSongbookToggle)
				If PlayerREF.HasSpell(_LP_BardSongbookCustomAbility) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbookCustom)
					PlayerREF.RemoveSpell(_LP_BardSongbookCustomAbility)
					_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbookCustom)
					SetToggleOptionValue(Option, 0)
				Else
					If _LP_BardConsolidateSongbook.GetValue() As Int == 0
						PlayerREF.AddSpell(_LP_BardSongbookCustomAbility, 0)
					Else
						_LP_BardKnownSongbooks.AddForm(_LP_BardSongbookCustom)
						PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
					EndIf
					SetToggleOptionValue(Option, 1)
				EndIf
			EndIf

		ElseIf CSOptionPage == "Custom Songbook Title"
			If (Option == CSPageCloseTitle)
				CSRenameIndex = -1
				Int Esc = Input.GetMappedKey("Tween Menu")
				While Utility.IsInMenuMode()
					Input.TapKey(Esc)
					Utility.WaitMenuMode(0.25)
				EndWhile
				UILIB_1.TextInputMenu_Open(Self)
			EndIf

		ElseIf CSOptionPage == "Custom Song Names"
			Int i = 0
			While i < 9
				If Option == CSPageCloseNames[i]
					CSRenameIndex = i
				EndIf
				i += 1
			EndWhile
			Int Esc = Input.GetMappedKey("Tween Menu")
			While Utility.IsInMenuMode()
				Input.TapKey(Esc)
				Utility.WaitMenuMode(0.25)
			EndWhile
			UILIB_1.TextInputMenu_Open(Self)

		ElseIf CSOptionPage == "Custom Song Instruments"
			Int i = 0
			While i < 9
				If Option == CustomInstrumentsA[i]
					Int Current = (_LP_BardCustomSongbookInstrumentsA.GetAt(i) As GlobalVariable).GetValue() As Int
					If Current < 3
						(_LP_BardCustomSongbookInstrumentsA.GetAt(i) As GlobalVariable).SetValue(Current + 1)
						SetTextOptionValue(Option, Instruments[Current + 1])
					ElseIf Current == 3
						(_LP_BardCustomSongbookInstrumentsA.GetAt(i) As GlobalVariable).SetValue(1)
						SetTextOptionValue(Option, Instruments[1])
					EndIf
				EndIf
				i += 1
			EndWhile
			i = 0
			While i < 9
				If Option == CustomInstrumentsB[i]
					Int Current = (_LP_BardCustomSongbookInstrumentsB.GetAt(i) As GlobalVariable).GetValue() As Int
					If Current < 3
						(_LP_BardCustomSongbookInstrumentsB.GetAt(i) As GlobalVariable).SetValue(Current + 1)
						SetTextOptionValue(Option, Instruments[Current + 1])
					ElseIf Current == 3
						(_LP_BardCustomSongbookInstrumentsB.GetAt(i) As GlobalVariable).SetValue(1)
						SetTextOptionValue(Option, Instruments[1])
					EndIf
				EndIf
				i += 1
			EndWhile
		EndIf
		
	ElseIf MyPage == "Songbooks"
		Int NumBooks = _LP_BardSongbooksRegional.GetSize()
		Int i = 0
		While i < NumBooks
			If Option == SongbookRegionalToggles[i]
				If PlayerREF.HasSpell(_LP_BardSongbookSpellsRegional.GetAt(i) As Spell) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbooksRegional.GetAt(i))
					PlayerREF.RemoveSpell(_LP_BardSongbookSpellsRegional.GetAt(i) As Spell)
					_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbooksRegional.GetAt(i))
					SetToggleOptionValue(Option, 0)
				Else
					If _LP_BardConsolidateSongbook.GetValue() As Int == 0
						PlayerREF.AddSpell(_LP_BardSongbookSpellsRegional.GetAt(i) As Spell, 0)
					Else
						_LP_BardKnownSongbooks.AddForm(_LP_BardSongbooksRegional.GetAt(i))
						PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
					EndIf
					SetToggleOptionValue(Option, 1)
				EndIf
			EndIf
			i += 1
		EndWhile
		NumBooks = _LP_BardSongbooksUnique.GetSize()
		i = 0
		While i < NumBooks
			If Option == SongbookUniqueToggles[i]
				If PlayerREF.HasSpell(_LP_BardSongbookSpellsUnique.GetAt(i) As Spell) || _LP_BardKnownSongbooks.HasForm(_LP_BardSongbooksUnique.GetAt(i))
					PlayerREF.RemoveSpell(_LP_BardSongbookSpellsUnique.GetAt(i) As Spell)
					_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbooksUnique.GetAt(i))
					SetToggleOptionValue(Option, 0)
				Else
					If _LP_BardConsolidateSongbook.GetValue() As Int == 0
						PlayerREF.AddSpell(_LP_BardSongbookSpellsUnique.GetAt(i) As Spell, 0)
					Else
						_LP_BardKnownSongbooks.AddForm(_LP_BardSongbooksUnique.GetAt(i))
						PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
					EndIf
					SetToggleOptionValue(Option, 1)
				EndIf
			EndIf
			i += 1
		EndWhile
		
	ElseIf MyPage == "Followers"
		Int i = 0
		While i < 5
			If Option == FollowerToggles[i]
				If Followers[i].IsInFaction(_LP_BardDoNotPlayFaction) == 0
					Followers[i].AddToFaction(_LP_BardDoNotPlayFaction)
					SetToggleOptionValue(Option, 0)
				Else
					Followers[i].RemoveFromFaction(_LP_BardDoNotPlayFaction)
					SetToggleOptionValue(Option, 1)
				EndIf	
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Function ConsolidateSongbook()
	Int NumBooks = _LP_BardSongbooks.GetSize()
	;debug.notification("books: " + NumBooks)
	;debug.notification("spells: " + _LP_Bardsongbookspells.getsize())
	Int i
	Int AddSongbook = 0
	While i < NumBooks
		If PlayerREF.HasSpell(_LP_BardSongbookSpells.GetAt(i) As Spell)
			_LP_BardKnownSongbooks.AddForm(_LP_BardSongbooks.GetAt(i) As Book)
			PlayerREF.RemoveSpell(_LP_BardSongbookSpells.GetAt(i) As Spell)
			AddSongbook = 1
		EndIf
		i += 1
	EndWhile
	If AddSongbook == 1
		PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
	EndIf
EndFunction

Function ExpandSongbook()
	Int NumBooks = _LP_BardSongbooks.GetSize()
	Int i
	While i < NumBooks
		If _LP_BardKnownSongbooks.HasForm(_LP_BardSongbooks.GetAt(i))
			PlayerREF.AddSpell(_LP_BardSongbookSpells.GetAt(i) As Spell, 0)
			_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbooks.GetAt(i))
		EndIf
		i += 1
	EndWhile
	PlayerREF.RemoveSpell(_LP_BardSongbookAbility)
EndFunction