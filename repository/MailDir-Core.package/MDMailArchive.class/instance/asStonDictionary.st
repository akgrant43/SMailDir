ston persistence
asStonDictionary

	| dictionary |

	dictionary := Dictionary new.
	#(fileDirectory boxes mailIdIndex conversationIndex flagSeparator archiveName trashBoxName archiveBoxName sentBoxName draftsBoxName) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary