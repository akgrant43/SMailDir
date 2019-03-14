running
setUp

	| new cur |

	super setUp.
	testDirectory := (FileLocator temp / self directoryForTestName) resolve.
	testDirectory createDirectory.

	archiveName := 'MailDirTests'.
	archiveDirectory := testDirectory / archiveName.
	archiveDirectory createDirectory.
	
	boxName := 'MailDirBox'.
	boxDirectory := archiveDirectory / boxName.
	boxDirectory createDirectory. 
	new := boxDirectory / 'new'.
	new createDirectory.
	cur := boxDirectory / 'cur'.
	cur createDirectory.
	(boxDirectory / 'tmp') createDirectory.

	(new / self newMailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self newMailFileContent ].
	(cur / self mailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self mailFileContent ].
	(cur / self doubleMailFileName1) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self doubleMailFileContent ].
	
	box2Name := 'MailDirBox2'.
	box2Directory := archiveDirectory / box2Name.
	box2Directory createDirectory.
	new := box2Directory / 'new'.
	new createDirectory.
	cur := box2Directory / 'cur'.
	cur createDirectory.
	(box2Directory / 'tmp') createDirectory.
	
	(cur / self doubleMailFileName2) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self doubleMailFileContent ].
	
	trashBoxName := 'MailDirTrash'.
	trashBoxDirectory := archiveDirectory / trashBoxName.
	trashBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (trashBoxDirectory / each) createDirectory ].

	archiveBoxName := 'MailBoxArchive'.
	archiveBoxDirectory := archiveDirectory / archiveBoxName.
	archiveBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (archiveBoxDirectory / each) createDirectory ].

	sentBoxName := 'MailBoxSent'.
	sentBoxDirectory := archiveDirectory / sentBoxName.
	sentBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (sentBoxDirectory / each) createDirectory ].

	archive := MDMailArchive archiveIn: archiveDirectory flagSeparator: $;.
	archive trashBoxName: trashBoxName.
	archive archiveBoxName: archiveBoxName.
	archive sentBoxName: sentBoxName.
	box := archive boxes detect: [:b | b fileDirectory = boxDirectory].
	box2 := archive boxes detect: [:b | b fileDirectory = box2Directory].
	trashBox := archive boxes detect: [:b | b fileDirectory = trashBoxDirectory].
	archiveBox := archive boxes detect: [:b | b fileDirectory = archiveBoxDirectory].
	sentBox := archive boxes detect: [:b | b fileDirectory = sentBoxDirectory].
	
	messageEntry := archive allMails detect: [:m | m messageId = self mailMessageId].
	newMessageEntry := archive allMails detect: [:m | m messageId = self newMailMessageId].
	doubleMessageEntry := archive allMails detect: [:m | m messageId = self doubleMailMessageId].