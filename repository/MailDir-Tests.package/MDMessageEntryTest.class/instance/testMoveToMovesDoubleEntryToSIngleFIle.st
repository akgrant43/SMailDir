accessing
testMoveToMovesDoubleEntryToSIngleFIle
	
	doubleMessageEntry moveTo: box2.
	
	self assert: doubleMessageEntry files size equals: 1.
	self assert: ((box2Directory / 'cur') children includes: doubleMessageEntry file).