ston persistence
asStonDictionary

	| dictionary |

	dictionary := Dictionary new.
	#(subject sender senderAddress senderName recipients date messageId cc entries mailArchive inReplyTo) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary