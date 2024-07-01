Class {
	#name : #MDSearchAnd,
	#superclass : #MDSearchNode,
	#instVars : [
		'children'
	],
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDSearchAnd class >> children: aCollection [

	^self new children: aCollection
]

{ #category : #accessing }
MDSearchAnd >> add: aMDSearchNode [

	children := children, {aMDSearchNode}
]

{ #category : #accessing }
MDSearchAnd >> children [
	^ children
]

{ #category : #accessing }
MDSearchAnd >> children: anObject [
	children := anObject
]

{ #category : #initialization }
MDSearchAnd >> initialize [ 

	super initialize.
	children := Array new.
]

{ #category : #searching }
MDSearchAnd >> search: aMDMail [
	"Search each of the receiver's children and terminate as soon as possible, 
	i.e. on the first false"

	children do: [ :each | (each search: aMDMail) ifFalse: [ ^false ] ].
	^true
]
