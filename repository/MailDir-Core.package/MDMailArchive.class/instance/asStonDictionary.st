ston persistence
asStonDictionary

	| dictionary convIndex |

	dictionary := Dictionary new.
	#(fileDirectory boxes mailIdIndex flagSeparator archiveName trashBoxName archiveBoxName sentBoxName draftsBoxName) do: [ :each |
		dictionary at: each put: (each value: self) ].
	"WeakDictionaries don't play nicely with STON - convert to an Array of associations for serialisation"
	convIndex := Array streamContents: [ :stream |
		conversationIndex keysAndValuesDo: [ :key :value |
			stream nextPut: key -> value ] ].
	dictionary at: #conversationIndex put: convIndex.
	^dictionary