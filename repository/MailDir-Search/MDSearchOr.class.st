Class {
	#name : #MDSearchOr,
	#superclass : #MDSearchNode,
	#instVars : [
		'children'
	],
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDSearchOr class >> children: aCollection [

	^self new children: aCollection
]

{ #category : #accessing }
MDSearchOr >> add: aMDSearchNode [

	children := children, {aMDSearchNode}
]

{ #category : #accessing }
MDSearchOr >> children [
	^ children
]

{ #category : #accessing }
MDSearchOr >> children: anObject [
	children := anObject
]

{ #category : #initialization }
MDSearchOr >> initialize [ 

	super initialize.
	children := Array new.
]

{ #category : #searching }
MDSearchOr >> search: aMDMail [
	"Search each of the receiver's children and terminate as soon as possible, 
	i.e. on the first false"

	children do: [ :each | (each search: aMDMail) ifTrue: [ ^true ] ].
	^false
]
