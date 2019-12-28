mails
addMail: anEntry

	self mails add: anEntry.
	self mailArchive indexIntoMessageIdIndex: anEntry.
	self changed