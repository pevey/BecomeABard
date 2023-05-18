Scriptname _LP_BardPlayHornScript extends activemagiceffect 

Bool Property IsImperial Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Game.ForceThirdPerson()
	Actor PlayerREF = Game.GetPlayer()
	Bool WeaponDrawn = PlayerREF.IsWeaponDrawn()
	If WeaponDrawn
		Game.DisablePlayerControls()
		Game.EnablePlayerControls()
		Game.DisablePlayerControls(abMovement=true, abFighting=true, abCamSwitch=true, abLooking=false, abSneaking=true, abMenu=true, abJournalTabs=true)
		Utility.Wait(2.0)
	EndIf
	If IsImperial == 1
		Debug.SendAnimationEvent(PlayerREF, "IdleBlowHornImperial")
	Else
		Debug.SendAnimationEvent(PlayerREF, "IdleBlowHornStormcloak")
	EndIf
	Utility.Wait(5.0)
	If WeaponDrawn
		PlayerREF.DrawWeapon()
	EndIf
	Game.EnablePlayerControls()
EndEvent