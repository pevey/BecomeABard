Scriptname _LP_BardAudienceQuestAudienceScript extends ReferenceAlias  

Faction Property CWSonsFaction Auto
Faction Property CWImperialFaction Auto
GlobalVariable Property _LP_BardSongSons Auto
GlobalVariable Property _LP_BardSongImperial Auto
GlobalVariable Property _LP_BardAudienceHostile Auto

Event OnInit()
	Actor ActorREF = GetActorRef()
	If ActorREF
		If _LP_BardSongSons.GetValue() As Int > 0
			If ActorREF.GetFactionRank(CWImperialFaction) >= 0
				Utility.Wait(5.0)
				ActorREF.SendAssaultAlarm()
				_LP_BardAudienceHostile.SetValue(1)
			EndIf
		ElseIf _LP_BardSongImperial.GetValue() As Int > 0
			If ActorREF.GetFactionRank(CWSonsFaction) >= 0
				Utility.Wait(5.0)
				ActorREF.SendAssaultAlarm()
				_LP_BardAudienceHostile.SetValue(1)
			EndIf
		EndIf
	EndIf
EndEvent