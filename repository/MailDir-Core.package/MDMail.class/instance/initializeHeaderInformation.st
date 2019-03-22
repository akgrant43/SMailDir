initialize-release
initializeHeaderInformation

	header := self header.
	subject := self decodedHeaderField: 'Subject'.
	date := self timestampFrom: (header at: 'Date').
	recipients := self decodedHeaderField: 'To'.
	cc := self decodedHeaderField: 'Cc'.
	messageId := self decodedHeaderField: 'Message-Id'.
	sender := self decodedHeaderField: 'From'.
	inReplyTo := self decodedHeaderField: 'In-Reply-To'.
	self initializeSenderName.
	header := nil. "To make space for other data"