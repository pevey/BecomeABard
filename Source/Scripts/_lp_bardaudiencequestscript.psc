Scriptname _LP_BardAudienceQuestScript extends Quest  

Actor Property PlayerREF Auto
Armor Property _LP_BardLuteArmor Auto
Faction Property _LP_BardDoNotPlayFaction Auto
GlobalVariable Property _LP_BardSkill Auto
GlobalVariable Property _LP_BardCourting Auto
GlobalVariable Property _LP_BardInstrumentB Auto
GlobalVariable Property _LP_BardCustomFit Auto
Idle Property IdleDrumStart Auto
Idle Property IdleFluteStart Auto
Idle Property IdleLuteStart Auto
Idle Property IdleStop_Loose Auto
ReferenceAlias Property Follower00 Auto
ReferenceAlias Property Follower01 Auto
ReferenceAlias Property Follower02 Auto
ReferenceAlias Property Follower03 Auto
ReferenceAlias Property Follower04 Auto
ReferenceAlias Property Audience00 Auto
ReferenceAlias Property Audience01 Auto
ReferenceAlias Property Audience02 Auto
ReferenceAlias Property Audience03 Auto
ReferenceAlias Property Audience04 Auto
ReferenceAlias Property Audience05 Auto
ReferenceAlias Property Audience06 Auto
ReferenceAlias Property Audience07 Auto
ReferenceAlias Property Audience08 Auto
ReferenceAlias Property Audience09 Auto
Actor[] Followers
Actor[] Audience
Armor[] FollowerShields
Armor[] FollowerLutes

Event OnInit()
	Audience = new Actor [10]
	Followers = new Actor[5]
	FollowerShields = new Armor[5]
	FollowerLutes = new Armor[5]
	Followers[0] = Follower00.GetActorRef()
	Followers[1] = Follower01.GetActorRef()
	Followers[2] = Follower02.GetActorRef()
	Followers[3] = Follower03.GetActorRef()
	Followers[4] = Follower04.GetActorRef()
	If Followers[0]
		If Followers[0].IsInFaction(_LP_BardDoNotPlayFaction)
			Audience05.ForceRefTo(Followers[0])
			Followers[0] = None
		EndIf
	EndIf
	If Followers[1]
		If Followers[1].IsInFaction(_LP_BardDoNotPlayFaction)
			Audience06.ForceRefTo(Followers[1])
			Followers[1] = None
		EndIf
	EndIf
	If Followers[2]
		If Followers[2].IsInFaction(_LP_BardDoNotPlayFaction)
			Audience07.ForceRefTo(Followers[2])
			Followers[2] = None
		EndIf
	EndIf
	If Followers[3]
		If Followers[3].IsInFaction(_LP_BardDoNotPlayFaction)
			Audience08.ForceRefTo(Followers[3])
			Followers[3] = None
		EndIf
	EndIf
	If Followers[4]
		If Followers[4].IsInFaction(_LP_BardDoNotPlayFaction)
			Audience09.ForceRefTo(Followers[4])
			Followers[4] = None
		EndIf
	EndIf
	Audience[0] = Audience00.GetActorRef()
	Audience[1] = Audience01.GetActorRef()
	Audience[2] = Audience02.GetActorRef()
	Audience[3] = Audience03.GetActorRef()
	Audience[4] = Audience04.GetActorRef()
	Audience[5] = Audience05.GetActorRef()
	Audience[6] = Audience06.GetActorRef()
	Audience[7] = Audience07.GetActorRef()
	Audience[8] = Audience08.GetActorRef()
	Audience[9] = Audience09.GetActorRef()
EndEvent

Function StartPlaying()
	Idle[] PerformanceIdles = new Idle[4]
	PerformanceIdles[1] = IdleDrumStart
	PerformanceIdles[2] = IdleFluteStart
	PerformanceIdles[3] = IdleLuteStart
	Int Instrument = _LP_BardInstrumentB.GetValue() As Int
	If Instrument != 0
		Int i = 0
		Int n = 5
		Bool WaitForMe = false
		While i < n
			If Followers[i]
				If Followers[i].IsWeaponDrawn()
					WaitForMe = true
					Followers[i].SheatheWeapon() 		; Function requires SKSE
				EndIf
			EndIf
			i+=1
		EndWhile
		If WaitForMe == true
			Utility.Wait(2.0)
		EndIf
		i = 0
		While i < n
			If Followers[i]
				FollowerShields[i] = UnEquipShield(Followers[i])
				If Instrument == 3
					FollowerLutes[i] = UnequipLute(Followers[i])
				EndIf
			EndIf
			i+=1
		EndWhile
		Utility.Wait(0.1)
		i = 0
		While i < n
			If Followers[i]
				Followers[i].PlayIdle(PerformanceIdles[Instrument])
			EndIf
			i+=1
		EndWhile
	EndIf
EndFunction

Function StopPlaying()
	Int i = 0
	Int n = 5
	While i < n
		If Followers[i]
			Followers[i].PlayIdle(IdleStop_Loose)
			EquipShield(Followers[i], FollowerShields[i])
			EquipLute(Followers[i], FollowerLutes[i])
		EndIf
		i+=1
	EndWhile
EndFunction

Function UpdateRelationshipRanks()
	If _LP_BardCourting.GetValue() As Int > 0
		Int i = 0
		Int n = 10
		While i < n
			If Audience[i]
				If Audience[i].GetRelationshipRank(PlayerREF) == 0
					Int Max = 100 - _LP_BardSkill.GetValue() As Int
					Int Roll = Utility.RandomInt(0, Max)
				;	debug.notification(roll)
					If Roll == 0
						Audience[i].MakePlayerFriend()
				;		debug.notification("updating "+Audience[i].GetName() + "relationship rank to 1")
					EndIf
				EndIf
			EndIf
			i+=1
		EndWhile
	EndIf
EndFunction

Function EvaluatePackages()
	Int i = 0
	Int n = 10
	While i < n
		If Audience[i]
			Audience[i].EvaluatePackage()
		EndIf
		i+=1
	EndWhile
EndFunction

Function SetLookAt()
	Int i = 0
	Int n = 10
	While i < n
		If Audience[i]
			Audience[i].SetLookAt(PlayerREF, false)
		EndIf
		i+=1
	EndWhile
EndFunction

Function ClearLookAt()
	Int i = 0
	Int n = 10
	While i < n
		If Audience[i]
			Audience[i].ClearLookAt()
		EndIf
		i+=1
	EndWhile
EndFunction

Armor Function UnequipShield(Actor akActor)
	Armor Shield = akActor.GetEquippedShield()
	If Shield != None
		akActor.UnequipItem(Shield, 0, 1)
	EndIf
	Return Shield
EndFunction

Function EquipShield(Actor akActor=NONE, Armor Shield=NONE)
	If Shield == None
		Return
	Else
		akActor.EquipItem(Shield, 0, 1)
	EndIf
EndFunction

Armor Function UnequipLute(Actor akActor)
	If akActor.IsEquipped(_LP_BardLuteArmor)
		akActor.UnEquipItem(_LP_BardLuteArmor, 0, 1)
		Return _LP_BardLuteArmor
	EndIf
EndFunction

Function EquipLute(Actor akActor, Armor Lute=NONE)
	If Lute != None
		If _LP_BardCustomFit.GetValue() == 1 ; This should only be set to 1 through the MCM, so SKSE is installed
			ArmorAddon LuteAA = Lute.GetNthArmorAddon(0)
			LuteAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, false) ; male
			LuteAA.SetModelPath("LP\\instruments\\lutecloseAA.nif", false, true) ; female
		EndIf
		akActor.EquipItem(Lute, 0, 1)
	EndIf
EndFunction