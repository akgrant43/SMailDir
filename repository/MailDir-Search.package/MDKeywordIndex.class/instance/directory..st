accessing
directory: aFileReference

	directory := aFileReference asFileReference.
	process ifNil:
		[ process := [ archive := MDMailArchive archiveIn: directory.
		archiveName ifNotNil: [ archive archiveName: archiveName ].
		trashBoxName ifNotNil: [ archive trashBoxName: trashBoxName ].
		process := nil ] forkAt: Processor userBackgroundPriority named: 'MDKeywordIndex load' ]
	ifNotNil: 
		[ self error: 'Unable to load - process already running' ]