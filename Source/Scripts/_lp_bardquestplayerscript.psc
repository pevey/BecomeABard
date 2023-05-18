Scriptname _LP_BardQuestPlayerScript extends ReferenceAlias

Actor Property PlayerREF Auto
Armor Property _LP_BardLuteArmor Auto
BardSongsScript Property BardSongs Auto
Book Property _LP_BardSongbookDrum Auto
Book Property _LP_BardSongbookFlute Auto
Book Property _LP_BardSongbookLute Auto
FormList Property _LP_BardInstruments Auto
FormList Property _LP_BardDrums  Auto
FormList Property _LP_BardFlutes  Auto
FormList Property _LP_BardLutes  Auto
FormList Property _LP_BardKnownSongbooks Auto
FormList Property _LP_BardSongsImperial Auto
FormList Property _LP_BardSongsSons Auto
GlobalVariable Property _LP_BardAudienceHostile Auto
GlobalVariable Property _LP_BardFactionAggression Auto
GlobalVariable Property _LP_BardInstrumentB Auto
GlobalVariable Property _LP_BardIsPlaying Auto
GlobalVariable Property _LP_BardSkill Auto
GlobalVariable Property _LP_BardSongImperial Auto
GlobalVariable Property _LP_BardSongSons Auto
GlobalVariable Property _LP_BardSpeech Auto
GlobalVariable Property _LP_BardSpeechIncrement Auto
GlobalVariable Property _LP_BardPreferredInstrument Auto
GlobalVariable Property _LP_BardCustomFit Auto
GlobalVariable Property _LP_BardKeepJournal Auto
GlobalVariable Property _LP_BardConsolidateSongbook Auto
GlobalVariable Property _LP_BardHasSKSE Auto
GlobalVariable Property _LP_BardHasUIExtensions Auto
GlobalVariable Property _LP_BardHasFrostfall Auto
Idle Property IdleDrumStart Auto
Idle Property IdleFluteStart Auto
Idle Property IdleLuteStart Auto
Idle Property IdleStop_Loose Auto
Idle Property IdleSilentBow  Auto  
MiscObject Property ImperialWarHorn Auto
MiscObject Property NordWarHorn Auto
Quest Property _LP_BardAudienceQuest Auto
Quest Property _LP_BardJournalQuest Auto
Quest Property _LP_BardFollowerQuest Auto
Quest Property _LP_BardTavernQuest Auto
Quest Property _LP_BardJarlQuest Auto
Quest Property _LP_BardSpyHandlerQuest Auto
ReferenceAlias Property Follower00 Auto
ReferenceAlias Property Journal Auto
SoundCategory Property AudioCategoryMUS Auto
Spell Property _LP_BardSongbookAbility Auto
Spell Property _LP_BardPlayDrumAbility Auto
Spell Property _LP_BardPlayFluteAbility Auto
Spell Property _LP_BardPlayLuteAbility Auto
Spell Property _LP_BardPlayHornImperialAbility Auto
Spell Property _LP_BardPlayHornNordAbility Auto
Spell Property _LP_BardExperiencedAbility Auto
Spell Property _LP_BardWellKnownAbility Auto
Spell Property _LP_BardRenownedAbility Auto
Armor Shield
Armor Lute
Int CameraState
Int InstrumentA
Int SoundREF
Int SongWasStopped
Int FrostfallAnimationSetting
Float SongStartTime
Float SongEndTime

; Instruments
;		0:		None
;		1:		Drum
;		2:		Flute
;		3:		Lute
;		4:		Voice

Event OnInit()
	AddInventoryEventFilter(_LP_BardInstruments)
EndEvent

Event OnUpdate()
	If _LP_BardAudienceHostile.GetValue() As Int > 0 || SongWasStopped
		_LP_BardAudienceHostile.SetValue(0)
		StopPlaying()
	Else
		If Utility.GetCurrentRealTime() >= SongEndTime
			StopPlaying(true)
		Else
			RegisterForSingleUpdate(0.5)
		EndIf
	EndIf
EndEvent

Event OnKeyDown(Int KeyCode)
	If KeyCode == 44 || KeyCode == 275
		StopSong()
	EndIf
EndEvent

Function StopSong()
	If (Utility.GetCurrentRealTime() - SongStartTime) > 2
		SongWasStopped = 1
		UnRegisterForAllKeys()
	EndIf
EndFunction

Function Sing(FormList Verse, Int nVerses, Int A, Int B)
	If _LP_BardPreferredInstrument.GetValue() As Int == B
		If Follower00
			Int Temp = A
			A = B
			B = Temp
		EndIf
	EndIf
	If HasInstrument(A) == False
		Debug.Notification("You don't have the right instrument.")
		StopPlaying()
		Return
	EndIf
	InstrumentA = A
	_LP_BardInstrumentB.SetValue(B)
	If _LP_BardFactionAggression.GetValue() As Int == 1
		If _LP_BardSongsImperial.Find(Verse.GetAt(0) As Sound) >= 0
			_LP_BardSongImperial.SetValue(1)
		ElseIf _LP_BardSongsSons.Find(Verse.GetAt(0) As Sound) >= 0
			_LP_BardSongSons.SetValue(1)
		EndIf
	EndIf
	StartPlaying()
	SongWasStopped = 0
	Int i = 0
	While i < nVerses
		If !SongWasStopped
			(Verse.GetAt(i) As Sound).PlayAndWait(PlayerREF)
		EndIf
		i += 1
	EndWhile
	StopPlaying(!SongWasStopped)
EndFunction

Function Play(Sound Song, Float SoundLength, Int A, Int B)
	If PlayerREF.IsInCombat() == true
		Debug.Notification("You cannot use this musical ability in combat")
	Else
		If _LP_BardPreferredInstrument.GetValue() As Int == B
			If Follower00
				Int Temp = A
				A = B
				B = Temp
			EndIf
		EndIf
		If HasInstrument(A) == False
			Debug.Notification("You don't have the right instrument.")
			StopPlaying()
			Return
		EndIf
		InstrumentA = A
		_LP_BardInstrumentB.SetValue(B)
		If _LP_BardFactionAggression.GetValue() As Int == 1
			If _LP_BardSongsImperial.Find(Song) >= 0
				_LP_BardSongImperial.SetValue(1)
			ElseIf _LP_BardSongsSons.Find(Song) >= 0
				_LP_BardSongSons.SetValue(1)
			EndIf
		EndIf
		StartPlaying()
		SoundREF = Song.Play(PlayerREF)
		If !SoundREF
			Debug.Notification("You don't know that song")
			StopPlaying()
		Else
			SongWasStopped = 0
			SongEndTime = Utility.GetCurrentRealTime() + SoundLength
			RegisterForSingleUpdate(0.5)
		EndIf
	EndIf
EndFunction

Bool Function StandStill()
	If PlayerREF.IsInCombat() == true
		Debug.Notification("You cannot use this musical ability in combat")
		Return False
	Else
		_LP_BardIsPlaying.SetValue(1)
		CameraState = Game.GetCameraState()
		Game.ForceThirdPerson()
		Game.SetInChargen(true, false, false)
		If PlayerREF.IsWeaponDrawn()
			If _LP_BardHasSKSE
	 			PlayerREF.SheatheWeapon()
			Else
				Game.DisablePlayerControls()
				Game.EnablePlayerControls()
			EndIf
			Utility.Wait(2.0)
		EndIf
		; If you disable player controls, SKSE is needed to read the input to stop the song (via OnKeyDown or OnControlDown)
		; If controls are enabled, we can stop the song via the magic effect script, so the player just needs to press Z again.
		; Downside is that player can stop the animation by jumping or drawing weapon using the non-SKSE method
		If _LP_BardHasSKSE
			Game.DisablePlayerControls(abMovement=true, abFighting=true, abCamSwitch=true, abLooking=false, abSneaking=true, abMenu=true, abActivate = true, abJournalTabs=true)
			RegisterForKey(44)
			RegisterForKey(275)
		EndIf
		If _LP_BardHasFrostfall.GetValue() As Int == 1
			; This reads the Frostfall setting for the hand-warming animations, stores it, and then sets it to off
			; We set it back to whatever the user had it set to when we StopPlaying()
			FrostfallAnimationSetting = (Game.GetFormFromFile(0x02049268, "Chesko_Frostfall.esp") As GlobalVariable).GetValue() As Int
			(Game.GetFormFromFile(0x02049268, "Chesko_Frostfall.esp") As GlobalVariable).SetValue(1)
		EndIf
		Return True
	EndIf
EndFunction

Function CancelMenu()
	If _LP_BardHasFrostfall.GetValue() As Int == 1
		(Game.GetFormFromFile(0x02049268, "Chesko_Frostfall.esp") As GlobalVariable).SetValue(FrostfallAnimationSetting)
	EndIf
	Game.SetInChargen(false, false, false)
	If _LP_BardHasSKSE
		Game.EnablePlayerControls()
	EndIf
	If CameraState == 0
		Game.ForceFirstPerson()
	EndIf
	_LP_BardIsPlaying.SetValue(0)
EndFunction

Function StartPlaying()
	UnequipShield()
	BardSongs.StopAllSongs()
	_LP_BardAudienceQuest.Stop()
	_LP_BardAudienceQuest.Start()
	SongStartTime = Utility.GetCurrentRealTime()
	If InstrumentA == 1
		PlayerREF.PlayIdle(IdleDrumStart)
	ElseIf InstrumentA == 2
		PlayerREF.PlayIdle(IdleFluteStart)
	ElseIf InstrumentA == 3
		UnequipLute()
		PlayerREF.PlayIdle(IdleLuteStart)
	EndIf
	AudioCategoryMUS.Mute()
	Utility.Wait(0.5) ; Allow time to get the instruments out before starting the sound
	_LP_BardAudienceQuest.SetStage(10)
EndFunction

Function StopPlaying(Bool SongFinished=false)
	PlayerREF.PlayIdle(IdleStop_Loose)
	_LP_BardAudienceQuest.SetStage(20)
	_LP_BardSongImperial.SetValue(0)
	_LP_BardSongSons.SetValue(0)
	If _LP_BardHasFrostfall.GetValue() As Int == 1
		(Game.GetFormFromFile(0x02049268, "Chesko_Frostfall.esp") As GlobalVariable).SetValue(FrostfallAnimationSetting)
	EndIf
	Game.SetInChargen(false, false, false)
	If _LP_BardHasSKSE
		Game.EnablePlayerControls()
	EndIf
	EquipShield()
	EquipLute()
	UpdateFollowerList()
	If !SongFinished
		If SoundREF
			Sound.StopInstance(SoundREF)
		EndIf
		Utility.Wait(1.0)
	Else
		RewardPlayer()
	EndIf
	_LP_BardAudienceQuest.Stop()
	AudioCategoryMUS.UnMute()
	_LP_BardIsPlaying.SetValue(0)
	If CameraState == 0
		Game.ForceFirstPerson()
	EndIf
EndFunction

Function UpdateFollowerList()
	_LP_BardFollowerQuest.Stop()
	Utility.Wait(0.1)
	_LP_BardFollowerQuest.Start()
EndFunction

Function RewardPlayer()
	_LP_BardSkill.Mod(1)
	ObjectReference JournalREF
	Quest JournalQuest
	JournalREF = Journal.GetReference()
	JournalQuest = _LP_BardJournalQuest
	If JournalREF
		PlayerREF.RemoveItem(JournalREF, 1, 1)
	EndIf
	; Try to spawn the spy quest
	If _LP_BardSpyHandlerQuest.IsRunning() == 0 && _LP_BardSpyHandlerQuest.IsCompleted() == 0 
		If _LP_BardSkill.GetValue() As Int >= 25 && (PlayerREF.HasSpell(_LP_BardExperiencedAbility) || PlayerREF.HasSpell(_LP_BardWellKnownAbility) || PlayerREF.HasSpell(_LP_BardRenownedAbility))
			_LP_BardSpyHandlerQuest.Start() ; this won't start if the player has not completed Tending the Flames bc Viarmo is reserved
		EndIf
	EndIf
	; Increase speechcraft if that option is enabled
	If _LP_BardSpeech.GetValue() As Int == 1
		Game.AdvanceSkill("Speechcraft", _LP_BardSpeechIncrement.GetValue() As Int)
	EndIf
	; Advance the Tavern or Jarl Quests if they are active
	If _LP_BardTavernQuest.GetStage() == 10
		_LP_BardTavernQuest.SetStage(100)
		Utility.Wait(1.0)
		PlayerREF.PlayIdle(IdleSilentBow)
	EndIf
	If _LP_BardJarlQuest.GetStage() == 10
		_LP_BardJarlQuest.SetStage(100)
		Utility.Wait(1.0)
		PlayerREF.PlayIdle(IdleSilentBow)
	EndIf
	_LP_BardAudienceQuest.SetStage(30)
	If _LP_BardKeepJournal.GetValue() As Int > 0
		JournalQuest.Stop()
		JournalQuest.Start()
	EndIf
EndFunction

Bool Function HasInstrument(Int A)
	If A == 0 || A == 4
		Return true
	ElseIf A == 1
		Int i = 0
		Int n = _LP_BardDrums.GetSize()
		While i < n
			If PlayerREF.GetItemCount(_LP_BardDrums.GetAt(i)) > 0
				Return True
			EndIf
			i += 1
		EndWhile
		Return False
	ElseIf A == 2
		Int i = 0
		Int n = _LP_BardFlutes.GetSize()
		While i < n
			If PlayerREF.GetItemCount(_LP_BardFlutes.GetAt(i)) > 0
				Return True
			EndIf
			i += 1
		EndWhile
		Return False
	ElseIf A == 3
		Int i = 0
		Int n = _LP_BardLutes.GetSize()
		While i < n
			If PlayerREF.GetItemCount(_LP_BardLutes.GetAt(i)) > 0
				Return True
			EndIf
			i += 1
		EndWhile
		Return False
	EndIf
EndFunction

Function UnequipShield()
	Shield = PlayerREF.GetEquippedShield()
	If Shield != None
		PlayerREF.UnequipItem(Shield, 0, 1)
	EndIf
EndFunction

Function EquipShield()
	If Shield != None
		PlayerREF.EquipItem(Shield, 0, 1)
	EndIf
EndFunction

Function UnequipLute()
	If PlayerREF.IsEquipped(_LP_BardLuteArmor)
		PlayerREF.UnEquipItem(_LP_BardLuteArmor, 0, 1)
		Lute = _LP_BardLuteArmor
	EndIf
EndFunction

Function EquipLute()
	If Lute != None
		If _LP_BardCustomFit.GetValue() == 1 ; This should only be set to 1 through the MCM, so SKSE is installed
			ArmorAddon LuteAA = Lute.GetNthArmorAddon(0)
			LuteAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, false) ; male
			LuteAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, true) ; female
		EndIf
		PlayerREF.EquipItem(Lute, 0, 1)
		Lute = None ; reset for next use
	EndIf
EndFunction

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akFormReference, ObjectReference akSourceContainer)
	If _LP_BardDrums.HasForm(akBaseItem)
		If _LP_BardConsolidateSongbook.GetValue() As Int == 1
			_LP_BardKnownSongbooks.AddForm(_LP_BardSongbookDrum)
			PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
		Else
			PlayerREF.AddSpell(_LP_BardPlayDrumAbility, 0)
		EndIf
	ElseIf _LP_BardFlutes.HasForm(akBaseItem)
		If _LP_BardConsolidateSongbook.GetValue() As Int == 1
			_LP_BardKnownSongbooks.AddForm(_LP_BardSongbookFlute)
			PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
		Else
			PlayerREF.AddSpell(_LP_BardPlayFluteAbility, 0)
		EndIf
	ElseIf _LP_BardLutes.HasForm(akBaseItem)
		If _LP_BardConsolidateSongbook.GetValue() As Int == 1
			_LP_BardKnownSongbooks.AddForm(_LP_BardSongbookLute)
			PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
		Else
			PlayerREF.AddSpell(_LP_BardPlayLuteAbility, 0)
		EndIf
	ElseIf akBaseItem == ImperialWarHorn
		PlayerREF.AddSpell(_LP_BardPlayHornImperialAbility, 0)
	ElseIf akBaseItem == NordWarHorn
		PlayerREF.AddSpell(_LP_BardPlayHornNordAbility, 0)
	EndIf
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	If _LP_BardDrums.HasForm(akBaseItem)
		If HasInstrument(1) == 0
			If _LP_BardConsolidateSongbook.GetValue() As Int == 1
				_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbookDrum)
				If _LP_BardKnownSongbooks.GetSize() == 0
					PlayerREF.RemoveSpell(_LP_BardSongbookAbility)
				EndIf
			Else
				PlayerREF.RemoveSpell(_LP_BardPlayDrumAbility)
			EndIf
		EndIf
	ElseIf _LP_BardFlutes.HasForm(akBaseItem)
		If HasInstrument(2) == 0
			If _LP_BardConsolidateSongbook.GetValue() As Int == 1
				_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbookFlute)
				If _LP_BardKnownSongbooks.GetSize() == 0
					PlayerREF.RemoveSpell(_LP_BardSongbookAbility)
				EndIf
			Else
				PlayerREF.RemoveSpell(_LP_BardPlayFluteAbility)
			EndIf
		EndIf
	ElseIf _LP_BardLutes.HasForm(akBaseItem)
		If HasInstrument(3) == 0
			If _LP_BardConsolidateSongbook.GetValue() As Int == 1
				_LP_BardKnownSongbooks.RemoveAddedForm(_LP_BardSongbookLute)
				If _LP_BardKnownSongbooks.GetSize() == 0
					PlayerREF.RemoveSpell(_LP_BardSongbookAbility)
				EndIf
			Else
				PlayerREF.RemoveSpell(_LP_BardPlayLuteAbility)
			EndIf
		EndIf
	ElseIf akBaseItem == ImperialWarHorn
		If PlayerREF.GetItemCount(ImperialWarHorn) == 0
			PlayerREF.RemoveSpell(_LP_BardPlayHornImperialAbility)
		EndIf
	ElseIf akBaseItem == NordWarHorn
		If PlayerREF.GetItemCount(NordWarHorn) == 0
			PlayerREF.RemoveSpell(_LP_BardPlayHornNordAbility)
		EndIf
	EndIf
EndEvent