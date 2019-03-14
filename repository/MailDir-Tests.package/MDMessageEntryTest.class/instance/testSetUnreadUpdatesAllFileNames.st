accessing
testSetUnreadUpdatesAllFileNames

	doubleMessageEntry setUnread.
	self deny: doubleMessageEntry hasBeenSeen.
	doubleMessageEntry files do: [:f |
		self assert: (f basename = (self doubleMailFileName1 allButLast) 
		or: [f basename = (self doubleMailFileName2 allButLast)])].
	
	doubleMessageEntry files do: [:f |
		self assert: ((archive boxes collect: [:b | b newMessagesDirectory]) includes: f parent)].