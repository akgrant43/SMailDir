Class {
	#name : #MDSearchDateAfter,
	#superclass : #MDSearchNode,
	#instVars : [
		'date'
	],
	#category : 'MailDir-Search'
}

{ #category : #accessing }
MDSearchDateAfter >> date [
	^ date
]

{ #category : #accessing }
MDSearchDateAfter >> date: anObject [
	date := anObject
]

{ #category : #searching }
MDSearchDateAfter >> search: aMDSearchMail [

	^aMDSearchMail timestamp >= date
]
