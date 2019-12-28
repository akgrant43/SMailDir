indexing
indexIntoMessageIdIndex: anEntry

	| oldEntry |

	oldEntry := self mailIdIndex at: anEntry messageId ifAbsentPut: [ anEntry ].
	oldEntry == anEntry ifFalse: [ 
		self halt. ]