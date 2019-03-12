indexing
determineStartMailIdFor: anEntry

	| predecessorId |

	predecessorId := anEntry inReplyTo.
	predecessorId = 'none' ifTrue: [ ^anEntry messageId ].
	predecessorId = anEntry messageId ifTrue: [^ predecessorId]. 
		
	^ self determineStartMailIdFor: (self messageEntryForId: predecessorId ifAbsent: [^ anEntry messageId])