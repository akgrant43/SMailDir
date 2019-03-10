ston persistence
asStonDictionary

	| dictionary |

	dictionary := Dictionary new.
	#(fileDirectory mailArchive subBoxes mails) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary