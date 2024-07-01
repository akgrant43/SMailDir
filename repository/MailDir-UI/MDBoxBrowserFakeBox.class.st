Class {
	#name : #MDBoxBrowserFakeBox,
	#superclass : #Object,
	#instVars : [
		'originalBox'
	],
	#category : 'MailDir-UI'
}

{ #category : #accessing }
MDBoxBrowserFakeBox >> originalBox [

	^ originalBox
]

{ #category : #accessing }
MDBoxBrowserFakeBox >> originalBox: anObject [

	originalBox := anObject
]
