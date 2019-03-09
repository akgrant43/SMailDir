accessing
archiveName: aString

	archiveName := aString.
	archive ifNotNil: [ archive archiveName: aString ]