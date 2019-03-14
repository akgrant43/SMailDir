accessing
testHeaderIsAlreadyIncluded

	self assert: messageEntry subject equals: 'editable views | Access to project was granted'.
	self assert: messageEntry sender equals: 'GitLab <gitlab@gitlab.com>'.
	self assert: messageEntry recipients equals: 'patrick.rein@gmail.com'.
	self assert: messageEntry date equals: (DateAndTime year: 2014 month: 11 day: 13 hour: 23 minute: 51 second: 40 offset: 0 hours).
	self assert: self mailMessageId equals: messageEntry messageId.
	self assert: messageEntry cc equals: ''