Class {
	#name : #MDMailArchive,
	#superclass : #Object,
	#instVars : [
		'fileDirectory',
		'boxes',
		'mailIdIndex',
		'conversationIndex',
		'flagSeparator',
		'archiveName',
		'trashBoxName',
		'archiveBoxName',
		'sentBoxName',
		'draftsBoxName',
		'inBoxName',
		'indexSemaphore'
	],
	#category : 'MailDir-Core'
}

{ #category : #'instance creation' }
MDMailArchive class >> archiveIn: aFileDirectory [

	^ self archiveIn: aFileDirectory flagSeparator: nil

]

{ #category : #'instance creation' }
MDMailArchive class >> archiveIn: aFileDirectory flagSeparator: aString [

	^ self new
		flagSeparator: aString;
		fileDirectory: aFileDirectory;
		initializeBoxes;
		indexConversations;
		yourself
]

{ #category : #'instance creation' }
MDMailArchive class >> fromFile: aFileReference [

	| index |

	index := aFileReference asFileReference binaryReadStreamDo: [ :bstream |
		STON fromStream: (ZnCharacterReadStream 
			on: (GZipReadStream on: bstream)
			encoding: 'utf8') ].
	^index
]

{ #category : #'instance creation' }
MDMailArchive class >> fromSton: stonReader [

	| archive |

	archive := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			archive perform: (key, ':') with: value ] ].
	^archive
]

{ #category : #private }
MDMailArchive class >> rebuildAllInstances [

	"MDMailArchive rebuildAllInstances"

	MDMailArchive allInstancesDo: [:a | 
		a
			initialize;
			initializeBoxes;
			indexConversations].
		
	MDMail clearHeaders.
]

{ #category : #synchronization }
MDMailArchive class >> startSynchronizationProcess [

	[[self synchronizeAllArchives. 
	  (Delay forSeconds: self synchronizationProcessPeriod asSeconds) wait] repeat] 
		forkAt: 30 named: 'mail dir synchronization process'
]

{ #category : #synchronization }
MDMailArchive class >> synchronizationProcessPeriod [

	^ 3 minutes
]

{ #category : #synchronization }
MDMailArchive class >> synchronizeAllArchives [

	self allInstances do: [:a | | inboxSize inbox |
		a synchronizeBoxes.
		inbox := a boxes detect: [:b | b boxName = 'INBOX'].
		inboxSize := (inbox mails select: [:m | m isUnread]) size .
		a synchronizeMessageEntries.
		(inbox mails select: [:m | m isUnread]) size > inboxSize
			ifTrue: [SampledSound playSoundNamed: 'croak']]
]

{ #category : #boxes }
MDMailArchive >> addBox: aBox named: aRelativeBoxName [

	^ self boxes at: aRelativeBoxName put: aBox
]

{ #category : #'initialize-release' }
MDMailArchive >> addBoxesWithNames: rootBoxNames [

	rootBoxNames do: [ :dirName | | rootBoxName rootBox |
		rootBoxName := (dirName findTokens: '.') last.
		rootBox := MDMailBox newFor: self fileDirectory / dirName in: self.
		self addBox: rootBox named: rootBoxName]
	
	
]

{ #category : #boxes }
MDMailArchive >> allBoxes [

	^ self boxes gather: [:box | box allBoxes]
]

{ #category : #accessing }
MDMailArchive >> allMails [

	^ self boxes gather: [:b | b allMails]
]

{ #category : #accessing }
MDMailArchive >> allMailsDo: aBlock [

	self boxes do: [ :box | box allMailsDo: aBlock]
]

{ #category : #accessing }
MDMailArchive >> archiveBox [

	self archiveBoxName isEmptyOrNil ifTrue: [^ nil].
	^ self boxNamed: self archiveBoxName
]

{ #category : #accessing }
MDMailArchive >> archiveBoxName [

	^ archiveBoxName
]

{ #category : #accessing }
MDMailArchive >> archiveBoxName: aString [

	archiveBoxName := aString
]

{ #category : #accessing }
MDMailArchive >> archiveName [

	^ archiveName
]

{ #category : #accessing }
MDMailArchive >> archiveName: anObject [

	archiveName := anObject
]

{ #category : #'ston persistence' }
MDMailArchive >> asStonDictionary [

	| dictionary convIndex |

	dictionary := Dictionary new.
	#(fileDirectory boxes mailIdIndex flagSeparator archiveName trashBoxName archiveBoxName sentBoxName draftsBoxName) do: [ :each |
		dictionary at: each put: (each value: self) ].
	"WeakDictionaries don't play nicely with STON - convert to an Array of associations for serialisation"
	convIndex := Array streamContents: [ :stream |
		conversationIndex keysAndValuesDo: [ :key :value |
			stream nextPut: key -> value ] ].
	dictionary at: #conversationIndex put: convIndex.
	^dictionary
]

{ #category : #boxes }
MDMailArchive >> boxNamed: aRelativeBoxName [

	| box boxNameParts |

	self boxes detect: [ :b | b boxName = aRelativeBoxName ] ifFound: [ :b | ^b ].
	boxNameParts := aRelativeBoxName findTokens: '.'.
	boxNameParts size = 0 ifTrue: [^self].
	^ (self boxes detect: [:b | b boxName = boxNameParts first]) boxNamed: ('.' join: boxNameParts allButFirst)
]

{ #category : #accessing }
MDMailArchive >> boxes [

	^ boxes
]

{ #category : #accessing }
MDMailArchive >> boxes: anObject [

	boxes := anObject
]

{ #category : #indexing }
MDMailArchive >> conversationForId: id ifAbsent: absentLogic [

	^ self protectIndexAccessDuring: [self conversationIndex at: id ifAbsent: absentLogic]
]

{ #category : #indexing }
MDMailArchive >> conversationIndex [

	^ conversationIndex
]

{ #category : #indexing }
MDMailArchive >> conversationIndex: anObject [

	conversationIndex := anObject
]

{ #category : #accessing }
MDMailArchive >> conversations [

	^ MDMailConversation conversationsIn: self allMails
]

{ #category : #indexing }
MDMailArchive >> determineStartMailIdFor: anEntry [

	| predecessorId |

	predecessorId := anEntry inReplyTo.
	predecessorId = 'none' ifTrue: [ ^anEntry messageId ].
	predecessorId = anEntry messageId ifTrue: [^ predecessorId]. 
		
	^ self determineStartMailIdFor: (self messageEntryForId: predecessorId ifAbsent: [^ anEntry messageId])
]

{ #category : #accessing }
MDMailArchive >> draftsBox [
	
	^ self boxNamed: self draftsBoxName
]

{ #category : #accessing }
MDMailArchive >> draftsBoxName [

	^ draftsBoxName
]

{ #category : #accessing }
MDMailArchive >> draftsBoxName: anObject [

	draftsBoxName := anObject
]

{ #category : #accessing }
MDMailArchive >> fileDirectory [

	^ fileDirectory
]

{ #category : #accessing }
MDMailArchive >> fileDirectory: anObject [

	fileDirectory := anObject.
	self migrateBoxPaths.
]

{ #category : #accessing }
MDMailArchive >> flagSeparator [

	^ flagSeparator ifNil: [$:]
]

{ #category : #accessing }
MDMailArchive >> flagSeparator: aCharacter [

	flagSeparator := aCharacter
]

{ #category : #inspecting }
MDMailArchive >> gtBoxesFor: aView [
	<gtView>

	^aView list 
		title: 'Boxes';
		priority: 10;
		items: [ self boxes keys ];
		send: [ :selection | self boxes at: selection ].
]

{ #category : #inspecting }
MDMailArchive >> gtInspectBoxesIn: composite [
	<gtInspectorPresentationOrder: 5>

	composite list 
		title: 'MailBoxes';
		display: [ self boxes values sorted: #boxName ascending ]
]

{ #category : #indexing }
MDMailArchive >> hasMessageEntryForId: id [

	^ self mailIdIndex includesKey: id
]

{ #category : #accessing }
MDMailArchive >> inBox [
	
	^ self boxNamed: self inBoxName
]

{ #category : #accessing }
MDMailArchive >> inBoxName [
	^ inBoxName
]

{ #category : #accessing }
MDMailArchive >> inBoxName: anObject [
	inBoxName := anObject
]

{ #category : #indexing }
MDMailArchive >> indexConversations [ 

	"This has to be done after loading all mails as we have to know about all emails
	before we can build up the conversations. --pre"
	self mailIdIndex values do: [:m | self indexIntoConversationIndex: m]
]

{ #category : #indexing }
MDMailArchive >> indexEntry: anEntry [

	self protectIndexAccessDuring: [
		self indexIntoMessageIdIndex: anEntry.
		self indexIntoConversationIndex: anEntry]
]

{ #category : #indexing }
MDMailArchive >> indexIntoConversationIndex: anEntry [

	| conversation startMailId |
	startMailId := self determineStartMailIdFor: anEntry.
	conversation := (self conversationIndex includesKey: startMailId)
		ifTrue: [	self conversationIndex at: startMailId]
		ifFalse: [ | newConversation |
				newConversation := MDMailConversation new
					startMail: anEntry;
					archive: self;
					yourself.
				self conversationIndex at: startMailId put: newConversation.
				newConversation ].
			
	conversation addMail: anEntry.
	self conversationIndex at: anEntry messageId put: conversation.
]

{ #category : #indexing }
MDMailArchive >> indexIntoMessageIdIndex: anEntry [

	| oldEntry |

	oldEntry := self mailIdIndex at: anEntry messageId ifAbsentPut: [ anEntry ].
	oldEntry == anEntry ifFalse: [ 
		self halt. ]
]

{ #category : #'initialize-release' }
MDMailArchive >> initialize [

	self 
		boxes: Dictionary new;
		mailIdIndex: Dictionary new;
	 	conversationIndex: WeakKeyDictionary new.
		
	indexSemaphore := Mutex new.
]

{ #category : #'initialize-release' }
MDMailArchive >> initializeBoxes [

	| rootBoxNames |
	rootBoxNames := self readRootBoxNames.
	self addBoxesWithNames: rootBoxNames.
	
	
]

{ #category : #synchronization }
MDMailArchive >> interactiveSynchronize [

	<rackOperationLabel: 'synchronize' inContextMenus: true>

	[self synchronize] forkAt: Processor userBackgroundPriority 
]

{ #category : #indexing }
MDMailArchive >> mailIdIndex [

	^ mailIdIndex
]

{ #category : #indexing }
MDMailArchive >> mailIdIndex: anObject [

	mailIdIndex := anObject
]

{ #category : #ui }
MDMailArchive >> mailListIcon [

	^ nil
]

{ #category : #indexing }
MDMailArchive >> messageEntryForId: id ifAbsent: absentLogic [

	^ self protectIndexAccessDuring: [self mailIdIndex at: id ifAbsent: absentLogic]
]

{ #category : #private }
MDMailArchive >> migrateBoxPaths [
	
	self allBoxes do: [:b | 
		b fileDirectory containingDirectory = self fileDirectory ifFalse: [
			b fileDirectory: self fileDirectory / b fullBoxName]]
]

{ #category : #Rack }
MDMailArchive >> openRackStandardMorph [

	^ MDBoxBrowser openOnArchive: self
]

{ #category : #printing }
MDMailArchive >> printOn: aStream [

	aStream 
		nextPutAll: 'a MailArchive named ';
		nextPutAll: (self archiveName ifNil: ['Unknown'])
]

{ #category : #indexing }
MDMailArchive >> protectIndexAccessDuring: aBlock [

	^ indexSemaphore critical: aBlock
]

{ #category : #private }
MDMailArchive >> readBoxNames [

	 ^ self fileDirectory directoryNames
]

{ #category : #'initialize-release' }
MDMailArchive >> readRootBoxNames [
	"Determine the mail box names.  Mail boxes are directories that have the cur, new and tmp subdirectories"
	| boxNames |

	boxNames := self readBoxNames select: [ :each | | boxDir |
		boxDir := self fileDirectory / each.
		(boxDir / 'cur') isDirectory and: [ (boxDir / 'new') isDirectory and: [ (boxDir / 'tmp') isDirectory ] ] ].
	^boxNames asSet
	"^(boxNames collect: [ :boxName | (boxName findTokens: '.') last ]) asSet "

"Original definition: This should be removed when confident.
	boxNames := self readBoxNames.
	^ (boxNames collect: [:boxName | (boxName findTokens: '.') first]) asSet."
	
]

{ #category : #'ston persistence' }
MDMailArchive >> saveToFile [

	| file backup stream |

	file := (archiveName, '-archive.stgz') asFileReference.
	file exists ifTrue: 
		[ backup := file nextVersion.
		file copy moveTo: backup ].

	stream := (ZnCharacterWriteStream 
		on: (GZipWriteStream on: file binaryWriteStream)
		encoding: 'utf8') asNewLineStream.
	[ STON put: self onStreamPretty: stream ]
		ensure: [ stream close ].

]

{ #category : #searching }
MDMailArchive >> search: expressionString [
	"Search the receives messages and answer a collection of message matching the supplied expression"

	^MDSearchParser search: expressionString inArchive: self.
]

{ #category : #accessing }
MDMailArchive >> sentBox [
	
	^ self boxNamed: self sentBoxName
]

{ #category : #accessing }
MDMailArchive >> sentBoxName [

	^ sentBoxName
]

{ #category : #accessing }
MDMailArchive >> sentBoxName: aString [

	sentBoxName := aString
]

{ #category : #'ston persistence' }
MDMailArchive >> stonOn: stonWriter [

	stonWriter writeObject: self streamShortList: [ :array |
		array add: self asStonDictionary ]
]

{ #category : #'ston persistence' }
MDMailArchive >> stonPostReferenceResolution [ 

	| convIndex |

	"The conversationIndex has been serialised as an Array of associations.
	Convert back to a WeakKeyDictionary"
	convIndex := WeakKeyDictionary new.
	conversationIndex do: [ :assoc |
		convIndex at: assoc key put: assoc value ].
	conversationIndex := convIndex.

]

{ #category : #public }
MDMailArchive >> storeMail: aMailMessage in: aMailBox [

	| newMail |
	newMail := MDMail newFor: aMailMessage in: aMailBox.
	newMail setRead.
	newMail moveTo: aMailBox.
	self indexEntry: newMail.
	^ newMail
]

{ #category : #public }
MDMailArchive >> storeSentMail: aMailMessage [

	^ self sentBox storeMail: aMailMessage
]

{ #category : #synchronization }
MDMailArchive >> synchronize [

	self
		synchronizeBoxes;
		synchronizeMessageEntries.
		
	self conversationIndex ifEmpty: [self indexConversations].
]

{ #category : #synchronization }
MDMailArchive >> synchronizeBoxes [

	| newBoxNames actualBoxNames ownBoxNames |
	actualBoxNames := self readRootBoxNames.
	ownBoxNames := self boxes collect: [:b | b boxName].
	newBoxNames := actualBoxNames difference: ownBoxNames.
	
	self addBoxesWithNames: newBoxNames.
	self boxes values do: [:b | b synchronizeSubBoxes].
	self updateIndex. 
	(ownBoxNames difference: actualBoxNames) do: [:boxName |
		self boxes removeKey: boxName].
	self changed.
]

{ #category : #synchronization }
MDMailArchive >> synchronizeMessageEntries [

	self boxes values do: [:b | b synchronizeMessageEntries].
	self updateIndex. 
	self changed.
]

{ #category : #boxes }
MDMailArchive >> trashBox [

	^ self boxNamed: self trashBoxName
]

{ #category : #accessing }
MDMailArchive >> trashBoxName [

	^ trashBoxName
]

{ #category : #accessing }
MDMailArchive >> trashBoxName: anObject [

	trashBoxName := anObject
]

{ #category : #indexing }
MDMailArchive >> updateIndex [

	| removedMails |
	removedMails := self mailIdIndex values select: [:m | m isStoredInAnyBox not].
	
	removedMails do: [:m | 
		(self conversationForId: m messageId ifAbsent: [self error: 'conversation index out of sync'])
			removeMail: m].
	
	self protectIndexAccessDuring: [removedMails do: [:m |
		self conversationIndex removeKey: m messageId.
		self mailIdIndex removeKey: m messageId]]
]

{ #category : #Rack }
MDMailArchive >> worldIconMorph [

	^ ((RIcons icons8Letterbox64pxIcon) scaledToSize: 35@35) asMorph
]

{ #category : #Rack }
MDMailArchive >> worldIconText [

	^ self archiveName , '(' , (self allMails count: [:m | m isUnread]) asString , ')'
]
