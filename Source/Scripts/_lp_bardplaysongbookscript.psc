Scriptname _LP_BardPlaySongbookScript extends activemagiceffect  

_LP_BardQuestPlayerScript Property Bard Auto
Book Property _LP_BardSongbookCustom Auto
Book Property _LP_BardSongbookSkyrim Auto
Book Property _LP_BardSongbookSkyrimRevised Auto
Book Property Songbook Auto
FormList Property _LP_BardKnownSongbooks Auto
FormList Property _LP_BardCustomSongbookSongs Auto
FormList Property _LP_BardCustomSongbookLengths Auto
FormList Property _LP_BardCustomSongbookInstrumentsA Auto
FormList Property _LP_BardCustomSongbookInstrumentsB Auto
FormList Property _LP_BardSongsofSkyrimFemale Auto
FormList Property _LP_BardSongsofSkyrimMale Auto
GlobalVariable Property _LP_BardIsPlaying Auto
Message Property Menu Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If _LP_BardIsPlaying.GetValue() As Int == 0 && Bard.StandStill() == True
		Int i = Menu.Show()
		If i == -1
			Bard.CancelMenu()
		Else
			If Songbook == _LP_BardSongbookSkyrim || Songbook == _LP_BardSongbookSkyrimRevised
				Int Sex = (Game.GetPlayer().getBaseObject() as ActorBase).GetSex() ; 0 = Male, 1 = Female
				FormList Song
				If Sex == 1
					Song = (_LP_BardSongsofSkyrimFemale.GetAt(i) As FormList)
				Else
					Song = (_LP_BardSongsofSkyrimMale.GetAt(i) As FormList)
				EndIf
				Int NumVerses = (_LP_BardSongsofSkyrimFemale.GetAt(i) As FormList).GetSize()
				Int InstrumentA = (Songbook As _LP_BardSongbookScript).InstrumentsA[i]
				Int InstrumentB = (Songbook As _LP_BardSongbookScript).InstrumentsB[i]
				If Song
					Bard.Sing(Song, NumVerses, InstrumentA, InstrumentB)
				Else
					Bard.CancelMenu()
				EndIf
			ElseIf Songbook == _LP_BardSongbookCustom
				Sound Song = _LP_BardCustomSongbookSongs.GetAt(i) As Sound
				Int SongLength = (_LP_BardCustomSongbookLengths.GetAt(i) As GlobalVariable).GetValue() As Int
				Int InstrumentA = (_LP_BardCustomSongbookInstrumentsA.GetAt(i) As GlobalVariable).GetValue() As Int
				Int InstrumentB = (_LP_BardCustomSongbookInstrumentsB.GetAt(i) As GlobalVariable).GetValue() As Int
				If Song
					Bard.Play(Song, SongLength, InstrumentA, InstrumentB)
				Else
					Bard.CancelMenu()
				EndIf
			Else
				If (Songbook As _LP_BardSongbookScript).Songs[i]
					Bard.Play((Songbook As _LP_BardSongbookScript).Songs[i], (Songbook As _LP_BardSongbookScript).Lengths[i], (Songbook As _LP_BardSongbookScript).InstrumentsA[i], (Songbook As _LP_BardSongbookScript).InstrumentsB[i])
				Else
					Bard.CancelMenu()
				EndIf
			EndIf
		EndIf
	Else
		Bard.StopSong()
	EndIf
EndEvent