initialize-release
initializeHeaderInformation

	header := self header.
	subject := self decodedHeaderField: 'Subject'.
	date := self timestampFrom: (header at: 'Date').
	recipients := self decodedHeaderField: 'To'.
	cc := self decodedHeaderField: 'Cc'.
	messageId := header at: 'Message-Id' ifAbsent: [].
	sender := self decodedHeaderField: 'From'.
	inReplyTo := header at: 'In-Reply-To' ifAbsent: [].
	self initializeSenderName.
	header := nil. "To make space for other data"