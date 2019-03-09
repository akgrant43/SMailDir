instance creation
search: expressionString inArchive: aMDMailArchive onStream: aStream

	| searchNode |

	searchNode := self parse: expressionString.
	aMDMailArchive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]