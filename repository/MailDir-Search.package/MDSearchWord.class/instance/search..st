searching
search: aMDSearchMail

	^(index isNil or: [(index isIndexed: word) not]) ifTrue:
		[(self searchSubject: aMDSearchMail) or: [ 
			(self searchSender: aMDSearchMail) or: [ 
			(self searchRecipients: aMDSearchMail) or: [ 
			(self searchBody: aMDSearchMail) ] ] ] ]
	ifFalse:
		[ index at: word includes: aMDSearchMail messageId ]