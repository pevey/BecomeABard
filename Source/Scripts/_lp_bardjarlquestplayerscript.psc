Scriptname _LP_BardJarlQuestPlayerScript extends ReferenceAlias

LocationAlias Property Alias_Location Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If Game.GetPlayer().IsInLocation(Alias_Location.GetLocation()) == False
		If GetOwningQuest().GetStage() == 0 ; Hasn't taken the quest
			GetOwningQuest().Stop()
		ElseIf GetOwningQuest().GetStage() == 10 ; Took the quest, but didn't perform
			GetOwningQuest().SetObjectiveFailed(10)
			GetOwningQuest().SetStage(0)
			GetOwningQuest().Stop()
		EndIf
	EndIf
EndEvent


