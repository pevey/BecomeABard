Scriptname _LP_BardPlaySongbookUIEScript extends activemagiceffect  

_LP_BardQuestPlayerScript Property Bard Auto
Book Property _LP_BardSongbookCustom Auto
Book Property _LP_BardSongbookSkyrim Auto
Book Property _LP_BardSongbookSkyrimRevised Auto
FormList Property _LP_BardSongsofSkyrimFemale Auto
FormList Property _LP_BardSongsofSkyrimMale Auto
FormList Property _LP_BardKnownSongbooks Auto
FormList Property _LP_BardCustomSongbookInstrumentsA Auto
FormList Property _LP_BardCustomSongbookInstrumentsB Auto
FormList Property _LP_BardCustomSongbookLengths Auto
FormList Property _LP_BardCustomSongbookNames Auto
MiscObject Property _LP_BardCustomSongbookTitle Auto
GlobalVariable Property _LP_BardIsPlaying Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If _LP_BardIsPlaying.GetValue() As Int == 0 && Bard.StandStill() == True
			UIListMenu Songbook = UIExtensions.GetMenu("UIListMenu") As UIListMenu
			Int[] FormListIndices = new Int[128]
			Int[] SongListIndices = new Int[128]
			Int NumBooks = _LP_BardKnownSongbooks.GetSize()
			Int FormListIndex = 0
			Int MenuIndex = 0
			While  FormListIndex < NumBooks && MenuIndex < 128
				String Title
				If (_LP_BardKnownSongbooks.GetAt(FormListIndex) As _LP_BardSongbookScript) == _LP_BardSongbookCustom
					Title = _LP_BardCustomSongbookTitle.GetName()
				Else
					Title = (_LP_BardKnownSongbooks.GetAt(FormListIndex) As _LP_BardSongbookScript).Title
				EndIf
				Songbook.AddEntryItem(Title, -1, MenuIndex, True)
				MenuIndex += 1
				Int NumSongs = (_LP_BardKnownSongbooks.GetAt(FormListIndex) As _LP_BardSongbookScript).Names.Length
				Int SongListIndex = 0
				While SongListIndex < NumSongs && MenuIndex < 128
					Int ParentIndex = MenuIndex - (SongListIndex + 1)
					String Name
					If (_LP_BardKnownSongbooks.GetAt(FormListIndex) As Book) == _LP_BardSongbookCustom
						Name = (_LP_BardCustomSongbookNames.GetAt(SongListIndex) As MiscObject).GetName()
					Else
						Name = (_LP_BardKnownSongbooks.GetAt(FormListIndex) As _LP_BardSongbookScript).Names[SongListIndex]
					EndIf
					Songbook.AddEntryItem(Name, ParentIndex, MenuIndex, False)
					FormListIndices[MenuIndex] = FormListIndex
					SongListIndices[MenuIndex] = SongListIndex
					SongListIndex += 1
					MenuIndex += 1	
				EndWhile
				FormListIndex += 1
			EndWhile
			Songbook.OpenMenu()
			Int i = Songbook.GetResultInt()
			If i == -1
				Bard.CancelMenu()
			Else
				If (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As Book) == _LP_BardSongbookSkyrim || (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As Book) == _LP_BardSongbookSkyrimRevised
					Int NumVerses = (_LP_BardSongsofSkyrimFemale.GetAt(SongListIndices[i]) As FormList).GetSize()
					Int Sex = (Game.GetPlayer().getBaseObject() as ActorBase).GetSex() ; 0 = Male, 1 = Female
					FormList Song
					If Sex == 1
						Song = (_LP_BardSongsofSkyrimFemale.GetAt(SongListIndices[i]) As FormList)
					Else
						Song = (_LP_BardSongsofSkyrimMale.GetAt(SongListIndices[i]) As FormList)
					EndIf
					Int InstrumentA = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).InstrumentsA[SongListIndices[i]]
					Int InstrumentB = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).InstrumentsB[SongListIndices[i]]
					Bard.Sing(Song, NumVerses, InstrumentA, InstrumentB)
				ElseIf (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As Book) == _LP_BardSongbookCustom
					Sound Song = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).Songs[SongListIndices[i]]
					Int SongLength = (_LP_BardCustomSongbookLengths.GetAt(SongListIndices[i]) As GlobalVariable).GetValue() As Int
					Int InstrumentA = (_LP_BardCustomSongbookInstrumentsA.GetAt(SongListIndices[i]) As GlobalVariable).GetValue() As Int
					Int InstrumentB = (_LP_BardCustomSongbookInstrumentsB.GetAt(SongListIndices[i]) As GlobalVariable).GetValue() As Int
					Bard.Play(Song, SongLength, InstrumentA, InstrumentB)
				Else
					Sound Song = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).Songs[SongListIndices[i]]
					Int SongLength = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).Lengths[SongListIndices[i]]
					Int InstrumentA = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).InstrumentsA[SongListIndices[i]]
					Int InstrumentB = (_LP_BardKnownSongbooks.GetAt(FormListIndices[i]) As _LP_BardSongbookScript).InstrumentsB[SongListIndices[i]]
					Bard.Play(Song, SongLength, InstrumentA, InstrumentB)
				EndIf
			EndIf
		EndIf
EndEvent