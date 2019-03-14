tests
testConversationProperties
	
	| conversation |
	conversation := archive conversationForId: messageEntry messageId ifAbsent: [].
	
	self 
		assert: conversation subject equals: 'editable views | Access to project was granted';
		assert: conversation sender equals: 'GitLab <gitlab@gitlab.com>';
		assert: conversation isImportant;
		assert: conversation senderNames equals: 'Slack, GitLab';
		assert: conversation senderName equals: 'GitLab'
		
	