searching
search: expressionString

	| results unique messageIds |

	results := (Array streamContents: [ :stream |
		self search: expressionString onStream: stream ]).
	messageIds := Set new.
	unique := Array streamContents: [ :stream |
		results do: [ :each |
			(messageIds includes: each messageId) ifFalse: 
				[ stream nextPut: each.
				messageIds add: each messageId ] ] ].
	^unique sorted: #date descending.
