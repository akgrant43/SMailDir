accessing
dirString: aString

	dirString := aString.
	process ifNil:
		[ process := [ archive := MDMailArchive archiveIn: dirString asFileReference.
		archiveName ifNotNil: [ archive archiveName: archiveName ].
		trashBoxName ifNotNil: [ archive trashBoxName: trashBoxName ].
		process := nil ] forkAt: Processor userBackgroundPriority named: 'MDKeywordIndex load' ]
	ifNotNil: 
		[ self error: 'Unable to load - process already running' ]