files
copyFileTo: aBox

	| directory newFile |	
	directory := self hasBeenRead
		ifTrue: [aBox currentMessagesDirectory]
		ifFalse: [aBox newMessagesDirectory].
	newFile := directory / self file basename.
	newFile exists
		ifFalse: [self file copyTo: newFile].

	^ newFile