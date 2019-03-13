accessing
directory: aFileReference

	directory := aFileReference asFileReference.
	process ifNil:
		[ process := [ archive := MDMailArchive archiveIn: directory.
		archive archiveName: self archiveName.
		archive trashBoxName: self trashBoxName.
		self reindex.
		process := nil ] forkAt: Processor userBackgroundPriority named: 'MDKeywordIndex load' ]
	ifNotNil:
		[ self error: 'Unable to load - process already running' ]