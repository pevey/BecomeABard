Scriptname _LP_BardConfigQuestPlayerScript extends ReferenceAlias  

Actor Property PlayerREF Auto
FormList Property _LP_BardTavernCounts Auto
FormList Property _LP_BardTavernLocations  Auto 
FormList Property _LP_BardRank00Locations  Auto
FormList Property _LP_BardRank01Locations  Auto
FormList Property _LP_BardRank02Locations  Auto
FormList Property _LP_BardFlutes Auto
FormList Property _LP_BardLutes Auto
FormList Property _LP_BardKnownSongbooks Auto
FormList Property _LP_BardSongbookSpells Auto
FormList Property _LP_BardSongbooks Auto
GlobalVariable Property _LP_BardHasSKSE Auto
GlobalVariable Property _LP_BardHasUIExtensions Auto
GlobalVariable Property _LP_BardHasFrostfall Auto
GlobalVariable Property _LP_BardKeepJournal Auto
GlobalVariable Property _LP_BardConsolidateSongbook Auto
GlobalVariable Property _LP_BardVersionNum Auto
GlobalVariable Property _LP_BardCountRetchingNetch Auto
GlobalVariable Property _LP_BardCountOddvarsMeadhouse Auto
GlobalVariable Property _LP_BardCountDiversArms Auto
GlobalVariable Property _LP_BardCountLarkAndSparrow Auto
GlobalVariable Property _LP_BardCountIronHalls Auto
GlobalVariable Property _LP_BardCountWallsideInn Auto
Quest Property _LP_BardQuest Auto
Quest Property _LP_BardConfigQuest Auto
Quest Property _LP_BardFollowerQuest Auto
Quest Property _LP_BardJournalQuest Auto
Quest Property _LP_BardSpyHandlerQuest Auto
Quest Property _LP_BardSpyJobQuest Auto
Quest Property _LP_BardTavernQuest Auto
Spell Property _LP_BardSongbookAbility Auto
Spell Property _LP_BardSongbookDrumAbility Auto
Spell Property _LP_BardSongbookFluteAbility Auto
Spell Property _LP_BardSongbookLuteAbility Auto

Event OnInit()
	RegisterForSingleUpdate(0.1)
EndEvent

Event OnUpdate()
	CompatibilityChecks()

	If _LP_BardVersionNum.GetValue() As Int == 0
		_LP_BardVersionNum.SetValue(060102)								; CHANGE THIS NUM FOR EACH RELEASE!!!
	EndIf

	If _LP_BardKeepJournal.GetValue() As Int == 1
		If !_LP_BardJournalQuest.IsRunning()
			_LP_BardJournalQuest.Start()
		EndIf
	EndIf
EndEvent

Event OnPlayerLoadGame()
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
	CompatibilityChecks()
	Update()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	_LP_BardFollowerQuest.Stop()
	Utility.Wait(0.1)
	_LP_BardFollowerQuest.Start()
EndEvent

Function Update()
	If _LP_BardVersionNum.GetValue() As Int < 040208
		If _LP_BardSpyHandlerQuest.IsRunning()
			_LP_BardSpyHandlerQuest.CompleteAllObjectives()
			_LP_BardSpyHandlerQuest.SetStage(0)
			_LP_BardSpyHandlerQuest.Stop()
			_LP_BardSpyHandlerQuest.SetStage(0)
			Utility.Wait(0.5)
			_LP_BardSpyHandlerQuest.Start()
		EndIf
		If _LP_BardSpyJobQuest.IsRunning()
			_LP_BardSpyJobQuest.CompleteAllObjectives()
			_LP_BardSpyJobQuest.Stop()
		EndIf
	EndIf
	If _LP_BardVersionNum.GetValue() As Int < 060101 			
		_LP_BardQuest.Stop()
		_LP_BardConfigQuest.Stop()
		_LP_BardTavernQuest.Stop()
		Utility.Wait(0.5)
		_LP_BardQuest.Start()
		_LP_BardConfigQuest.Start()
		RefreshSongbooks()
		_LP_BardVersionNum.SetValue(060102) 									; CHANGE THIS NUM FOR EACH RELEASE!!!
		Debug.MessageBox("Become a Bard mod has been updated to 6.1.2.  See mod page for details.")	; CHANGE THE MSG FOR EACH RELEASE!!!
	EndIf
EndFunction

Function CompatibilityChecks()

	_LP_BardTavernLocations.revert()
	_LP_BardRank00Locations.revert()
	_LP_BardRank01Locations.revert()
	_LP_BardRank02Locations.revert()
	_LP_BardTavernCounts.revert()

	;----SKSE---------------------------------------------------------------------------------------------------------------

	If (SKSE.GetVersionRelease() > 0)
		_LP_BardHasSKSE.SetValue(1)
	Else
		_LP_BardHasSKSE.SetValue(0)
	EndIf

	;----DRAGONBORN----------------------------------------------------------------------------------------------------

	If Game.GetModByName("Dragonborn.esm") != 255
		Form RetchingNetch = Game.GetFormFromFile(0x02019A24, "Dragonborn.esm")
		_LP_BardTavernLocations.AddForm(RetchingNetch)
		_LP_BardRank01Locations.AddForm(RetchingNetch)
		_LP_BardTavernCounts.AddForm(_LP_BardCountRetchingNetch)
	EndIf

	;----CAPITAL WINDHELM EXPANSION------------------------------------------------------------------------------------------

	If Game.GetModByName("WindhelmSSE.esp") != 255
		Form IronHalls = Game.GetFormFromFile(0x051B623A, "WindhelmSSE.esp")
		Form WallsideInn = Game.GetFormFromFile(0x051BA09A, "WindhelmSSE.esp")
		_LP_BardTavernLocations.AddForm(IronHalls)
		_LP_BardRank01Locations.AddForm(IronHalls)
		_LP_BardTavernCounts.AddForm(_LP_BardCountIronHalls)
		_LP_BardTavernLocations.AddForm(WallsideInn)
		_LP_BardRank01Locations.AddForm(WallsideInn)
		_LP_BardTavernCounts.AddForm(_LP_BardCountWallsideInn)
	EndIf

	;----FROSTFALL--------------------------------------------------------------------------------------------------------
	; fixes player stopping to do warm hands idle while playing  song 

	If Game.GetModByName("Chesko_Frostfall.esp") != 255
		_LP_BardHasFrostfall.SetValue(1)
	Else
		_LP_BardHasFrostfall.SetValue(0)
	EndIf

	;----UIEXTENSIONS----------------------------------------------------------------------------------------------------

	Int StoreUIExtensions = _LP_BardHasUIExtensions.GetValue() As Int
	If Game.GetModByName("UIExtensions.esp") != 255
		_LP_BardHasUIExtensions.SetValue(1)
		If StoreUIExtensions == 0
			; could consolidate here by default, but let user choose in MCM
		EndIf
	Else
		_LP_BardHasUIExtensions.SetValue(0)
		If StoreUIExtensions == 1
			_LP_BardConsolidateSongbook.SetValue(0)
			(GetOwningQuest() As _LP_BardConfigQuestScript).ExpandSongbook()
		EndIf
	EndIf

EndFunction

Function RefreshSongbooks()
		Bool[] Removed = new Bool[29]
		Int i = 0
		While i < 30
			If PlayerREF.HasSpell(_LP_BardSongbookSpells.GetAt(i) As Spell)
				Removed[i] = True
				PlayerREF.RemoveSpell(_LP_BardSongbookSpells.GetAt(i) As Spell)
			EndIf
			i += 1
		EndWhile
		i = 0
		While i < 30
			If Removed[i] == True
				PlayerREF.AddSpell(_LP_BardSongbookSpells.GetAt(i) As Spell, 0)
			EndIf
			i += 1
		EndWhile
EndFunction