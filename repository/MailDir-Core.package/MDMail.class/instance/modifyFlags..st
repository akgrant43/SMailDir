flags
modifyFlags: aBlock

	| messageParts fileName flags flagsString flagParts |
	self entries: (self entries collect: [:aFile | 
		messageParts := aFile basename findTokens: self flagSeparator. 
		flagParts := (messageParts last splitOn: '2,') asOrderedCollection.
		flagParts size = 1 ifTrue: [flagParts add: ''].
		flags := flagParts last.
	
		flags := aBlock value: flags.

		flagsString := self flagSeparator asString 
			, ('' join: flagParts allButLast) 
			, '2,' 
			, (String newFrom: flags sorted). 
	
		fileName := '' join: (messageParts allButLast , flagsString).
	
		self renameFile: aFile to: (aFile parent / fileName)])
	