Class {
	#name : #MDSearchParser,
	#superclass : #MDSearchGrammar,
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDSearchParser class >> search: expressionString inArchive: aMDMailArchive [
	"Search the supplied archive using the supplied expression"

	^self new search: expressionString inArchive: aMDMailArchive
]

{ #category : #grammar }
MDSearchParser >> parentheses [

	^super parentheses ==> [ :nodes | nodes second ]
]

{ #category : #'instance creation' }
MDSearchParser >> search: expressionString inArchive: aMDMailArchive [

	^Array streamContents: [ :stream |
		self search: expressionString inArchive: aMDMailArchive onStream: stream ]
]

{ #category : #'instance creation' }
MDSearchParser >> search: expressionString inArchive: aMDMailArchive onStream: aStream [

	| searchNode |

	searchNode := self parse: expressionString.
	aMDMailArchive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]
]

{ #category : #operators }
MDSearchParser >> searchAnd [

	^super searchAnd ==> [ :nodes | MDSearchAnd children: { nodes first. nodes third. } ]
]

{ #category : #operators }
MDSearchParser >> searchOr [

	^super searchOr ==> [ :nodes | MDSearchOr children: { nodes first. nodes third. } ]
]

{ #category : #matching }
MDSearchParser >> word [ 

	^super word ==> [ :node | MDSearchWord word: node ]
]
