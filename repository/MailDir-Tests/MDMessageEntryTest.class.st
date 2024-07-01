Class {
	#name : #MDMessageEntryTest,
	#superclass : #MDTestCase,
	#category : 'MailDir-Tests'
}

{ #category : #accessing }
MDMessageEntryTest >> testArchiveDoubleMessage [

	doubleMessageEntry moveToArchive.
	
	self assert: 1 equals: archiveBox mails size.
	self assert: 1 equals: archiveBox currentMessagesDirectory entries size.
	
	self assert: 1 equals: doubleMessageEntry files size.
]

{ #category : #accessing }
MDMessageEntryTest >> testArchiveSimpleMessage [

	messageEntry moveToArchive.
	
	self assert: 1 equals: archiveBox mails size.
	self assert: 1 equals: archiveBox currentMessagesDirectory entries size.
]

{ #category : #accessing }
MDMessageEntryTest >> testDoubleMessageFlags [
	self assert: (doubleMessageEntry flags includesAll: #($F $S)).
	self assert: doubleMessageEntry flags size = 2
]

{ #category : #accessing }
MDMessageEntryTest >> testFlags [
	self assert: (messageEntry flags includesAll: #($R $S)).
	self assert: messageEntry flags size = 2
]

{ #category : #accessing }
MDMessageEntryTest >> testHasBeenRead [

	self assert: messageEntry hasBeenSeen.
	self assert: newMessageEntry hasBeenSeen not.
	self assert: doubleMessageEntry hasBeenSeen.
]

{ #category : #accessing }
MDMessageEntryTest >> testHeaderIsAlreadyIncluded [

	self assert: messageEntry subject equals: 'editable views | Access to project was granted'.
	self assert: messageEntry sender equals: 'GitLab <gitlab@gitlab.com>'.
	self assert: messageEntry recipients equals: 'patrick.rein@gmail.com'.
	self assert: messageEntry date equals: (DateAndTime year: 2014 month: 11 day: 13 hour: 23 minute: 51 second: 40 offset: 0 hours).
	self assert: self mailMessageId equals: messageEntry messageId.
	self assert: messageEntry cc equals: ''
]

{ #category : #accessing }
MDMessageEntryTest >> testMoveToMovesDoubleEntryToSIngleFIle [
	
	doubleMessageEntry moveTo: box2.
	
	self assert: doubleMessageEntry files size equals: 1.
	self assert: ((box2Directory / 'cur') children includes: doubleMessageEntry file).
]

{ #category : #accessing }
MDMessageEntryTest >> testMoveToMovesTheFile [
	
	messageEntry moveTo: box2.
	
	self assert: box2 mails size equals: 2.
	self assert: (box2Directory / 'cur') children notEmpty.
	self assert: ((box2Directory / 'cur') children includes: messageEntry file)

]

{ #category : #accessing }
MDMessageEntryTest >> testPrintString [
	
	self 
		assert: 'GitLab' , String tab , 'editable views | Access to project was granted' 		
		equals: messageEntry printString
]

{ #category : #accessing }
MDMessageEntryTest >> testSetRead [

	newMessageEntry setRead.
	self assert: newMessageEntry hasBeenSeen.
	self assert: newMessageEntry file basename equals: (self newMailFileName , 'S').
	self assert: newMessageEntry file parent = (boxDirectory / 'cur')
]

{ #category : #accessing }
MDMessageEntryTest >> testSetSeveralFlags [

	newMessageEntry setRead; setImportant.
	self assert: newMessageEntry hasBeenSeen.
	self assert: newMessageEntry isImportant.
	self assert: newMessageEntry file basename equals: (self newMailFileName , 'S').
	
	newMessageEntry setUnread; setUnimportant.
	self assert: newMessageEntry hasBeenSeen not.
	self assert: newMessageEntry isImportant not.
	self assert: newMessageEntry file basename equals: (self newMailFileName allButLast).
]

{ #category : #accessing }
MDMessageEntryTest >> testSetUnread [

	messageEntry setUnread.
	self assert: messageEntry hasBeenSeen not.
	self assert: messageEntry file basename equals: '81792873.3984_1.lovelace.staff.plugged.com.au;1,XYZ2,R'.
	self assert: messageEntry file parent equals: (boxDirectory / 'new')
]

{ #category : #accessing }
MDMessageEntryTest >> testSetUnreadUpdatesAllFileNames [

	doubleMessageEntry setUnread.
	self deny: doubleMessageEntry hasBeenSeen.
	doubleMessageEntry files do: [:f |
		self assert: (f basename = (self doubleMailFileName1 allButLast) 
		or: [f basename = (self doubleMailFileName2 allButLast)])].
	
	doubleMessageEntry files do: [:f |
		self assert: ((archive boxes collect: [:b | b newMessagesDirectory]) includes: f parent)].
]

{ #category : #accessing }
MDMessageEntryTest >> testTrashDoubleMessage [

	doubleMessageEntry moveToTrash.
	
	self assert: 1 equals: trashBox mails size.
	self assert: 1 equals: trashBox currentMessagesDirectory entries size.
	
	self assert: 1 equals: doubleMessageEntry files size.
]

{ #category : #accessing }
MDMessageEntryTest >> testTrashSimpleMessage [

	messageEntry moveToTrash.
	
	self assert: 1 equals: trashBox mails size.
	self assert: 1 equals: trashBox currentMessagesDirectory entries size.
]
