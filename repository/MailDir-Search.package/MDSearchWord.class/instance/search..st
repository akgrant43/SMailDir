searching
search: aMDSearchMail

	^(self searchSubject: aMDSearchMail) or: [ 
		(self searchSender: aMDSearchMail) or: [ 
		(self searchRecipients: aMDSearchMail) or: [ 
		(self searchBody: aMDSearchMail) ] ] ]