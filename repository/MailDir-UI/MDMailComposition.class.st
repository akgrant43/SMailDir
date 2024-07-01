Class {
	#name : #MDMailComposition,
	#superclass : #MailComposition,
	#instVars : [
		'selectedProfileIndex'
	],
	#category : 'MailDir-UI'
}

{ #category : #installation }
MDMailComposition class >> install [
	"self install"
	TheWorldMenu registerOpenCommand: {'Write a Mail' . {self . #open}}.
]

{ #category : #'drag and drop' }
MDMailComposition >> acceptDroppingMorph: dropee event: evt inMorph: target [

	(target isTextView and: [target getTextSelector = #messageText]) ifTrue: ["Someone wants to attach something"
		dropee passenger externalTransportRepresentation keysAndValuesDo: [:name :stream |
			self addAttachment: stream named: name].
		self changed: #messageText.
		^ true].
	
	(target isTextView and: [#(messageRecipient messageCC messageBCC) includes: target getTextSelector]) ifTrue: ["Someone wants to address the email"
		self addEmailAddress: dropee passenger emailAddress to: target getTextSelector.
		^ true].
	
	^ false
]

{ #category : #private }
MDMailComposition >> addAttachment: stream named: attachmentName [
	"Delete after 5.2 release"

	stream binary.
	mailMessage
		addAttachmentFrom: stream
		withName: attachmentName
]

{ #category : #private }
MDMailComposition >> addEmailAddress: emailAddress to: fieldName [

	| existingEmailAddresses newAddresses |
	existingEmailAddresses := (self perform: fieldName) withBlanksTrimmed.
	newAddresses := existingEmailAddresses 
		ifEmpty: [emailAddress]
		ifNotEmpty: [existingEmailAddresses , ', ' , emailAddress].
	self perform: (fieldName , ':') asSymbol with: newAddresses.
	self changed: fieldName
	
]

{ #category : #toolbuilder }
MDMailComposition >> createDetailsFieldsIn: detailsPanelSpec by: aBuilder [

	| fieldSpec labelSpec profileField |
	super createDetailsFieldsIn: detailsPanelSpec by: aBuilder.
	
	profileField := aBuilder pluggablePanelSpec new
		children: OrderedCollection new;
		frame: (LayoutFrame new
			leftFraction: 0 offset: 0;
			topFraction: 0 offset: 0;
			rightFraction: 1 offset: 0;
			bottomFraction: 0 offset: self lineHeight);
		yourself.
		
	labelSpec := aBuilder pluggableInputFieldSpec new
		model: self;
		indicateUnacceptedChanges: false;
		color: #windowColorToUse;
		readOnly: true;
		getText: #profilesLabel;
		frame: (0@0 corner: 0.2@1);
		yourself.
	profileField children add: labelSpec.
	
	fieldSpec := aBuilder pluggableListSpec new
		model: self;
		list: #profiles;
		getIndex: #selectedProfileIndex;
		setIndex: #selectedProfileIndex:;
		frame: (0.2@0 corner: 1@1);
		yourself.	
	profileField children add: fieldSpec.
	
	"Add selection of a mail profile here"
	detailsPanelSpec children addFirst: profileField.
	

]

{ #category : #toolbuilder }
MDMailComposition >> createFieldInputNamed: fieldLabelGetter getter: fieldGetter setter: fieldSetter with: aBuilder [

	| spec |
	spec := super createFieldInputNamed: fieldLabelGetter getter: fieldGetter setter: fieldSetter with: aBuilder.
	spec name: fieldGetter.
	^ spec
]

{ #category : #toolbuilder }
MDMailComposition >> doSendMail [
	
	| mailMessageToSend recipients |
	mailMessage messageId: self selectedProfile newMessageId.
	
	mailMessageToSend := mailMessage deepCopy.
	recipients := (mailMessage to findTokens: ',') , 
					(mailMessage cc findTokens: ',') , 
					(mailMessage bcc findTokens: ',').
	recipients := recipients asSet asOrderedCollection collect: [:r | r withBlanksTrimmed].
	mailMessageToSend bcc: ''.
	
	(SMTPClient openOnHostNamed: self selectedProfile smtpServer port: self selectedProfile smtpServerPort)
		user: self selectedProfile smtpUsername;
		password: self selectedProfile smtpPassword;
		login;
		mailFrom: mailMessage from to: recipients text: mailMessageToSend asSendableText.
		
	self selectedProfile storeSentMessage: mailMessage.
]

{ #category : #toolbuilder }
MDMailComposition >> profiles [

	^ MDMailProfile Profiles asOrderedCollection
]

{ #category : #toolbuilder }
MDMailComposition >> profilesLabel [

	^ 'sender profile' translated
]

{ #category : #accessing }
MDMailComposition >> selectedProfile [
	
	^ self profiles at: self selectedProfileIndex
]

{ #category : #accessing }
MDMailComposition >> selectedProfileIndex [

	^ selectedProfileIndex ifNil: [self selectedProfileIndex: 1. 1]
]

{ #category : #accessing }
MDMailComposition >> selectedProfileIndex: aNumber [

	aNumber = 0 ifFalse: [selectedProfileIndex := aNumber].
	self changed: #selectedProfileIndex.
	
	self messageSender: self selectedProfile userEmailAddress.
	self changed: #messageSender.
]

{ #category : #'drag and drop' }
MDMailComposition >> wantsDroppedMorph: dropee event: evt inMorph: target [

	^ (self wantsDroppedMorph: dropee forAttachmentsIn: target)
		or: [self wantsDroppedMorph: dropee forAddressingIn: target]
	
	
]

{ #category : #private }
MDMailComposition >> wantsDroppedMorph: dropee forAddressingIn: target [
	
	^ target isTextView 
		and: [(dropee respondsTo: #passenger) 
		and: [dropee passenger respondsTo: #emailAddress]]	
]

{ #category : #private }
MDMailComposition >> wantsDroppedMorph: dropee forAttachmentsIn: target [
	
	^ target isTextView 
		and: [(dropee respondsTo: #passenger) 
		and: [dropee passenger respondsTo: #externalTransportRepresentation]]	
]

{ #category : #toolbuilder }
MDMailComposition >> windowColorToUse [

	^ Color white
]
