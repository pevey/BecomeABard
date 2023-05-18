;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname _LP_QF__BARDSPYHANDLER_04034EA9 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Handler
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Handler Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CourierNote
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CourierNote Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; just spawned by BardQuest by BardSkill reaching 50
Alias_CourierNote.GetReference().Enable()
WICourier.AddItemToContainer(Alias_CourierNote.GetReference())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; player has read note, tell him to go to Viarmo
SetObjectiveDisplayed(10, false)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; player has spoken to Viarmo, open up dialogue option to get jobs
SetObjectiveDisplayed(20, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; player has spoken to Viarmo
; start job quest and kick off first job
SetObjectiveDisplayed(20, false)
_LP_BardSpyJobQuest.Start()
_LP_BardSpyJobQuest.SetStage(10)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; player just received note, tell player to read it
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WICourierScript Property WICourier  Auto  

Quest Property _LP_BardSpyJobQuest Auto
