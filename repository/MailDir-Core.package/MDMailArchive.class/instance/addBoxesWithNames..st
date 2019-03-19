initialize-release
addBoxesWithNames: rootBoxNames

	rootBoxNames do: [ :dirName | | rootBoxName rootBox |
		rootBoxName := (dirName findTokens: '.') last.
		rootBox := MDMailBox newFor: self fileDirectory / dirName in: self.
		self addBox: rootBox named: rootBoxName]
	
	