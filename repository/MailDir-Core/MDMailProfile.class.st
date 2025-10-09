Class {
	#name : 'MDMailProfile',
	#superclass : 'Object',
	#instVars : [
		'smtpServer',
		'smtpServerPort',
		'smtpUsername',
		'smtpPassword',
		'userEmailAddress',
		'archive',
		'profileName'
	],
	#classVars : [
		'Profiles'
	],
	#category : 'MailDir-Core',
	#package : 'MailDir-Core'
}

{ #category : 'accessing' }
MDMailProfile class >> Profiles [

	^ Profiles ifNil: [Profiles := Set new]
]

{ #category : 'instance creation' }
MDMailProfile class >> create [

	| newProfile |
	newProfile := self basicNew
		initialize;
		yourself.
		
	self Profiles add: newProfile.
	^ newProfile 
	
]

{ #category : 'instance creation' }
MDMailProfile class >> forMessage: aMailMessage [ 
	self shouldBeImplemented
]

{ #category : 'instance creation' }
MDMailProfile class >> new [

	self error: 'You can only create persistent instances of this'
]

{ #category : 'initialize-release' }
MDMailProfile class >> removeFromSystem: aProfile [

	Profiles remove: aProfile
]

{ #category : 'accessing' }
MDMailProfile >> archive [

	^ archive
]

{ #category : 'accessing' }
MDMailProfile >> archive: anObject [

	archive := anObject
]

{ #category : 'accessing' }
MDMailProfile >> hostName [

	^ ((self smtpServer findTokens: '.') last: 2) joinSeparatedBy: '.'
]

{ #category : 'initialize-release' }
MDMailProfile >> initialize [

	self archive: MDMailArchive new
]

{ #category : 'accessing' }
MDMailProfile >> newMessageId [

	| id |
	id := UUID new asString36.
	^ id , $@ , self hostName
]

{ #category : 'printing' }
MDMailProfile >> printOn: aStream [

	aStream nextPutAll: self profileName
]

{ #category : 'accessing' }
MDMailProfile >> profileName [

	^ profileName ifNil: ['']
]

{ #category : 'accessing' }
MDMailProfile >> profileName: anObject [

	profileName := anObject
]

{ #category : 'actions' }
MDMailProfile >> replyTo: aMessage [

	MDMailComposition sendMessage: (MailMessage replyFor: aMessage)
	
]

{ #category : 'accessing' }
MDMailProfile >> smtpPassword [

	^ smtpPassword
]

{ #category : 'accessing' }
MDMailProfile >> smtpPassword: anObject [

	smtpPassword := anObject
]

{ #category : 'accessing' }
MDMailProfile >> smtpServer [

	^ smtpServer
]

{ #category : 'accessing' }
MDMailProfile >> smtpServer: anObject [

	smtpServer := anObject
]

{ #category : 'accessing' }
MDMailProfile >> smtpServerPort [

	^ smtpServerPort
]

{ #category : 'accessing' }
MDMailProfile >> smtpServerPort: anObject [

	smtpServerPort := anObject
]

{ #category : 'accessing' }
MDMailProfile >> smtpUsername [

	^ smtpUsername
]

{ #category : 'accessing' }
MDMailProfile >> smtpUsername: anObject [

	smtpUsername := anObject
]

{ #category : 'actions' }
MDMailProfile >> storeSentMessage: aMessage [

	self archive storeSentMail: aMessage
	
]

{ #category : 'accessing' }
MDMailProfile >> userEmailAddress [

	^ userEmailAddress
]

{ #category : 'accessing' }
MDMailProfile >> userEmailAddress: anObject [

	userEmailAddress := anObject
]
