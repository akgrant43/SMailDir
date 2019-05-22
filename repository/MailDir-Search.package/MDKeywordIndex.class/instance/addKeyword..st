index management
addKeyword: aString

	| keyword |

	keyword := aString trimBoth.
	self assert: (keyword allSatisfy: [ :char | char isAlphaNumeric or: 
			[ '_@.' includes: char ] ]).
	indexMutex critical: [ index at: keyword ifAbsentPut: Set new ].
