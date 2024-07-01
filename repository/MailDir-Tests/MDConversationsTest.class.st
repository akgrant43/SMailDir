Class {
	#name : #MDConversationsTest,
	#superclass : #MDTestCase,
	#category : 'MailDir-Tests'
}

{ #category : #tests }
MDConversationsTest >> testArchiveConversations [

	| conversations |
	conversations := MDMailConversation conversationsIn: box mails.
	
	conversations do: [:c | c moveToArchive].
	
	self assert: 3 equals: archiveBox mails size.
	self assert: 3 equals: (archiveBox currentMessagesDirectory entries , archiveBox newMessagesDirectory entries) size.
	self assert: 1 equals: doubleMessageEntry files size
		
]

{ #category : #tests }
MDConversationsTest >> testConversationProperties [
	
	| conversation |
	conversation := archive conversationForId: messageEntry messageId ifAbsent: [].
	
	self 
		assert: conversation subject equals: 'editable views | Access to project was granted';
		assert: conversation sender equals: 'GitLab <gitlab@gitlab.com>';
		assert: conversation isImportant;
		assert: conversation senderNames equals: 'Slack, GitLab';
		assert: conversation senderName equals: 'GitLab'
		
	
]

{ #category : #tests }
MDConversationsTest >> testConversationReadStatus [

	| conversation |
	conversation := archive conversationForId: messageEntry messageId ifAbsent: [].
	
	conversation setUnread.
	self assert: conversation isUnread.
	
	conversation setRead.
	self assert: conversation hasBeenRead.
]

{ #category : #tests }
MDConversationsTest >> testGetConversations [
	| conversations |

	conversations := MDMailConversation conversationsIn: box mails.
	
	self assert: conversations anyOne notEmpty.
	self assert: 2 equals: conversations size.
	conversations do: [:c |
		{messageEntry . doubleMessageEntry} includes: c startMail]
	
]

{ #category : #tests }
MDConversationsTest >> testMoveConversations [

	| conversations mailsOfBox2 |
	mailsOfBox2 := box2 mails.
	conversations := MDMailConversation conversationsIn: box2 mails.
	
	conversations do: [:c | c moveTo: box].
	
	self assert: box2 isEmpty.
	mailsOfBox2 do: [:m |
		self assert: 1 equals: m files]
]

{ #category : #tests }
MDConversationsTest >> testRemoveAnEntry [

	| conversation |
	conversation := (MDMailConversation conversationsIn: {newMessageEntry}) anyOne. 
	
	conversation removeMail: newMessageEntry.
	
	self shouldnt: (conversation includes: newMessageEntry).
	
]

{ #category : #tests }
MDConversationsTest >> testRemoveStartMailOfFilledConversation [

	| conversation |
	conversation := (MDMailConversation conversationsIn: {messageEntry}) anyOne. 
	
	conversation removeMail: messageEntry.
	
	self 
		shouldnt: (conversation includes: messageEntry);
		should: conversation startMail = newMessageEntry.
	
]

{ #category : #tests }
MDConversationsTest >> testTrashConversations [

	| conversations |
	conversations := MDMailConversation conversationsIn: box mails.
	
	conversations do: [:c | c moveToTrash].
	
	self assert: 3 equals: trashBox mails size.
	self assert: 3 equals: (trashBox currentMessagesDirectory entries , trashBox newMessagesDirectory entries) size.
	self assert: 1 equals: doubleMessageEntry files size
		
]
