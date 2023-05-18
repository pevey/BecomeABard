;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname _LP_QF__BARDTAVERN_04027C20 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Innkeeper
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Innkeeper Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Location
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_Location Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;player has performed
SetObjectiveDisplayed(10, false)
setObjectiveDisplayed(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;player has accepted quest
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
;player just entered an inn 
;debug.notification("Bard quest started")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;player has collected pay
SetObjectiveDisplayed(100, false)
(Alias_Player as _LP_BardTavernQuestPlayerScript).RewardPlayer()
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
