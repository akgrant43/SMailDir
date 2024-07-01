Class {
	#name : #MDSearchNode,
	#superclass : #Object,
	#category : 'MailDir-Search'
}

{ #category : #accessing }
MDSearchNode >> children [ 
	"All nodes accept the concept of children"

	^#()
]

{ #category : #accessing }
MDSearchNode >> index: aMDKeywordIndex [

	self children do: [ :child | child index: aMDKeywordIndex ]
]

{ #category : #searching }
MDSearchNode >> search: aZnMimePart [
	"Answer a boolean indicating whether the supplied mail matches the receiver"

	self subclassResponsibility 
]

{ #category : #enumerating }
MDSearchNode >> wordsDo: aBlock [
	"Evaluate aBlock for each of the receivers words"

	self children do: [ :child | child wordsDo: aBlock ]
]
