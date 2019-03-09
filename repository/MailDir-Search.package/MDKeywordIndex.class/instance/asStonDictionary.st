ston persistence
asStonDictionary

	^Dictionary new
		at: 'directory' put: directory;
		at: 'archiveName' put: archiveName;
		at: 'trashBoxName' put: trashBoxName;
		at: 'index' put: index;
		yourself.