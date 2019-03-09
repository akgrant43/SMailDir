searching
search: expressionString onStream: aStream

	| searchNode |

	searchNode := MDSearchParser new parse: expressionString.
	searchNode index: self.
	archive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]