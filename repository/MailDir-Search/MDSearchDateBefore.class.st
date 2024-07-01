Class {
	#name : #MDSearchDateBefore,
	#superclass : #MDSearchNode,
	#instVars : [
		'date'
	],
	#category : 'MailDir-Search'
}

{ #category : #accessing }
MDSearchDateBefore >> date [
	^ date
]

{ #category : #accessing }
MDSearchDateBefore >> date: anObject [
	date := anObject
]

{ #category : #searching }
MDSearchDateBefore >> search: aMDSearchMail [

	^aMDSearchMail <= date
]
