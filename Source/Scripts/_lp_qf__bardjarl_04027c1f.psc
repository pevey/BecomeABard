;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname _LP_QF__BARDJARL_04027C1F Extends Quest Hidden

;BEGIN ALIAS PROPERTY Jarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Jarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Location
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_Location Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;player has accepted quest
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;player has performed 1 song
SetObjectiveDisplayed(10, false)
setObjectiveDisplayed(100)
;(Alias_Player as _LP_BardJarlQuestPlayerScript).RollForReward()
If _LP_BardSkill.GetValue() As Int + Utility.RandomInt(0, 100) >= 100
_LP_BardJarlQuestReward.SetValue(1)
EndIf
If _LP_BardSpyJobQuest.GetStage() == 10  && (Jarl.GetActorRef() == Alias_Jarl.GetActorRef())
Debug.Notification("You discreetly take note of things overheard in the jarl's presence.")
_LP_BardSpyJobQuest.SetStage(20)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
;player just entered the keep 
;debug.notification("Bard quest started")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
;player has collected pay
SetObjectiveDisplayed(100, false)
If _LP_BardJarlQuestReward.GetValue() > 0
Int Max = _LP_BardJarlRewards.getSize() - 1
Int n = Utility.RandomInt(0, Max)
Game.GetPlayer().AddItem(_LP_BardJarlRewards.GetAt(n) As Form)
_LP_BardJarlQuestReward.SetValue(0)
EndIf
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _LP_BardSkill  Auto  

GlobalVariable Property _LP_BardJarlQuestReward  Auto  

Quest Property _LP_BardSpyJobQuest  Auto  

FormList Property _LP_BardJarlRewards  Auto  

ReferenceAlias Property Jarl  Auto  
