searching
search: expressionString onStream: aStream

	| searchNode |

	searchNode := MDSearchParser new parse: expressionString.
	searchNode isPetit2Failure ifTrue: [ self error: searchNode printString ].
	autoIndex ifTrue: [ self updateIndexFrom: searchNode ].
	searchNode index: self.
	archive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]