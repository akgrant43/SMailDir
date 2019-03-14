fixtures
addNewMail

	(boxDirectory / 'cur' / self addedMailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self addedMailFileContent].