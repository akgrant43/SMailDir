tests
testSynchronizationUpdatesIfThereAreMultipleFilesForAMail

	messageEntry file copyTo: box2Directory / 'cur' / messageEntry file basename.
	
	archive synchronizeMessageEntries.
	
	self assert: messageEntry equals: (archive allMails detect: [:m | m messageId = self mailMessageId]).
	self assert: box mails size equals: 3.
	self assert: box2 mails size equals: 2.
	self assert: (box2 mails includes: messageEntry).
	self assert: (box mails includes: messageEntry).
	self assert: {box . box2} asSet equals: messageEntry boxes asSet.