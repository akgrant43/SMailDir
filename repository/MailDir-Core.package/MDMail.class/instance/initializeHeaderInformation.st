initialize-release
initializeHeaderInformation

	header := self header.
	subject := header subject.
	timestamp := header timestamp.
	recipients := header to.
	cc := header cc.
	messageId := header messageId.
	sender := header from.
	inReplyTo := header inReplyTo.
	self initializeSenderName.
	header := nil. "To make space for other data"