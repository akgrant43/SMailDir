"
An MDMail represents an abstract email which is stored in a maildir structure. It can be stored in multiple files which themselves are stored in multiple boxes (e.g. when boxes represent GMail tags).

The interface for managing the MDMails is separated into two categories:

1.) Public messages (#moveTo:, #moveToTrash, #moveToArchive) which can be used by the user to move the mail around. They take care of synchronizing the object graph with the directory structure.

2.) Public messages (#wasMovedTo:, #addBox:with:, #wasRemovedFrom:) which are used by the MailDir synchronization infrastructure to update the object graph on a change in the file system. 

## Implementation notes
While conceptually all data is always read from disk, this quickly becomes infeasible regarding response times. Thus, most of the meta information about the message (recipient, subject, date, read status, important flag, ...) are cached in instance variables. While most message properties do not change, special attention has to be given to the flags caching.
"
Class {
	#name : 'MDMail',
	#superclass : 'Object',
	#instVars : [
		'header',
		'subject',
		'sender',
		'senderAddress',
		'senderName',
		'recipients',
		'messageId',
		'cc',
		'hasBeenSeen',
		'isImportant',
		'fileAccessMutex',
		'entries',
		'mailArchive',
		'inReplyTo',
		'date'
	],
	#classVars : [
		'FileNameCounter'
	],
	#category : 'MailDir-Core',
	#package : 'MailDir-Core'
}

{ #category : 'caching' }
MDMail class >> clearHeaders [

	self allInstancesDo: [:m | m header: nil]
]

{ #category : 'instance creation' }
MDMail class >> fromSton: stonReader [

	| mail |

	mail := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			mail perform: (key, ':') with: value ] ].
	^mail
]

{ #category : 'instance creation' }
MDMail class >> newAt: file in: aBox [

	^ self new
		addBox: aBox with: file;
		initializeHeaderInformation;
		yourself
]

{ #category : 'instance creation' }
MDMail class >> newFor: aMailMessage in: aBox [
	
	^ self new
		addBox: aBox with: nil;
		initializeFileFor: aMailMessage;
		initializeHeaderInformation;
		yourself
]

{ #category : 'flags' }
MDMail >> = anotherMail [

	^ anotherMail isEmail and: [self messageId = anotherMail messageId]
]

{ #category : 'private' }
MDMail >> addBox: aBox with: aFile [

	mailArchive := aBox mailArchive. "This is only necessary as a performance improvement. --pre"
	^ self entries at: aBox put: aFile
]

{ #category : 'flags' }
MDMail >> addOrdinaryFlag: aCharacter [

	(self flags includes: aCharacter) ifTrue: [^ self]. 
	
	^ self modifyFlags: [:flags | flags asSet , {aCharacter}]
]

{ #category : 'ston persistence' }
MDMail >> asStonDictionary [

	| dictionary |

	dictionary := Dictionary new.
	#(subject sender senderAddress senderName recipients date messageId cc entries mailArchive inReplyTo) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary
]

{ #category : 'private' }
MDMail >> boxes [
	
	^ self entries keys
]

{ #category : 'meta information' }
MDMail >> cc [

	^ cc
]

{ #category : 'ston persistence' }
MDMail >> cc: aString [

	cc := aString
]

{ #category : 'updating' }
MDMail >> changed [

	super changed.
	^ self boxes do: [:b | b changed]
]

{ #category : 'accessing' }
MDMail >> conversation [

	^ self mailArchive conversationForId: self messageId ifAbsent: []
]

{ #category : 'files' }
MDMail >> copyFileTo: aBox [

	| directory newFile |	
	directory := self hasBeenRead
		ifTrue: [aBox currentMessagesDirectory]
		ifFalse: [aBox newMessagesDirectory].
	newFile := directory / self file basename.
	newFile exists
		ifFalse: [self file copyTo: newFile].

	^ newFile
]

{ #category : 'accessing structure variables' }
MDMail >> date [
	"Answer a DateAndTime for the receiver"

	^date
]

{ #category : 'ston persistence' }
MDMail >> date: aDateAndTime [

	date := aDateAndTime
]

{ #category : 'private' }
MDMail >> decodedHeaderField: fieldName [
	"Answer the header field decoded as a Mime Encoded-Word.
	The header must have been already cached."

	| values value |

	values := header at: fieldName ifAbsent: [ ^nil ].
	value := values isString 
		ifTrue: [ values ]
		ifFalse: [ ', ' join: values ].
	^MimeEncodedWord decodeString: value trimBoth.
]

{ #category : 'private' }
MDMail >> entries [
	
	^ entries
]

{ #category : 'private' }
MDMail >> entries: aDictionary [

	entries := aDictionary
]

{ #category : 'files' }
MDMail >> file [

	^ self files first
]

{ #category : 'files' }
MDMail >> fileIn: aBox [

	^ self entries at: aBox
]

{ #category : 'files' }
MDMail >> fileIn: aBox ifAbsent: aBlock [

	^ self entries at: aBox ifAbsent: aBlock
]

{ #category : 'private' }
MDMail >> files [
	
	^ self entries values
]

{ #category : 'flags' }
MDMail >> flagSeparator [

	^ self mailArchive flagSeparator
]

{ #category : 'flags' }
MDMail >> flags [

	"The following code is a performance optimization as this method gets called a LOT
	as it influences the mail icons. --pre"
	| fileName fileNameSize flagSeparatorIndex normalFlagIndex |
	fileName := self file basename.
	fileNameSize := fileName size.
	flagSeparatorIndex := fileName indexOf: self flagSeparator asCharacter startingAt: (fileNameSize - 10). 
	normalFlagIndex := fileName indexOf: $2 startingAt: flagSeparatorIndex.
	
	"We add two to the index to skip the $2 and the $, characters --pre"
	^ fileName copyFrom: normalFlagIndex + 2 to: fileNameSize
]

{ #category : 'private' }
MDMail >> generateFileNameFor: aMessage [

	^ String streamContents: [ :stream | stream
		print:	DateAndTime now asUnixTime;
		<< '_';
		print: self nextFileNameCounter;
		<< '.';
		print: LibC uniqueInstance currentProcessId;
		<< '.';
		<< NetNameResolver localHostName;
		<< ',U=123456'; "To signal the synchronization process that this is a new email --pre"
		<< ',FMD5=123456'; "Also to signal the synchronization process that this is a new email --pre"
		nextPut: self mailArchive flagSeparator;
		<< '2,' ]
]

{ #category : 'inspecting' }
MDMail >> gtAttachmentsFor: aView [
	<gtView>

	^ aView forward
		title: 'Attachments';
		priority: 15;
		object: [ (AkgMdMailVisitor new visitNode: self) attachments ];
		view: #gtLiveFor:
]

{ #category : 'inspecting' }
MDMail >> gtHeadersFor: aView [
	<gtView>

	^ aView forward
		title: 'Headers';
		priority: 20;
		object: [ self header ];
		view: #gtHeadersFor:
]

{ #category : 'inspecting' }
MDMail >> gtInspectConversationIn: composite [
	<gtInspectorPresentationOrder: 7>

	self conversation ifNotNil: [ :conv |
		(conv gtInspectMessagesIn: composite)
			title: 'Conversation' ]
]

{ #category : 'inspecting' }
MDMail >> gtInspectMessageIn: composite [
	<gtInspectorPresentationOrder: 5>

	self file exists ifTrue: 
		[ (self message gtInspectPayloadIn: composite)
			title: 'Message' ]
]

{ #category : 'inspecting' }
MDMail >> gtMessageFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Message';
		priority: 10;
		text: [ (AkgMdMailVisitor new visitNode: self) text ]
]

{ #category : 'meta information' }
MDMail >> hasBeenRead [
	
	^ self hasBeenSeen
]

{ #category : 'meta information' }
MDMail >> hasBeenSeen [
	
	hasBeenSeen ifNil: [hasBeenSeen := self flags includes: $S].
	^ hasBeenSeen
]

{ #category : 'accessing' }
MDMail >> header [
	"Read the header records from the receiver's file.
	Don't cache to reduce memory."

	"thisContext sender selector = #initializeHeaderInformation ifFalse: [ self halt ]."
	^self file binaryReadStreamDo: [ :bstream |
		ZnHeaders readFrom: (AkgMimeStream on: bstream) ].

"	^ header ifNil: [ | stream result line |
		self file readStreamDo: [ :rstream |
			stream := ZnFastLineReader on: rstream.
			result := String streamContents: [ :sstream |
				line := stream nextLine trimLeft.
				[ line isEmpty ] whileFalse:
					[ sstream 
						nextPutAll: line;
						cr.
					line := stream nextLine trimLeft ] ].
			header := MailMessage from: result ] ].
"
]

{ #category : 'accessing' }
MDMail >> header: anObject [

	header := anObject
]

{ #category : 'accessing' }
MDMail >> inReplyTo [

	^inReplyTo
]

{ #category : 'ston persistence' }
MDMail >> inReplyTo: messageIdString [

	inReplyTo := messageIdString
]

{ #category : 'initialize-release' }
MDMail >> initialize [

	super initialize.
	
	self entries: IdentityDictionary new.
	fileAccessMutex := Mutex new.
]

{ #category : 'initialize-release' }
MDMail >> initializeFileFor: aMessage [

	| fileName folder |
	self assert: self boxes size = 1.
	folder := self boxes first currentMessagesDirectory.
	fileName := folder / (self generateFileNameFor: aMessage).
	fileName writeStreamEncoded: 'null' do: [ :stream |
		stream << aMessage asSendableText].
	self addBox: self boxes first with: fileName
]

{ #category : 'initialize-release' }
MDMail >> initializeHeaderInformation [

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
]

{ #category : 'initialize-release' }
MDMail >> initializeSenderName [

	| nameAndAddress |
	sender isEmptyOrNil ifTrue: [^ senderName := 'unkown'].
	[nameAndAddress := (MailAddressParser addressesAndNamePairsIn: sender) first ]
		on: Error
		do: [:e | senderName := 'unretrievable'. ^ self].
	senderName := nameAndAddress first
		ifEmpty: [nameAndAddress second]
		ifNotEmpty: [nameAndAddress first].
	senderAddress := nameAndAddress second
]

{ #category : 'Rack' }
MDMail >> interactiveArchiveMessage [

	<rackOperationLabel: 'archive message' inContextMenus: true>
	
	self moveToArchive
]

{ #category : 'Rack' }
MDMail >> interactiveToggleReadMessage [

	<rackOperationLabel: 'toggle read status' inContextMenus: true>
	
	self hasBeenRead
		ifTrue: [self setUnread]
		ifFalse: [self setRead]
]

{ #category : 'Rack' }
MDMail >> interactiveTrashMessage [

	<rackOperationLabel: 'move to trash' inContextMenus: true>
	
	self moveToTrash
]

{ #category : 'private' }
MDMail >> isAlreadyInBox: targetBox [
	
	^ (self boxes includes: targetBox) and: [targetBox mails includes: self]
]

{ #category : 'testing' }
MDMail >> isDeletedFromSystem [
	
	^ self entries isEmpty
]

{ #category : 'testing' }
MDMail >> isEmail [

	^ true
]

{ #category : 'meta information' }
MDMail >> isImportant [
	
	isImportant ifNil: [isImportant := self flags includes: $F].
	^ isImportant
	
]

{ #category : 'testing' }
MDMail >> isStoredInAnyBox [

	^ self entries notEmpty
]

{ #category : 'meta information' }
MDMail >> isUnread [

	^ self hasBeenRead not
]

{ #category : 'accessing' }
MDMail >> mailArchive [

	^ mailArchive ifNil: ["This is only necessary as a performance improvement. --pre"
		mailArchive := self boxes first mailArchive]
]

{ #category : 'ston persistence' }
MDMail >> mailArchive: anArchive [

	mailArchive := anArchive
]

{ #category : 'ui' }
MDMail >> mailListIcon [

	^ ToolIcons iconNamed: 
		(self isUnread ifTrue: [#testOrange] ifFalse: [#blank])
]

{ #category : 'mails' }
MDMail >> message [
	"Answer the MIME document of the receiver.
	Emails should assume ascii as the default encoding."
	| options |

	options := ZnOptions root clone
		at: #maximumEntitySize put: 2 ** 26 "64MB";
		yourself.
	^ self file binaryReadStreamDo: [ :bstream |
		ZnCurrentOptions
			value: options
			during: 
				[ ZnDefaultCharacterEncoder 
					value: (ZnCharacterEncoder newForEncoding: #'null')
					during: [ ZnMimePart readFrom: (AkgMimeStream on: bstream) ] ] ].

]

{ #category : 'meta information' }
MDMail >> messageId [

	^ messageId
]

{ #category : 'ston persistence' }
MDMail >> messageId: aString [

	messageId := aString
]

{ #category : 'flags' }
MDMail >> modifyFlags: aBlock [

	| messageParts fileName flags flagsString flagParts |
	self entries: (self entries collect: [:aFile | 
		messageParts := aFile basename findTokens: self flagSeparator. 
		flagParts := (messageParts last splitOn: '2,') asOrderedCollection.
		flagParts size = 1 ifTrue: [flagParts add: ''].
		flags := flagParts last.
	
		flags := aBlock value: flags.

		flagsString := self flagSeparator asString 
			, ('' join: flagParts allButLast) 
			, '2,' 
			, (String newFrom: flags sorted). 
	
		fileName := '' join: (messageParts allButLast , flagsString).
	
		self renameFile: aFile to: (aFile parent / fileName)])
	
]

{ #category : 'files' }
MDMail >> moveFile: aFile within: aBox [

	| directory |
	aFile parent parent ~= aBox fileDirectory
		ifTrue: [^ self error: 'This method is only applicable for moving between cur and new folders'].
	
	directory := self hasBeenRead
		ifTrue: [aBox currentMessagesDirectory]
		ifFalse: [aBox newMessagesDirectory].
	^ self renameFile: aFile to: (directory / self file basename).
]

{ #category : 'mails' }
MDMail >> moveTo: targetBox [
	"Moves the mail message completely to the new folder"

	fileAccessMutex critical: [ | newFile |	
		(self isAlreadyInBox: targetBox)
			ifTrue: [newFile := self entries at: targetBox]
			ifFalse: [newFile := self copyFileTo: targetBox].

		self boxes do: [:b | b removeMail: self].
		(self files copyWithout: newFile) do: [:f | 
			[ f delete ]
				on: FileDoesNotExistException
				do: [] ].
		self entries removeAll.
		targetBox addMail: self.
		self addBox: targetBox with: newFile]
]

{ #category : 'mails' }
MDMail >> moveToArchive [

	self moveTo: self mailArchive archiveBox
]

{ #category : 'mails' }
MDMail >> moveToTrash [
	
	self moveTo: self mailArchive trashBox
]

{ #category : 'private' }
MDMail >> nextFileNameCounter [
	"Increment and answer the filename counter"

	FileNameCounter ifNil: [ FileNameCounter := 0 ].
	^FileNameCounter := FileNameCounter + 1.
	
]

{ #category : 'Rack' }
MDMail >> openRackStandardMorph [

	self setRead.
	^ self message openRackStandardMorph.
]

{ #category : 'printing' }
MDMail >> printOn: aStream [
	
	self printSenderNameOn: aStream.
	aStream tab.
	self printSubjectOn: aStream.

]

{ #category : 'printing' }
MDMail >> printSenderNameOn: aStream [

	| max |
	max := 45.
	aStream nextPutAll:  
		(self senderName size > max
			ifFalse: [self senderName]
			ifTrue: [(String streamContents: [:s | s nextPutAll: self senderName] limitedTo: max-2),'..'])
]

{ #category : 'printing' }
MDMail >> printSenderOn: aStream [

	| max |
	max := 30.
	aStream nextPutAll:  
		(self sender size > max
			ifFalse: [self sender]
			ifTrue: [(String streamContents: [:s | s nextPutAll: self sender] limitedTo: max-2),'..'])
]

{ #category : 'printing' }
MDMail >> printSubjectOn: aStream [

	| max |
	subject ifNil: 
		[ aStream << '(no subject)' ]
	ifNotNil:
		[ max := 72.
		aStream nextPutAll:  
			(self subject size > max
				ifFalse: [self subject]
				ifTrue: [(String streamContents: [:s | s nextPutAll: self subject] limitedTo: max-2),'..']) ]
]

{ #category : 'meta information' }
MDMail >> recipients [

	^ recipients
]

{ #category : 'ston persistence' }
MDMail >> recipients: aString [

	recipients := aString
]

{ #category : 'flags' }
MDMail >> removeOrdinaryFlag: aCharacter [

	(self flags includes: aCharacter) ifFalse: [^ self]. 
	
	^ self modifyFlags: [:flags | flags asSet copyWithout: aCharacter]
]

{ #category : 'files' }
MDMail >> renameFile: fromFileReference to: toFileReference [
	"Rename aFile to fileName"
	fileAccessMutex critical: [
		toFileReference exists ifFalse:
			[ fromFileReference copy moveTo: toFileReference ] ].
	^toFileReference 
]

{ #category : 'private' }
MDMail >> resetFlagsCaches [

	isImportant := hasBeenSeen := nil
]

{ #category : 'meta information' }
MDMail >> sender [

	^ sender 
]

{ #category : 'ston persistence' }
MDMail >> sender: aString [

	sender := aString
]

{ #category : 'meta information' }
MDMail >> senderAddress [

	senderAddress ifNil: [self initializeSenderName].
	^ senderAddress
]

{ #category : 'ston persistence' }
MDMail >> senderAddress: aString [

	senderAddress := aString
]

{ #category : 'meta information' }
MDMail >> senderName [

	senderName ifNil: [self initializeSenderName].
	^ senderName
]

{ #category : 'ston persistence' }
MDMail >> senderName: aString [

	senderName := aString
]

{ #category : 'meta information' }
MDMail >> setImportant [
	
	isImportant := true.
	self addOrdinaryFlag: $F.
	
	self changed.
]

{ #category : 'meta information' }
MDMail >> setRead [
	
	hasBeenSeen := true.
	self addOrdinaryFlag: $S.
	
	(self entries associations select: [:assoc | 
		| file box |
		box := assoc key.
		file := assoc value.
		file parent ~= box currentMessagesDirectory]) do: [:assoc | | newFile |
		     newFile := self moveFile: assoc value within: assoc key.
			self entries at: assoc key put: newFile].
	
	self changed.
]

{ #category : 'meta information' }
MDMail >> setUnimportant [
	
	isImportant := false.
	self removeOrdinaryFlag: $F.
	
	self changed.
]

{ #category : 'meta information' }
MDMail >> setUnread [
	
	hasBeenSeen := false.
	self removeOrdinaryFlag: $S.
	
	(self entries associations select: [:assoc | 
		| file box |
		box := assoc key.
		file := assoc value.
		file parent ~= box newMessagesDirectory]) do: [:assoc | | newFile |
		     newFile := self moveFile: assoc value within: assoc key.
			self entries at: assoc key put: newFile].
	
	self changed.
]

{ #category : 'ston persistence' }
MDMail >> stonOn: stonWriter [

	stonWriter writeObject: self streamShortList: [ :array |
		array add: self asStonDictionary ]
]

{ #category : 'meta information' }
MDMail >> subject [

	^ subject
]

{ #category : 'ston persistence' }
MDMail >> subject: aString [

	subject := aString
]

{ #category : 'private' }
MDMail >> timestampFrom: aString [
	"Answer a DateAndTime from aString"

	| regex dateString tsDate tsTime offsetString offset minutes |

	dateString := aString.
	regex := '(\d\d? \w\w\w \d\d\d\d) (\d\d?\:\d\d\:\d\d)\s?([-+]\d\d\d\d|GMT)?' asRegex.
	(regex search: dateString) ifFalse: [ self error: 'Unable to parse date' ].
	tsDate := Date readFrom: (regex subexpression: 2) readStream.
	tsTime := Time readFrom: (regex subexpression: 3) readStream.
	offsetString := regex subexpression: 4.
	
	minutes := (offsetString isNil or: [ offsetString = 'GMT']) ifTrue:
		[ 0 ]
	ifFalse:
		[ ((((offsetString second codePoint - 16r30) * 10) +
			(offsetString third codePoint - 16r30)) * 60 +
			(((offsetString fourth codePoint - 16r30) * 10) +
			(offsetString fifth codePoint - 16r30))) *
			(offsetString first = $- ifTrue: [ -1 ] ifFalse: [ 1 ]) ].
	offset := Duration minutes: minutes. 
 	^DateAndTime
		year: tsDate year
		month: tsDate monthName
		day: tsDate dayOfMonth
		hour: tsTime hour
		minute: tsTime minute 
		second: tsTime second 
		nanoSecond: 0
		offset: offset.
]

{ #category : 'private' }
MDMail >> wasMovedTo: aBox as: aFile [

	fileAccessMutex critical: [
		self resetFlagsCaches.
		self addBox: aBox with: aFile] 
]

{ #category : 'private' }
MDMail >> wasRemovedFrom: aBox [

	fileAccessMutex critical: [
		self entries removeKey: aBox 
			ifAbsent: [Transcript showln: 'Tried to remove message ' , self messageId ,
						' from a folder it was not in ' , aBox fileDirectory fullName]].
]

{ #category : 'Rack' }
MDMail >> worldIconMorph [
	| icon |
	icon := self hasBeenRead
		ifTrue: [RIcons icons8ReadMessage64px1Icon]
		ifFalse: [RIcons icons8Message64px1Icon].
	^ (icon scaledToSize: 35@35) asMorph
]

{ #category : 'Rack' }
MDMail >> worldIconText [

	^ self subject
]
