"
MDSearchMail is a wrapper around a MDMail message that removes accents from the searched text and caches the strings.

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	body:		<Object>
	cc:		<Object>
	date:		<Object>
	mdMail:		<Object>
	messageId:		<Object>
	recipients:		<Object>
	sender:		<Object>
	senderAddress:		<Object>
	senderName:		<Object>
	subject:		<Object>


    Implementation Points
"
Class {
	#name : #MDSearchMail,
	#superclass : #Object,
	#instVars : [
		'mdMail',
		'subject',
		'sender',
		'senderAddress',
		'senderName',
		'recipients',
		'date',
		'cc',
		'body',
		'timestamp'
	],
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDSearchMail class >> mdMail: aMDMail [

	^self new mdMail: aMDMail
]

{ #category : #accessing }
MDSearchMail >> body [
	^ body ifNil: [ body := (self messageTextIn: mdMail message) asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> cc [
	^ cc ifNil: [ mdMail cc asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> date [
	^ date ifNil: [ date := mdMail date ]
]

{ #category : #accessing }
MDSearchMail >> mdMail [
	^ mdMail
]

{ #category : #accessing }
MDSearchMail >> mdMail: anObject [
	mdMail := anObject
]

{ #category : #accessing }
MDSearchMail >> messageId [

	^mdMail messageId
]

{ #category : #private }
MDSearchMail >> messageTextIn: aMimePart [
	"Answer the text in aMimeEntity and its parts"

	^String streamContents: [ :stream |
		self messageTextIn: aMimePart entity on: stream ]
]

{ #category : #private }
MDSearchMail >> messageTextIn: aMimeEntity on: aStream [
	"Write the text in aMimeEntity and its parts on aStream"

	(aMimeEntity isNil or: [aMimeEntity contents isNil]) ifTrue: [ ^self ].
	(aMimeEntity contentType isNil or: [aMimeEntity contentType main = 'text']) ifTrue: 
		[ aStream 
			<< aMimeEntity contents;
			cr ].
	aMimeEntity partsDo: [ :part |
		self messageTextIn: part on: aStream ].

]

{ #category : #accessing }
MDSearchMail >> recipients [
	^ recipients ifNil: [ recipients := (mdMail recipients ifNil: [ '' ]) asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> sender [
	^ sender ifNil: [ sender := mdMail sender asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> senderAddress [
	^ senderAddress ifNil: [ mdMail senderAddress asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> senderName [
	^ senderName ifNil: [ mdMail senderName asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> subject [
	^ subject ifNil: [ subject := (mdMail subject ifNil: [ '' ]) asLowercase asNonDiacritical ]
]

{ #category : #accessing }
MDSearchMail >> timestamp [
	^ timestamp ifNil: [ timestamp := mdMail date ]
]
