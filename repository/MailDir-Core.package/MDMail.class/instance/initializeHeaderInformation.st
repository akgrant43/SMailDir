initialize-release
initializeHeaderInformation

	header := self header.
	subject := self decodedHeaderField: 'Subject'.
	date := self timestampFrom: (header at: 'Date').
	recipients := header at: 'To' ifAbsent: [].
	cc := header at: 'Cc' ifAbsent: [].
	messageId := header at: 'Message-Id' ifAbsent: [].
	sender := header at: 'From'.
	inReplyTo := header at: 'In-Reply-To' ifAbsent: [].
	self initializeSenderName.
	header := nil. "To make space for other data"