Scriptname _LP_BardInventoryQuestScript extends Quest  

FormList Property SongbooksRegional Auto
FormList Property SongbookSpellsRegional Auto
FormList Property SongbooksUnique Auto
FormList Property SongbookSpellsUnique Auto
FormList Property _LP_BardSongbooks Auto
FormList Property _LP_BardSongbookSpells Auto
FormList Property _LP_BardSongbooksRegional Auto
FormList Property _LP_BardSongbookSpellsRegional Auto
FormList Property _LP_BardSongbooksUnique Auto
FormList Property _LP_BardSongbookSpellsUnique Auto
LeveledItem Property _LP_BardViarmoInventory  Auto

Event OnInit()
	RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
	Int i = 0
	Int NumBooks = SongbooksRegional.GetSize()
	While i < NumBooks
		_LP_BardViarmoInventory.AddForm(SongbooksRegional.GetAt(i) As Book, 1, 1)
		_LP_BardSongbooks.AddForm(SongbooksRegional.GetAt(i) As Book)
		_LP_BardSongbookSpells.AddForm(SongbookSpellsRegional.GetAt(i) As Spell)
		_LP_BardSongbooksRegional.AddForm(SongbooksRegional.GetAt(i) As Book)
		_LP_BardSongbookSpellsRegional.AddForm(SongbookSpellsRegional.GetAt(i) As Spell)
		i += 1
	EndWhile
	i = 0
	NumBooks = SongbooksUnique.GetSize()
	While i < NumBooks
		_LP_BardViarmoInventory.AddForm(SongbooksUnique.GetAt(i) As Book, 1, 1)
		_LP_BardSongbooks.AddForm(SongbooksUnique.GetAt(i) As Book)
		_LP_BardSongbookSpells.AddForm(SongbookSpellsUnique.GetAt(i) As Spell)
		_LP_BardSongbooksUnique.AddForm(SongbooksUnique.GetAt(i) As Book)
		_LP_BardSongbookSpellsUnique.AddForm(SongbookSpellsUnique.GetAt(i) As Spell)
		i += 1
	EndWhile
	Stop()
EndEvent

