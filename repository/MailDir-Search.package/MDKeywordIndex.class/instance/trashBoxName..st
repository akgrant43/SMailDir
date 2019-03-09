accessing
trashBoxName: aString

	trashBoxName := aString.
	archive ifNotNil: [ archive trashBoxName: aString ]