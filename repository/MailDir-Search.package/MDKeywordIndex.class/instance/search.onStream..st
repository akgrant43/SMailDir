searching
search: expressionString onStream: aStream

	| searchNode |

	searchNode := MDSearchParser new parse: expressionString.
	autoIndex ifTrue: [ self updateIndexFrom: searchNode ].
	searchNode index: self.
	archive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]