Scriptname _LP_BardReadSongbookScript extends ObjectReference

Actor Property PlayerREF Auto
Book Property Songbook Auto
FormList Property _LP_BardKnownSongbooks Auto
GlobalVariable Property _LP_BardConsolidateSongbook Auto
Message Property _LP_BardMenuLearn Auto
Message Property _LP_BardMenuUnlearn Auto
Spell Property SongbookSpell Auto
Spell Property _LP_BardSongbookAbility Auto

Event OnRead()
	If _LP_BardConsolidateSongbook.GetValue() As Int == 1
		If _LP_BardKnownSongbooks.HasForm(Songbook)
			Int i = _LP_BardMenuUnlearn.Show()
			If i == 0
				_LP_BardKnownSongbooks.RemoveAddedForm(Songbook)
				If _LP_BardKnownSongbooks.GetSize() == 0
					PlayerREF.RemoveSpell(_LP_BardSongbookAbility)
				EndIf
			EndIf
		Else
			Int i = _LP_BardMenuLearn.Show()
			If i == 0
				_LP_BardKnownSongbooks.AddForm(Songbook)
				If _LP_BardKnownSongbooks.GetSize() == 1
					PlayerREF.AddSpell(_LP_BardSongbookAbility, 0)
				EndIf
			EndIf
		EndIf

	Else
		If PlayerREF.HasSpell(SongbookSpell)
			Int i = _LP_BardMenuUnlearn.Show()
			If i == 0
				PlayerREF.RemoveSpell(SongbookSpell)
			EndIf
		Else
			Int i = _LP_BardMenuLearn.Show()
			If i == 0
				PlayerREF.AddSpell(SongbookSpell)
			EndIf
		EndIf
	EndIf
EndEvent