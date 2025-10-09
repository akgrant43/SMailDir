Class {
	#name : 'MDMailBox',
	#superclass : 'Object',
	#instVars : [
		'fileDirectory',
		'mailArchive',
		'subBoxes',
		'mails'
	],
	#category : 'MailDir-Core',
	#package : 'MailDir-Core'
}

{ #category : 'instance creation' }
MDMailBox class >> fromSton: stonReader [

	| mailBox |

	mailBox := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			mailBox perform: (key, ':') with: value ] ].
	^mailBox
]

{ #category : 'instance creation' }
MDMailBox class >> newFor: aFileDirectory in: aMailArchive [

	^ self new
		fileDirectory: aFileDirectory;
		mailArchive: aMailArchive;
		synchronizeSubBoxes;
		initializeMessageEntries;
		yourself		
]

{ #category : 'mails' }
MDMailBox >> addMail: anEntry [

	self mails add: anEntry.
	self mailArchive indexIntoMessageIdIndex: anEntry.
	self changed
]

{ #category : 'accessing' }
MDMailBox >> allBoxes [
	
	^ {self} , (self subBoxes gather: [:box | box allBoxes])
]

{ #category : 'mails' }
MDMailBox >> allMails [

	^ self mails , (self subBoxes gather: [:b | b allMails])
]

{ #category : 'mails' }
MDMailBox >> allMailsDo: aBlock [

	self mails do: aBlock.
	self subBoxes do: aBlock
]

{ #category : 'files' }
MDMailBox >> allMessageFileEntries [

	^ self newMessagesDirectory children , self currentMessagesDirectory children
	
]

{ #category : 'ston persistence' }
MDMailBox >> asStonDictionary [

	| dictionary |

	dictionary := Dictionary new.
	#(fileDirectory mailArchive subBoxes mails) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary
]

{ #category : 'accessing' }
MDMailBox >> boxName [

	^ (self fileDirectory basename findTokens: '.') last
]

{ #category : 'boxes' }
MDMailBox >> boxNamed: aRelativeBoxName [

	| boxNameParts |
	boxNameParts := aRelativeBoxName findTokens: '.'.
	boxNameParts size = 0 ifTrue: [^ self].
	^ (self subBoxes detect: [:b | b boxName = boxNameParts first]) boxNamed: (boxNameParts allButFirst joinSeparatedBy: '.')
]

{ #category : 'mails' }
MDMailBox >> conversations [

	^ MDMailConversation conversationsIn: self allMails
]

{ #category : 'boxes' }
MDMailBox >> createSubBoxNamed: aString [ 
	
	| directoryName boxDirectory |

	directoryName := self fullBoxName , '.' , aString.
	boxDirectory := self mailArchive fileDirectory / directoryName.
	boxDirectory ensureCreateDirectory.
	#(new cur tmp) do: [ :each | (boxDirectory / each) ensureCreateDirectory ].
	self synchronizeSubBoxes.
]

{ #category : 'files' }
MDMailBox >> currentMessagesDirectory [

	^ self fileDirectory / 'cur'
]

{ #category : 'accessing' }
MDMailBox >> fileDirectory [

	^ fileDirectory
]

{ #category : 'accessing' }
MDMailBox >> fileDirectory: anObject [

	fileDirectory := anObject
]

{ #category : 'files' }
MDMailBox >> fullBoxName [

	^ self fileDirectory basename
]

{ #category : 'inspector' }
MDMailBox >> gtInspectMessagesIn: composite [
	<gtInspectorPresentationOrder: 50> 

	^composite fastTable 
		title: 'Messages';
		display: [ self mails sorted: #date descending ];
		beMultiple;
		enableElementIndex;
		wantsAutomaticRefresh: true;
		column: 'From' evaluated: [ :mail | mail sender ];
		column: 'Date' evaluated: [ :mail | self humanDateStringFor: mail date ];
		column: 'Subject' evaluated: [ :mail | mail subject ];
		send: [ :result | 
			result isNil
				ifTrue: [ nil ]
				ifFalse: [ result size = 1 
					ifTrue: [result anyOne ]  
					ifFalse: [self species withAll: result]]]

]

{ #category : 'inspecting' }
MDMailBox >> gtMessagesFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Messages';
		  priority: 10;
		  items: [ self mails sorted: #date descending ];
		  column: 'From' text: [ :mail | mail sender ];
		  column: 'Date'
		  text: [ :mail | self humanDateStringFor: mail date ];
		  column: 'Subject' text: [ :mail | mail subject ];
		  send: [ :result | result ]
]

{ #category : 'inspector' }
MDMailBox >> humanDateStringFor: aDateAndTime [

	| localTime |

	localTime := aDateAndTime asLocal.
	^localTime asDate = Date today ifTrue: 
		[ String streamContents: [ :stream | localTime asTime
			print24: true showSeconds: false on: stream ] ]
	ifFalse:
		[ localTime asDate printFormat: #(1 2 3 $  2 1) ]
]

{ #category : 'initialize-release' }
MDMailBox >> initialize [

	self subBoxes: OrderedCollection new
]

{ #category : 'initialize-release' }
MDMailBox >> initializeMessageEntries [

	self 
		mails: OrderedCollection new;
		synchronizeOwnMessageEntries
	

]

{ #category : 'Rack' }
MDMailBox >> interactiveCreateSubBox [

	<rackOperationLabel: 'create box' inContextMenus: true>

	| boxName |
	boxName := UIManager default request: 'Please enter the box name'.
	boxName isEmptyOrNil ifTrue: [^ self].
	self createSubBoxNamed: boxName withBlanksTrimmed.
]

{ #category : 'Rack' }
MDMailBox >> interactiveSetAllMailsRead [

	<rackOperationLabel: 'set all as read' inContextMenus: true>

	self setAllMailsRead.
	
]

{ #category : 'Rack' }
MDMailBox >> interactiveSynchronize [

	<rackOperationLabel: 'synchronize' inContextMenus: true>

	[self mailArchive synchronize] forkAt: Processor userBackgroundPriority
]

{ #category : 'testing' }
MDMailBox >> isCollection [

	^ true
]

{ #category : 'testing' }
MDMailBox >> isEmail [

	^ false
]

{ #category : 'collection' }
MDMailBox >> isEmpty [

	^ self mails isEmpty and: [self subBoxes isEmpty]
]

{ #category : 'testing' }
MDMailBox >> isMailBox [

	^ true
]

{ #category : 'accessing' }
MDMailBox >> mailArchive [

	^ mailArchive
]

{ #category : 'accessing' }
MDMailBox >> mailArchive: anObject [

	mailArchive := anObject
]

{ #category : 'ui' }
MDMailBox >> mailListIcon [

	^ ToolIcons iconNamed: ((self allMails anySatisfy: [:m | m isUnread ])
		ifTrue: [#testOrange]
		ifFalse: [#blank])
]

{ #category : 'mails' }
MDMailBox >> mails [

	^ mails
]

{ #category : 'accessing' }
MDMailBox >> mails: anObject [

	mails := anObject
]

{ #category : 'files' }
MDMailBox >> newMessagesDirectory [

	^ self fileDirectory / 'new'
]

{ #category : 'collection' }
MDMailBox >> notEmpty [

	^ self isEmpty not
]

{ #category : 'Rack' }
MDMailBox >> openMailSorter [

	<rackOperationLabel: 'open mail sorter' inContextMenus: true>

	MDEmailSorter openOn: self mailArchive
]

{ #category : 'Rack' }
MDMailBox >> openRackStandardMorph [

	MDBoxBrowser openOnBox: self
]

{ #category : 'printing' }
MDMailBox >> printOn: aStream [

	^ aStream nextPutAll: self boxName
]

{ #category : 'mails' }
MDMailBox >> removeMail: anEntry [
	
	self mails remove: anEntry ifAbsent: [].
	
	self changed.
]

{ #category : 'mails' }
MDMailBox >> setAllMailsRead [

	(self allMails select: [:m | m isUnread ]) do: [:m | m setRead].
	self changed.
]

{ #category : 'ston persistence' }
MDMailBox >> stonOn: stonWriter [

	stonWriter writeObject: self streamShortList: [ :array |
		array add: self asStonDictionary ]
]

{ #category : 'mails' }
MDMailBox >> storeMail: aMailMessage [

	^ self mailArchive
		storeMail: aMailMessage
		in: self. 
]

{ #category : 'boxes' }
MDMailBox >> subBoxes [

	^ subBoxes
]

{ #category : 'accessing' }
MDMailBox >> subBoxes: anObject [

	subBoxes := anObject
]

{ #category : 'synchronization' }
MDMailBox >> synchronizeMessageEntries [

	self subBoxes do: [:b | b synchronizeMessageEntries].
	self synchronizeOwnMessageEntries.
	
]

{ #category : 'synchronization' }
MDMailBox >> synchronizeOwnMessageEntries [

	| currentFiles entriesToBeRemoved filesToBeAdded mailFiles rejectedEntries |
	currentFiles := self allMessageFileEntries asSet.
	mailFiles := (self mails copy collect: [:m | 
					m fileIn: self ifAbsent: [self mails remove: m. nil]]) asSet reject: #isNil.
	entriesToBeRemoved := mailFiles difference: currentFiles.
	filesToBeAdded := currentFiles difference: mailFiles.
	rejectedEntries := self mails select: [:m | entriesToBeRemoved includesAnyOf: m files ].
	
	self mailArchive protectIndexAccessDuring: [
		rejectedEntries do: [:e | e wasRemovedFrom: self].
		self mails: (self mails copyWithoutAll: rejectedEntries).
	
		filesToBeAdded do: [ :file | | entry |
			"A separate process might delete the file while we're processing"
			[ file size > 0 ifTrue: [ 
				entry := MDMail newAt: file in: self.
				(self mailArchive hasMessageEntryForId: entry messageId)
					ifTrue: [entry := self mailArchive messageEntryForId: entry messageId ifAbsent: [].
							entry wasMovedTo: self as: file.
							self addMail: entry]
					ifFalse: [self addMail: entry.
							self mailArchive indexEntry: entry]]]
				on: FileDoesNotExistException
				do: []]].

	Processor yield.
	self changed.

]

{ #category : 'synchronization' }
MDMailBox >> synchronizeSubBoxes [

	| allSubBoxNames namesOfDirectSubBoxes existingBoxes addedBoxNames removedBoxNames |
	
	allSubBoxNames := self mailArchive readBoxNames select: [:boxName | 
		(boxName splitOn: '.') beginsWith: (self fullBoxName splitOn: '.')].
	namesOfDirectSubBoxes := allSubBoxNames select: [:boxName | 
		((self fullBoxName splitOn: '.') size + 1) = (boxName splitOn: '.') size].
	namesOfDirectSubBoxes := namesOfDirectSubBoxes asSet.
	existingBoxes := (self subBoxes collect: [:box | box fullBoxName]) asSet.
	
	addedBoxNames := namesOfDirectSubBoxes difference: existingBoxes.
	removedBoxNames := existingBoxes difference: namesOfDirectSubBoxes.

	self subBoxes addAll: (addedBoxNames collect: 
		[:boxName | MDMailBox 
						newFor: self fileDirectory parent / boxName 
						in: self mailArchive]).
	self subBoxes removeAllFoundIn: (self subBoxes select: [:b | removedBoxNames includes: b fullBoxName]).
	self flag: #TODO. "In a second round we should also look into the directory to see if there are any other folders besides the maildir ones. And also remove the removed boxes... --pre".
	
	self changed.
]

{ #category : 'Rack' }
MDMailBox >> worldIconMorph [

	^ ((RIcons icons8Inbox64px2Icon) scaledToSize: 35@35) asMorph
]

{ #category : 'Rack' }
MDMailBox >> worldIconText [

	^ self mailArchive archiveName , ' ' , self boxName , String crlf , 
		(self mails count: [:m | m isUnread]) asString , ' unread'
]
