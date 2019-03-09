index management
addKeyword: aString

	| keyword messageIds searchTerm |

	keyword := aString trimBoth.
	self assert: (keyword allSatisfy: [ :each | each isAlphaNumeric ]).
	searchTerm := MDSearchWord word: aString.
	messageIds := Set new.
	archive allMailsDo: [ :each | | searchMail |
		searchMail := MDSearchMail mdMail: each.
		(searchTerm search: searchMail) ifTrue: 
				[ messageIds add: each messageId ] ].
	indexMutex critical: [ index at: keyword put: messageIds ].
