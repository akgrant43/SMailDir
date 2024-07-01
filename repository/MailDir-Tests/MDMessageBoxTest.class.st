Class {
	#name : #MDMessageBoxTest,
	#superclass : #MDTestCase,
	#instVars : [
		'addedMessageEntry'
	],
	#category : 'MailDir-Tests'
}

{ #category : #fixtures }
MDMessageBoxTest >> addNewMail [

	(boxDirectory / 'cur' / self addedMailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self addedMailFileContent].
]

{ #category : #fixtures }
MDMessageBoxTest >> addedMailFileContent [

	^ 'Delivered-To: patrick.rein@gmail.com
To: patrick.rein@gmail.com
Subject: Asd has invited you to join CDG Labs on Slack
Reply-To: asd@gmail.com
In-reply-to: <20141113225959.C20CD25738@slack-www140.tinyspeck.com>
From: "Slack" <feedback@slack.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="__slack_304307350__"
Message-Id: <20171113225959.C20CD25738@slack-www140.tinyspeck.com>
Date: Thu, 13 Nov 2017 14:59:59 -0800 (PST)
Sender: feedback@slack.com

--__slack_304307350__
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome again

you are doing just fine.

--__slack_304307350__--'
]

{ #category : #fixtures }
MDMessageBoxTest >> addedMailFileName [

	^ '81792873.1985_1.lovelace.staff.plugged.com.au;2,F'
]

{ #category : #fixtures }
MDMessageBoxTest >> addedMailMessageId [

	^ '<20171113225959.C20CD25738@slack-www140.tinyspeck.com>'
]

{ #category : #fixtures }
MDMessageBoxTest >> changeFlagsOfNewMail [

	(boxDirectory / 'cur' / self addedMailFileName) moveTo: (boxDirectory / 'cur' / self addedMailFileName allButLast)

]

{ #category : #tests }
MDMessageBoxTest >> testAddAnExistingMessage [

	| previousSize |
	previousSize := box2 mails size.

	box removeMail: messageEntry.
	box2 addMail: messageEntry.
	
	self assert: previousSize + 1 equals: box2 mails size.
	
]

{ #category : #tests }
MDMessageBoxTest >> testCreateNewSubbox [

	| subBox |

	box createSubBoxNamed: 'myNewSubBox'.
	subBox := archiveDirectory / (boxName , '.' , 'myNewSubBox').
	self assert: subBox isDirectory.
	#(cur new tmp) do: [ :each |
		self assert: (subBox / each) isDirectory ].
	self assert: box subBoxes size equals: 1.
]

{ #category : #tests }
MDMessageBoxTest >> testIsEmpty [
	
	self assert: box notEmpty.
	self assert: box2 notEmpty.
	self assert: trashBox isEmpty.
]

{ #category : #tests }
MDMessageBoxTest >> testRemoveMessage [

	box removeMail: messageEntry.
	
	self assert: 2 equals: box mails size.
]

{ #category : #tests }
MDMessageBoxTest >> testSetAllMailsRead [

	box setAllMailsRead.
	
	self assert: newMessageEntry hasBeenSeen.
	self assert: messageEntry hasBeenSeen.
	self assert: doubleMessageEntry hasBeenSeen. 
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationAddsNewMails [

	self addNewMail.
	archive synchronizeMessageEntries.
	addedMessageEntry := archive allMails detect: [:m | m messageId = self addedMailMessageId].
	self assert: addedMessageEntry isImportant.
	
	self changeFlagsOfNewMail.
	archive synchronizeMessageEntries.
	self assert: addedMessageEntry isImportant not.
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationMovesMovedFiles [

	"Move the file"
	messageEntry file copyTo: box2Directory / 'cur' / messageEntry file basename.
	messageEntry file delete.
	
	archive synchronizeMessageEntries.
	
	self assert: messageEntry equals: (archive allMails detect: [:m | m messageId = self mailMessageId]).
	self assert: box mails size equals: 2.
	self assert: box2 mails size equals: 2.
	self assert: (box2 mails includes: messageEntry).
	self assert: (messageEntry boxes includes: box2).
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationRemovesDeletedFiles [

	| tmpBox |
	tmpBox := messageEntry boxes first.
	messageEntry file delete.
	
	archive synchronizeMessageEntries.
	
	self assert: messageEntry boxes isEmpty.
	self assert: (tmpBox mails includes: messageEntry) not. 
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationRemovesEntryFromConversations [

	| tmpConversation |
	self assert: 1 equals: (MDMailConversation conversationsIn: {messageEntry}) size.
	tmpConversation := (MDMailConversation conversationsIn: {messageEntry}) asArray first.
	messageEntry file delete.
	
	archive synchronizeMessageEntries.
	
	self assert: (tmpConversation mails includes: messageEntry) not.
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationUpdatesConversations [

	| tmpConversation |
	self assert: 1 equals: (MDMailConversation conversationsIn: {messageEntry}) size.
	tmpConversation := (MDMailConversation conversationsIn: {messageEntry}) asArray first.

	self addNewMail.
	archive synchronizeMessageEntries.
	addedMessageEntry := archive allMails detect: [:m | m messageId = self addedMailMessageId].
	
	self assert: (tmpConversation mails includes: addedMessageEntry).
]

{ #category : #tests }
MDMessageBoxTest >> testSynchronizationUpdatesIfThereAreMultipleFilesForAMail [

	messageEntry file copyTo: box2Directory / 'cur' / messageEntry file basename.
	
	archive synchronizeMessageEntries.
	
	self assert: messageEntry equals: (archive allMails detect: [:m | m messageId = self mailMessageId]).
	self assert: box mails size equals: 3.
	self assert: box2 mails size equals: 2.
	self assert: (box2 mails includes: messageEntry).
	self assert: (box mails includes: messageEntry).
	self assert: {box . box2} asSet equals: messageEntry boxes asSet.
]
