instance creation
search: expressionString inArchive: aMDMailArchive

	^Array streamContents: [ :stream |
		self search: expressionString inArchive: aMDMailArchive onStream: stream ]