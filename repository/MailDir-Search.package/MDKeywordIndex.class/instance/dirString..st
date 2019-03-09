accessing
dirString: aString

	dirString := aString.
	archive := MDMailArchive archiveIn: dirString asFileReference.
	archiveName ifNotNil: [ archive archiveName: archiveName ].
	trashBoxName ifNotNil: [ archive trashBoxName: trashBoxName ]