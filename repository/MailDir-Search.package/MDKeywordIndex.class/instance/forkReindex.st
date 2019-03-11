index management
forkReindex

	process ifNil:
		[ process := [ self reindex ] 
			forkAt: Processor userBackgroundPriority 
			named: 'MDKeywordIndex reindex' ]
	ifNotNil: 
		[ self error: 'Unable to load - process already running' ]