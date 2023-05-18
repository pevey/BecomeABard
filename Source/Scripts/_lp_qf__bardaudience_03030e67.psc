;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname _LP_QF__BARDAUDIENCE_03030E67 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Audience05
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience05 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience00
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience00 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower04
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower04 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience08
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience08 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower00
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower00 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience09
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience09 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience07
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience07 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience04
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience04 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Audience06
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Audience06 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE _LP_BardAudienceQuestScript
Quest __temp = self as Quest
_LP_BardAudienceQuestScript kmyQuest = __temp as _LP_BardAudienceQuestScript
;END AUTOCAST
;BEGIN CODE
; start song
kmyQuest.EvaluatePackages()
kmyQuest.SetLookAt()
kmyQuest.StartPlaying()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE _LP_BardAudienceQuestScript
Quest __temp = self as Quest
_LP_BardAudienceQuestScript kmyQuest = __temp as _LP_BardAudienceQuestScript
;END AUTOCAST
;BEGIN CODE
; applause
kmyQuest.EvaluatePackages()
Utility.Wait(5.0)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE _LP_BardAudienceQuestScript
Quest __temp = self as Quest
_LP_BardAudienceQuestScript kmyQuest = __temp as _LP_BardAudienceQuestScript
;END AUTOCAST
;BEGIN CODE
; stop song
kmyQuest.EvaluatePackages()
kmyQuest.ClearLookAt()
kmyQuest.StopPlaying()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; start up, not playing
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE _LP_BardAudienceQuestScript
Quest __temp = self as Quest
_LP_BardAudienceQuestScript kmyQuest = __temp as _LP_BardAudienceQuestScript
;END AUTOCAST
;BEGIN CODE
; song is over, update relationship ranks
kmyQuest.UpdateRelationshipRanks()
SetStage(40)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor[] Property Audience  Auto  
