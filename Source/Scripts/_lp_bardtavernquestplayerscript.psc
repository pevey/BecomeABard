Scriptname _LP_BardTavernQuestPlayerScript extends ReferenceAlias

Actor Property PlayerREF Auto
FormList Property _LP_BardTavernCounts Auto
FormList Property _LP_BardTavernLocations  Auto  
FormList Property _LP_BardRank00Locations  Auto
FormList Property _LP_BardRank01Locations  Auto 
FormList Property _LP_BardRank02Locations  Auto 
GlobalVariable Property _LP_BardSkill Auto
GlobalVariable Property _LP_BardQuestsCompleted Auto
GlobalVariable Property _LP_BardKeepJournal Auto
LocationAlias Property Alias_Location Auto
MiscObject Property Gold001 Auto
Quest Property _LP_BardJournalQuest Auto
ReferenceAlias Property Alias_Innkeeper Auto
ReferenceAlias Property Journal Auto
Spell Property _LP_BardExperiencedAbility Auto
Spell Property _LP_BardWellKnownAbility Auto
Spell Property _LP_BardRenownedAbility Auto
Actor PlayerREF
Location LocationREF

Event OnInit()
	LocationREF = Alias_Location.GetLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If PlayerREF.IsInLocation(Alias_Location.GetLocation()) == False
		If GetOwningQuest().GetStage() == 0 ; Hasn't taken the quest
			GetOwningQuest().Stop()
		ElseIf GetOwningQuest().GetStage() == 10 ; Took the quest, but didn't perform
			GetOwningQuest().SetObjectiveFailed(10)
			GetOwningQuest().SetStage(0)	
			GetOwningQuest().Stop()
		EndIf
	EndIf
EndEvent

Function RewardPlayer()
	Float BardSkill = _LP_BardSkill.GetValue() As Float
	_LP_BardQuestsCompleted.Mod(1)
	ObjectReference JournalREF
	Quest JournalQuest
	JournalREF = Journal.GetReference()
	JournalQuest = _LP_BardJournalQuest
	If JournalREF
		PlayerREF.RemoveItem(JournalREF, 1, 1)
	EndIf
	Int i = _LP_BardTavernLocations.GetSize()
	Int RewardRank = 0
	While i > 0
		i -= 1
		If LocationREF == _LP_BardTavernLocations.GetAt(i)
			(_LP_BardTavernCounts.GetAt(i) As GlobalVariable).SetValue(((_LP_BardTavernCounts.GetAt(i) As GlobalVariable).GetValue() As Int) + 1)
			Int j = _LP_BardRank01Locations.GetSize()
			While j > 0
				j -= 1
				If LocationREF == _LP_BardRank01Locations.GetAt(j)
					RewardRank = 1
				EndIf
			EndWhile
			j = _LP_BardRank02Locations.GetSize()
			While j > 0
				j -= 1
				If LocationREF == _LP_BardRank02Locations.GetAt(j)
					RewardRank = 2
				EndIf
			EndWhile
		EndIf
	EndWhile
	CheckForNewPerks(BardSkill)
	Int RewardGold = CalculateGold(BardSkill, RewardRank)
	PlayerREF.AddItem(Gold001, RewardGold)
	If _LP_BardKeepJournal.GetValue() As Int > 0
		JournalQuest.Stop()
		JournalQuest.Start()
	EndIf
EndFunction

Int Function CalculateGold(Float BardSkill, Int RewardRank)
	Int[] RewardAmounts = new Int[3]
	RewardAmounts[0] = 10
	RewardAmounts[1] = 15
	RewardAmounts[2] = 25
	Int Multiple = 1
	If PlayerREF.HasSpell(_LP_BardExperiencedAbility)
		Multiple = 2
	ElseIf PlayerREF.HasSpell(_LP_BardWellKnownAbility)
		Multiple = 4
	ElseIf PlayerREF.HasSpell(_LP_BardRenownedAbility)
		Multiple = 8
	EndIf
	Int RewardGold = ((RewardAmounts[RewardRank] * Multiple) * (1 + (BardSkill * 0.01))) As Int
	Return RewardGold
EndFunction

Function CheckForNewPerks(Float BardSkill)
	If PlayerREF.HasSpell(_LP_BardExperiencedAbility) == 0 && PlayerREF.HasSpell(_LP_BardWellKnownAbility) == 0 && PlayerREF.HasSpell(_LP_BardRenownedAbility) == 0
		If _LP_BardQuestsCompleted.GetValue() As Int > 14
			PlayerREF.AddSpell(_LP_BardExperiencedAbility)
		EndIf
	ElseIf PlayerREF.HasSpell(_LP_BardWellKnownAbility) == 0 && PlayerREF.HasSpell(_LP_BardRenownedAbility) == 0
		Int WellKnown = 0
		Int i = 0
		Int NumTaverns = _LP_BardTavernLocations.GetSize()
		While i < NumTaverns
			If (_LP_BardTavernCounts.GetAt(i) As GlobalVariable).GetValue() As Int >= 1
				WellKnown += 1
			EndIf
			i += 1
		EndWhile
		If Wellknown > 10
			PlayerREF.RemoveSpell(_LP_BardExperiencedAbility)
			PlayerREF.AddSpell(_LP_BardWellKnownAbility)
		EndIf
	ElseIf PlayerREF.HasSpell(_LP_BardWellKnownAbility) == 1
		If BardSkill >= 100
			PlayerREF.RemoveSpell(_LP_BardWellKnownAbility)
			PlayerREF.AddSpell(_LP_BardRenownedAbility)
		EndIf
	EndIf
EndFunction