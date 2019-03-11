ston persistence
asStonDictionary

	| dictionary |

	dictionary := Dictionary new.
	#(mails archive senderNamesString) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary