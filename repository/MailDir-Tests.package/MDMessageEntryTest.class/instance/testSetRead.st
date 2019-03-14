accessing
testSetRead

	newMessageEntry setRead.
	self assert: newMessageEntry hasBeenSeen.
	self assert: newMessageEntry file basename equals: (self newMailFileName , 'S').
	self assert: newMessageEntry file parent = (boxDirectory / 'cur')