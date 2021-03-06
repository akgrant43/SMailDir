meta information
setRead
	
	hasBeenSeen := true.
	self addOrdinaryFlag: $S.
	
	(self entries associations select: [:assoc | 
		| file box |
		box := assoc key.
		file := assoc value.
		file parent ~= box currentMessagesDirectory]) do: [:assoc | | newFile |
		     newFile := self moveFile: assoc value within: assoc key.
			self entries at: assoc key put: newFile].
	
	self changed.