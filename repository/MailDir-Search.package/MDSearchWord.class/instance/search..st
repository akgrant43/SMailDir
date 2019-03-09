searching
search: aMDSearchMail

	^index ifNil:
		[(self searchSubject: aMDSearchMail) or: [ 
			(self searchSender: aMDSearchMail) or: [ 
			(self searchRecipients: aMDSearchMail) or: [ 
			(self searchBody: aMDSearchMail) ] ] ] ]
	ifNotNil:
		[ index at: word includes: aMDSearchMail messageId ]