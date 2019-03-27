index management
addKeyword: aString

	| keyword |

	keyword := aString trimBoth.
	self assert: (keyword allSatisfy: [ :each | each isAlphaNumeric ]).
	indexMutex critical: [ index at: keyword ifAbsentPut: Set new ].
