ston persistence
asStonDictionary

	^Dictionary new
		at: 'dirString' put: dirString;
		at: 'archiveName' put: archiveName;
		at: 'trashBoxName' put: trashBoxName;
		at: 'index' put: index;
		yourself.