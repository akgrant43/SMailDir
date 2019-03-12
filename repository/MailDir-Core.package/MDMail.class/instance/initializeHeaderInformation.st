initialize-release
initializeHeaderInformation

	header := self header.
	subject := header subject.
	date := header date.
	timestamp := header timestamp.
	recipients := header to.
	cc := header cc.
	messageId := header messageId.
	sender := header from.
	self initializeSenderName.
	header := nil. "To make space for other data"