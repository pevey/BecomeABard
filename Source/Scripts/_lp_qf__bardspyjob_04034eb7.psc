;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname _LP_QF__BARDSPYJOB_04034EB7 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Handler
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Handler Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Jarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Jarl Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; player has performed for the jarl, directed to return to Viarmo
SetObjectiveDisplayed(10, false)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; player has cancelled job
SetObjectiveFailed(10)
Stop()
Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; tell player to perform in a certain jarl's court
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
; player has returned to Viarmo
SetObjectiveDisplayed(20, false)
Debug.Notification("You discreetly hand Viarmo your notes")
Game.GetPlayer().AddItem(Gold001, 200)
Stop()
Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


MiscObject Property Gold001  Auto  
