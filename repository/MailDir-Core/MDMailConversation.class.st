Class {
	#name : 'MDMailConversation',
	#superclass : 'Object',
	#instVars : [
		'startMail',
		'mails',
		'archive',
		'senderNamesString'
	],
	#category : 'MailDir-Core',
	#package : 'MailDir-Core'
}

{ #category : 'instance creation' }
MDMailConversation class >> conversationsIn: aCollectionOfMails [
	"Answer the set of conversations in aCollectionOfMails.
	All mails must be in the same archive."

	| newConversations archive |
	aCollectionOfMails ifEmpty: [^ #()].
	
	newConversations := Dictionary new.
	
	archive := aCollectionOfMails first mailArchive.
	^ (aCollectionOfMails collect: [:m | 
		archive 
			conversationForId: m messageId 
			ifAbsent: [self error: 'Mails are not properly indexed']]) asSet
	
]

{ #category : 'instance creation' }
MDMailConversation class >> fromSton: stonReader [

	| conversation |

	conversation := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			conversation perform: (key, ':') with: value ] ].
	^conversation
]

{ #category : 'comparing' }
MDMailConversation >> = anotherConversation [

	^ anotherConversation isMailConversation 
		and: [self startMail = anotherConversation startMail]
]

{ #category : 'accessing' }
MDMailConversation >> addMail: aMail [
	
	self invalidateSenderNames.
	^ (mails includes: aMail) ifFalse: [mails add: aMail]

]

{ #category : 'accessing' }
MDMailConversation >> archive [

	^ archive
]

{ #category : 'accessing' }
MDMailConversation >> archive: anObject [

	archive := anObject
]

{ #category : 'ston persistence' }
MDMailConversation >> asStonDictionary [

	| dictionary |

	dictionary := Dictionary new.
	#(mails archive senderNamesString) do: [ :each |
		dictionary at: each put: (each value: self) ].
	^dictionary
]

{ #category : 'accessing' }
MDMailConversation >> date [

	^ self newestDate
]

{ #category : 'inspector' }
MDMailConversation >> gtInspectMessagesIn: composite [
	<gtInspectorPresentationOrder: 5> 

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

{ #category : 'testing' }
MDMailConversation >> hasBeenRead [

	^ self mails allSatisfy: [:m | m hasBeenRead]
]

{ #category : 'comparing' }
MDMailConversation >> hash [

	^ self startMail hash
]

{ #category : 'private' }
MDMailConversation >> humanDateStringFor: aDateAndTime [

	| localTime |

	localTime := aDateAndTime asLocal.
	^localTime asDate = Date today ifTrue: 
		[ String streamContents: [ :stream | localTime asTime
			print24: true showSeconds: false on: stream ] ]
	ifFalse:
		[ localTime asDate printFormat: #(1 2 3 $  2 1) ]
]

{ #category : 'testing' }
MDMailConversation >> includes: aMail [

	^ self mails includes: aMail
]

{ #category : 'initialize-release' }
MDMailConversation >> initialize [

	self mails: OrderedCollection new
]

{ #category : 'Rack' }
MDMailConversation >> interactiveArchiveMessage [

	<rackOperationLabel: 'archive conversation' inContextMenus: true>
	
	self moveToArchive
]

{ #category : 'Rack' }
MDMailConversation >> interactiveSetToRead [

	<rackOperationLabel: 'mark all messages read' inContextMenus: true>
	
	self setRead
]

{ #category : 'Rack' }
MDMailConversation >> interactiveTrashMessage [

	<rackOperationLabel: 'move to trash' inContextMenus: true>
	
	self moveToTrash
]

{ #category : 'private' }
MDMailConversation >> invalidateSenderNames [ 

	senderNamesString := nil.
]

{ #category : 'testing' }
MDMailConversation >> isCollection [ 

	^ true
]

{ #category : 'testing' }
MDMailConversation >> isDeletedFromSystem [
	
	^ self mails allSatisfy: [:m | m isDeletedFromSystem]
]

{ #category : 'testing' }
MDMailConversation >> isImportant [

	^ self mails anySatisfy: [:m | m isImportant]
]

{ #category : 'testing' }
MDMailConversation >> isMailConversation [ 

	^ true
]

{ #category : 'testing' }
MDMailConversation >> isUnread [

	^ self mails anySatisfy: [:m | m isUnread]
]

{ #category : 'mails' }
MDMailConversation >> latestMail [

	| a allMails latestMail |
	allMails := self mails.
	latestMail := a first.
	allMails do: [:m | m date > latestMail date ifTrue: [latestMail := m]].
	^ latestMail
]

{ #category : 'ui' }
MDMailConversation >> mailListIcon [

	^ ToolIcons iconNamed: 
		(self isDeletedFromSystem
			ifTrue: [#testRed] 
			ifFalse: [self isUnread ifTrue: [#testOrange] ifFalse: [#blank]])
]

{ #category : 'accessing' }
MDMailConversation >> mails [

	^ mails select: [:m | (m boxes = {self archive trashBox}) not]
]

{ #category : 'accessing' }
MDMailConversation >> mails: anObject [

	self invalidateSenderNames.
	mails := anObject
]

{ #category : 'mails' }
MDMailConversation >> moveTo: aBox [

	self mails do: [:m | m moveTo: aBox]
]

{ #category : 'mails' }
MDMailConversation >> moveToArchive [
	
	self setRead.
	mails do: [:m | m moveToArchive]
]

{ #category : 'mails' }
MDMailConversation >> moveToTrash [

	mails do: [:m | m moveToTrash]
]

{ #category : 'accessing' }
MDMailConversation >> newestDate [

	^ (self mails collect: [:m | m date])
		ifEmpty: [DateAndTime new] 
		ifNotEmptyDo: [:dates | dates max]
]

{ #category : 'testing' }
MDMailConversation >> notEmpty [ 

	^ self mails notEmpty
]

{ #category : 'accessing' }
MDMailConversation >> oldestDate [

	^ (self mails collect: [:m | m date]) min
]

{ #category : 'Rack' }
MDMailConversation >> openRackStandardMorph [

	self setRead.
	^ self mails last openRackStandardMorph
]

{ #category : 'printing' }
MDMailConversation >> printOn: aStream [
	
	self printSenderNamesOn: aStream.
	aStream tab.
	self printSubjectOn: aStream.

]

{ #category : 'printing' }
MDMailConversation >> printSenderNamesOn: aStream [

	| max senderNames |

	senderNamesString ifNil: [
		senderNames := self mails collect: [:mail | mail senderName].
		senderNames := (senderNames reject: [:s | s isEmpty]) asSet asArray.
		senderNamesString := ', ' join: senderNames ].
	
	max := 38.	
	aStream nextPutAll:  
		(senderNamesString size > max
			ifFalse: [senderNamesString]
			ifTrue: [(String streamContents: [:s | s nextPutAll: senderNamesString] limitedTo: max-2),'..'])
]

{ #category : 'printing' }
MDMailConversation >> printSenderOn: aStream [

	| max |
	max := 30.
	aStream nextPutAll:  
		(self startMail sender size > max
			ifFalse: [self startMail sender]
			ifTrue: [(String streamContents: [:s | s nextPutAll: self startMail sender] limitedTo: max-2),'..'])
]

{ #category : 'printing' }
MDMailConversation >> printSubjectOn: aStream [

	| max |
	max := 72.
	aStream nextPutAll:  
		(self startMail subject size > max
			ifFalse: [self startMail subject]
			ifTrue: [(String streamContents: [:s | s nextPutAll: self startMail subject] limitedTo: max-2),'..'])
]

{ #category : 'mails' }
MDMailConversation >> removeMail: aMail [

	self invalidateSenderNames.
	mails remove: aMail ifAbsent: [].
]

{ #category : 'meta information' }
MDMailConversation >> sender [

	^ self mails first sender
]

{ #category : 'meta information' }
MDMailConversation >> senderName [

	^ self mails first senderName
]

{ #category : 'accessing' }
MDMailConversation >> senderNames [

	^ ', ' join: (self mails collect: [:ea | ea senderName]) asSet
]

{ #category : 'accessing' }
MDMailConversation >> senderNamesString [
	^ senderNamesString
]

{ #category : 'ston persistence' }
MDMailConversation >> senderNamesString: aString [

	senderNamesString := aString
]

{ #category : 'mails' }
MDMailConversation >> setRead [

	self mails do: [:m | m setRead]
]

{ #category : 'mails' }
MDMailConversation >> setUnread [

	self mails do: [:m | m setUnread]
]

{ #category : 'accessing' }
MDMailConversation >> size [

	^ self mails size
]

{ #category : 'accessing' }
MDMailConversation >> startMail [

	| links |
	links := mails collect: [:m |
		{m messageId . m inReplyTo . m}].

	^ (links detect: [:l | links noneSatisfy: [:l2 | l2 first = l second] ]) third
]

{ #category : 'accessing' }
MDMailConversation >> startMail: aMail [

	mails add: aMail


]

{ #category : 'ston persistence' }
MDMailConversation >> stonOn: stonWriter [

	stonWriter writeObject: self streamShortList: [ :array |
		array add: self asStonDictionary ]
]

{ #category : 'meta information' }
MDMailConversation >> subject [

	^ self mails first subject
]

{ #category : 'Rack' }
MDMailConversation >> worldIconMorph [
	
	^ (RIcons icons8GroupMessage64pxIcon scaledToSize: 35@35) asMorph
]
