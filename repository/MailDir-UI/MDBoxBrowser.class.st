Class {
	#name : #MDBoxBrowser,
	#superclass : #Object,
	#instVars : [
		'boxes',
		'selectedElement',
		'selectedParent',
		'selectedPath',
		'hasSeenChange',
		'previouslyBoxMovedTo'
	],
	#category : 'MailDir-UI'
}

{ #category : #opening }
MDBoxBrowser class >> openOnArchive: aMailArchive [

	^ ToolBuilder default open: (self new
		boxes: aMailArchive boxes;
		yourself)
]

{ #category : #opening }
MDBoxBrowser class >> openOnBox: anEMailBox [

	^ ToolBuilder default open: (self new
		boxes: { anEMailBox };
		yourself)
]

{ #category : #menu }
MDBoxBrowser >> addMenuOperation: operation for: item to: aMenu [
	
	aMenu 
		addWithLabel: operation arguments first
		enablementSelector: nil 
		target: item
		selector: operation method selector
		argumentList: #()
]

{ #category : #accessing }
MDBoxBrowser >> boxes [

	^ boxes sorted: [:a :b | a boxName < b boxName]
]

{ #category : #accessing }
MDBoxBrowser >> boxes: anObject [

	boxes isEmptyOrNil ifFalse: [boxes do: [:b | b removeDependent: self]].
	boxes := anObject.
	boxes do: [:b | b addDependent: self].
]

{ #category : #toolbuilder }
MDBoxBrowser >> buildWith: aBuilder [

	| windowSpec folderListSpec window |

	windowSpec := aBuilder pluggableWindowSpec new
		model: self;
		label: #windowLabel;
		children: OrderedCollection new.
		
	folderListSpec := aBuilder pluggableTreeSpec new.
	folderListSpec 
		model: self;
		roots: #boxes;
		label: #elementNameOf:;
		hasChildren: #isNonEmptyBox:;
		getChildren: #elementsOfBox:;
		setSelected: #setSelectedEntryTo:;
		getSelected: #getSelectedEntry;
		dragItem: #drag:;
		dropAccept: #wantsDroppedObject:;
		dropItem: #drop:ontoBox:shouldCopy:;
		doubleClick: #doubleClickOn:;
		autoDeselect: false;
		menu: #generalMenu:;
		icon: #iconFor:;
		keyPress: #keyPressed:;
		setSelectedParent: #selectedParent:;
		setSelectedPath: #setSelectedPath:;
		columns: #(300 nil);
		frame: (0@0 corner: 1@1).
	windowSpec children add: folderListSpec.
	
	window := aBuilder build: windowSpec.
	boxes size = 1 ifTrue: [self changed: #expandRootsRequested].
	^ window

]

{ #category : #'mail list' }
MDBoxBrowser >> createFakeBoxFor: aBox [

	^ MDBoxBrowserFakeBox new
		originalBox: aBox;
		yourself
]

{ #category : #'keyboard handling' }
MDBoxBrowser >> determineNextEmailToSelect [
		
	| elements element selectionIndex parentMailBox |
	parentMailBox := self selectedPath detect: [:e | e isMailBox].
	self selectedParent isMailConversation ifTrue: [
		self selectedParent mails size = 1 
			ifTrue: [elements := self elementsOfBox: parentMailBox.
					element := self selectedParent.]
			ifFalse: [elements := self elementsOfBox: self selectedParent.
					element := self selectedElement]].
	
	self selectedParent isMailBox ifTrue: [
		elements := self elementsOfBox: parentMailBox.
		element := self selectedElement.].	
		
	selectionIndex := (elements indexOf: element) + 1.
	selectionIndex := selectionIndex min: elements size - 1. "To account for the deleted element"
	^ elements at: selectionIndex.
	
]

{ #category : #updating }
MDBoxBrowser >> doDelayedUpdate [

	Project current addDeferredUIMessage: [
		[self changed: #boxes] ensure: [hasSeenChange := false]].
	
]

{ #category : #'mail list' }
MDBoxBrowser >> doubleClickOn: anObject [

	(anObject respondsTo: #openRackStandardMorph)
		ifFalse: [^ ToolSet default explore: anObject message]
		ifTrue: [
			anObject isEmail 
				ifTrue: [anObject setRead.
						^ anObject message openRackStandardMorph].
			anObject isMailBox ifTrue: [^ anObject openRackStandardMorph]]
]

{ #category : #'drag and drop' }
MDBoxBrowser >> drag: entry [

	(entry isEmail or: [entry isMailBox] or: [entry isMailConversation]) ifTrue: [^ entry].
]

{ #category : #'drag and drop' }
MDBoxBrowser >> drop: anEmailOrConversation ontoBox: aBox shouldCopy: shouldCopy [
	
	aBox isMailBox ifFalse: [^ false].
	
	anEmailOrConversation moveTo: aBox. 
	self previouslyBoxMovedTo: aBox.
	self changed: #boxes.
	^ false
]

{ #category : #'mail list' }
MDBoxBrowser >> elementNameOf: anObject [
	
	^ anObject printString
]

{ #category : #'mail list' }
MDBoxBrowser >> elementsOfBox: aBoxOrConversation [

	aBoxOrConversation isMailBox
		ifTrue: [| aBox |
				aBox := aBoxOrConversation.
				^ aBox subBoxes
					ifNotEmpty: [aBox subBoxes , {self createFakeBoxFor: aBox}]
					ifEmpty: [self mailsOfBox: aBox]].
			
	aBoxOrConversation isMailConversation
		ifTrue: [^ aBoxOrConversation mails sorted: [:a :b | a date > b date]].	
		
	^ #()
]

{ #category : #menu }
MDBoxBrowser >> generalMenu: aMenu [

	self selectedElement menuOperations do: [:operation |
		self addMenuOperation: operation for: self selectedElement to: aMenu].

	^ aMenu
]

{ #category : #'mail list' }
MDBoxBrowser >> getSelectedEntry [
	
	^ selectedElement
	
]

{ #category : #accessing }
MDBoxBrowser >> hasSeenChange [

	^ hasSeenChange
]

{ #category : #accessing }
MDBoxBrowser >> hasSeenChange: anObject [

	hasSeenChange := anObject
]

{ #category : #'mail list' }
MDBoxBrowser >> iconFor: aMailObject [

	^ aMailObject mailListIcon
]

{ #category : #'initialize-release' }
MDBoxBrowser >> initialize [

	super initialize.
	hasSeenChange := false.
	boxes := #()
]

{ #category : #'mail list' }
MDBoxBrowser >> isNonEmptyBox: anObject [
	
	^ anObject isCollection and: [anObject notEmpty]
]

{ #category : #'keyboard handling' }
MDBoxBrowser >> keyPressed: character [

	character = Character delete ifTrue: [
		^ self selectNextElementAfter: [self selectedElement moveToTrash]].
	
	character = Character space ifTrue: [
		self selectedElement isEmail ifTrue: [
			[self selectedElement openRackStandardMorph] fork.
			^ true]].
	
	character = $a ifTrue: [
		self selectedElement isEmail 
			ifTrue: [^ self selectNextElementAfter: [self selectedElement moveToArchive]].
		self selectedElement isMailConversation 
			ifTrue: [^ self selectNextElementAfter: [self selectedElement moveToArchive]]].
		
	character = $j ifTrue: [
		((self selectedElement isEmail or: [self selectedElement isMailConversation])
			and: [self previouslyBoxMovedTo notNil])
				ifTrue: [^ self selectNextElementAfter: [self selectedElement moveTo: self previouslyBoxMovedTo]]]
	
]

{ #category : #'mail list' }
MDBoxBrowser >> mailsOfBox: aBox [

	| conversations conversationsOrMails mails oldMails |
	mails := aBox mails size > 200
		ifTrue: [ |deadline|
			deadline := (aBox mails collect: [:m | m date]) max - 24 weeks.
			oldMails := aBox mails select: [:m | m date < deadline ].
			aBox mails select: [:m | m date >= deadline ]]
		ifFalse: [aBox mails].
	
	conversations := MDMailConversation conversationsIn: mails.
	conversationsOrMails := conversations collect: [:c | 
		c size = 1 
			ifTrue: [c mails first] 
			ifFalse: [c]].
	conversationsOrMails := conversationsOrMails sorted: [:a :b | a date > b date ].
	
	^ aBox mails size > 200
		ifTrue: [conversationsOrMails , {MDBoxBrowserFakeBoxForOldMails new mails: oldMails}]
		ifFalse: [conversationsOrMails]
]

{ #category : #accessing }
MDBoxBrowser >> previouslyBoxMovedTo [

	^ previouslyBoxMovedTo
]

{ #category : #accessing }
MDBoxBrowser >> previouslyBoxMovedTo: anObject [

	previouslyBoxMovedTo := anObject
]

{ #category : #'keyboard handling' }
MDBoxBrowser >> selectNextElementAfter: aBlock [

	| nextMail |
	nextMail := self determineNextEmailToSelect.
	aBlock value.
	self selectedElement: nextMail.
	self changed: #selectedElement. 
]

{ #category : #accessing }
MDBoxBrowser >> selectedElement [

	^ selectedElement
]

{ #category : #accessing }
MDBoxBrowser >> selectedElement: anObject [

	selectedElement := anObject
]

{ #category : #accessing }
MDBoxBrowser >> selectedParent [

	^ selectedParent
]

{ #category : #accessing }
MDBoxBrowser >> selectedParent: anObject [

	selectedParent := anObject
]

{ #category : #accessing }
MDBoxBrowser >> selectedPath [

	^ selectedPath
]

{ #category : #accessing }
MDBoxBrowser >> selectedPath: anObject [

	selectedPath := anObject
]

{ #category : #'mail list' }
MDBoxBrowser >> setSelectedEntryTo: anObject [

	selectedElement := anObject.
	self changed: #getSelectedEntry
]

{ #category : #'mail list' }
MDBoxBrowser >> setSelectedPath: aCollection [

	selectedPath := aCollection
]

{ #category : #updating }
MDBoxBrowser >> update: anObject [

	(self boxes includes: anObject) ifTrue: [
		hasSeenChange ifFalse: [
			hasSeenChange := true.
			(self future: self updateDelayInMS) doDelayedUpdate]]
]

{ #category : #updating }
MDBoxBrowser >> updateDelayInMS [

	^ 100
]

{ #category : #'drag and drop' }
MDBoxBrowser >> wantsDroppedObject: anObject [
	
	^ anObject isEmail or: [anObject isMailConversation]
]

{ #category : #'model protocol' }
MDBoxBrowser >> windowColorToUse [

	^ Color cantaloupe paler
]

{ #category : #toolbuilder }
MDBoxBrowser >> windowLabel [

	^ 'Mail Browser: ' , (self boxes size = 1
		ifTrue: [self boxes first boxName , ' of ' , self boxes first mailArchive archiveName]
		ifFalse: [self boxes first mailArchive archiveName]) , ' archive'
]
