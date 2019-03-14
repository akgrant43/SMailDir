accessing
testMoveToMovesTheFile
	
	messageEntry moveTo: box2.
	
	self assert: box2 mails size equals: 2.
	self assert: (box2Directory / 'cur') children notEmpty.
	self assert: ((box2Directory / 'cur') children includes: messageEntry file)
