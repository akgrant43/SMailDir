tests
testSynchronizationMovesMovedFiles

	"Move the file"
	messageEntry file copyTo: box2Directory / 'cur' / messageEntry file basename.
	messageEntry file delete.
	
	archive synchronizeMessageEntries.
	
	self assert: messageEntry equals: (archive allMails detect: [:m | m messageId = self mailMessageId]).
	self assert: box mails size equals: 2.
	self assert: box2 mails size equals: 2.
	self assert: (box2 mails includes: messageEntry).
	self assert: (messageEntry boxes includes: box2).