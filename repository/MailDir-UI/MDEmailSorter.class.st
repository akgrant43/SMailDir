Class {
	#name : #MDEmailSorter,
	#superclass : #MDEmailReader,
	#instVars : [
		'mailArchive',
		'previousMail',
		'folders',
		'mailQueue',
		'skippedMails'
	],
	#category : 'MailDir-UI'
}

{ #category : #opening }
MDEmailSorter class >> open [
	"self open"
	
	^ super open
]

{ #category : #opening }
MDEmailSorter class >> openOn: aMailArchive [
	
	ToolBuilder default open: (self new
		mailArchive: aMailArchive;
		yourself)
]

{ #category : #actions }
MDEmailSorter >> buttonActionFor: anInteger [ 
	
	(self folders at: anInteger)
		ifNil: [ | allBoxes selectedFolder |
			allBoxes := (self mailArchive allBoxes) sorted: [:b1 :b2 | 
				b1 fullBoxName <= b2 fullBoxName]. 
			selectedFolder := UIManager default
				chooseFrom: (allBoxes collect: [:b | b fullBoxName]) 
				values: allBoxes.
			selectedFolder ifNil: [^ false].
			self folders at: anInteger put: selectedFolder.
			self moveMailTo: selectedFolder.
			self changed: ('buttonFolderLabel' , anInteger asString) asSymbol ]
		ifNotNilDo: [:folder | self moveMailTo: folder]
]

{ #category : #toolbuilder }
MDEmailSorter >> buttonLabelFor: anIndex [

	^ (self folders at: anIndex)
		ifNil: ['none']
		ifNotNil: [:folder | folder fullBoxName]
]

{ #category : #toolbuilder }
MDEmailSorter >> createFolderButtonsWith: aBuilder [

	| leftColumn createButton rightColumn |
	createButton := [:index |
		aBuilder pluggableButtonSpec new
			model: self;
			action: ('buttonFolderAction' , index asString) asSymbol;
			label: ('buttonFolderLabel' , index asString) asSymbol].
	leftColumn := (aBuilder pluggablePanelSpec new
		children: OrderedCollection new;
		layout: #vertical;
		yourself).	
	leftColumn children addAll: ((1 to: self numberOfButtonsPerRow) collect: createButton).

	rightColumn := (aBuilder pluggablePanelSpec new
		children: OrderedCollection new;
		layout: #vertical;
		yourself).	
	rightColumn children addAll: ((self numberOfButtonsPerRow + 1  to: self numberOfButtonsPerRow * 2) collect: createButton).	
		
	^ {leftColumn . rightColumn}
	
]

{ #category : #toolbuilder }
MDEmailSorter >> createSpecsWith: aBuilder [

	| children windowSpecs buttonPanel |
	windowSpecs := super createSpecsWith: aBuilder.
	
	children := windowSpecs children.
	windowSpecs children: OrderedCollection new.
	
	windowSpecs children add: (aBuilder pluggablePanelSpec new
		children: children;
		frame: (0@0 corner: 0.8@1);
		yourself).
		
	buttonPanel := (aBuilder pluggablePanelSpec new
		children: OrderedCollection new;
		layout: #proportional;
		frame: (0.8@0 corner: 1@1);
		yourself).
	windowSpecs children add: buttonPanel.
	
	buttonPanel children add: (aBuilder pluggableButtonSpec new
		model: self;
		action: #undo;
		label: 'Undo previous sorting';
		frame: (0@0 corner: 1@0.1);
		yourself).

	buttonPanel children add: (aBuilder pluggableButtonSpec new
		model: self;
		action: #skipMail;
		label: 'Skip';
		frame: (0@0.1 corner: 1@0.2);
		yourself).
		
	buttonPanel children add: (aBuilder pluggablePanelSpec new
		children: (self createFolderButtonsWith: aBuilder);
		layout: #horizontal;
		frame: (0@0.2 corner: 1@1);
		yourself).
		
	^ windowSpecs
		
]

{ #category : #accessing }
MDEmailSorter >> currentMail [

	^ mailMessage
]

{ #category : #'error handling' }
MDEmailSorter >> doesNotUnderstand: aMessage [

	(aMessage selector beginsWith: 'buttonFolder')
		ifTrue: [ | buttonNumber |
			buttonNumber := (aMessage selector select: [:c | c isDigit]) join asNumber.
			(aMessage selector includesSubstring: 'Action')
				ifTrue: [^ self buttonActionFor: buttonNumber].
				
			(aMessage selector includesSubstring: 'Label')
				ifTrue: [^ self buttonLabelFor: buttonNumber].]
		ifFalse: [^ super doesNotUnderstand: aMessage]
]

{ #category : #accessing }
MDEmailSorter >> folders [

	^ folders
]

{ #category : #accessing }
MDEmailSorter >> folders: anObject [

	folders := anObject
]

{ #category : #accessing }
MDEmailSorter >> inbox [

	^ self mailArchive boxNamed: 'INBOX'
]

{ #category : #'initialize-release' }
MDEmailSorter >> initialize [

	super initialize.
	
	self folders: (Array new: self numberOfButtonsPerRow * 2).
	self skippedMails: Set new
]

{ #category : #'initialize-release' }
MDEmailSorter >> initializeDefaultFolders [

	self folders at: (self numberOfButtonsPerRow * 2) put: (self mailArchive trashBox).
	(self mailArchive archiveBox ifNotNil: [:archiveBox | self folders at: 1 put: archiveBox])
	
]

{ #category : #accessing }
MDEmailSorter >> mailArchive [

	^ mailArchive
]

{ #category : #accessing }
MDEmailSorter >> mailArchive: anObject [

	mailArchive := anObject.
	self 
		initializeDefaultFolders;
		refreshCurrentMail.
]

{ #category : #accessing }
MDEmailSorter >> mailQueue [

	^ mailQueue
]

{ #category : #accessing }
MDEmailSorter >> mailQueue: anObject [

	mailQueue := anObject
]

{ #category : #actions }
MDEmailSorter >> moveMailTo: aMDMailBox [ 
	
	| mailDirEntry |
	mailDirEntry := self mailArchive 
		messageEntryForId: (self currentMail messageId) 
		ifAbsent: [self error: 'Invalid mail'].
	mailDirEntry moveTo: aMDMailBox.
	self refreshCurrentMail.
]

{ #category : #'ui constants' }
MDEmailSorter >> numberOfButtonsPerRow [

	^ 6
]

{ #category : #accessing }
MDEmailSorter >> previousMail [

	^ previousMail
]

{ #category : #accessing }
MDEmailSorter >> previousMail: anObject [

	previousMail := anObject
]

{ #category : #private }
MDEmailSorter >> refreshCurrentMail [

	| nextMail |
	nextMail := self inbox mails 
		detect: [:mail | (self skippedMails includes: mail header messageId) not ] 
		ifNone: [^ UIManager default inform: 'You are done for now :)']. 
	self setCurrentMailTo: nextMail message.
]

{ #category : #accessing }
MDEmailSorter >> setCurrentMailTo: aMailMessage [

	self previousMail: mailMessage.
	mailMessage := aMailMessage.
	self 
		changed: #messageText;
		changed: #messageRecipient;
		changed: #messageSubject;
		changed: #messageSender;
		changed: #messageCC;
		changed: #messageBCC;
		changed: #message;
		changed: #messageDateAndTime:;
		changed: #dialogTitle
]

{ #category : #actions }
MDEmailSorter >> skipMail [

	self skippedMails add: self currentMail messageId.
	
	self refreshCurrentMail
]

{ #category : #accessing }
MDEmailSorter >> skippedMails [

	^ skippedMails
]

{ #category : #accessing }
MDEmailSorter >> skippedMails: anObject [

	skippedMails := anObject
]

{ #category : #actions }
MDEmailSorter >> undo [

	| messageEntry |
	messageEntry := self mailArchive 
		messageEntryForId: self previousMail messageId
		ifAbsent: [self error: 'Index is broken'].
		
	messageEntry moveTo: self inbox.
		
	self setCurrentMailTo: messageEntry message
]
