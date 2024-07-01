Class {
	#name : #MDSearchWord,
	#superclass : #MDSearchNode,
	#instVars : [
		'word',
		'regex',
		'index'
	],
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDSearchWord class >> word: aString [

	^self new word: aString
]

{ #category : #accessing }
MDSearchWord >> index [
	^ index
]

{ #category : #accessing }
MDSearchWord >> index: aMDKeywordIndex [

	index := aMDKeywordIndex
]

{ #category : #searching }
MDSearchWord >> search: aMDSearchMail [

	^(index isNil or: [(index isIndexed: word) not]) ifTrue:
		[(self searchSubject: aMDSearchMail) or: [ 
			(self searchSender: aMDSearchMail) or: [ 
			(self searchRecipients: aMDSearchMail) or: [ 
			(self searchBody: aMDSearchMail) ] ] ] ]
	ifFalse:
		[ index at: word includes: aMDSearchMail messageId ]
]

{ #category : #searching }
MDSearchWord >> searchBody: aMDSearchMail [

	^regex search: aMDSearchMail body
]

{ #category : #searching }
MDSearchWord >> searchRecipients: aMDSearchMail [

	^regex search: aMDSearchMail recipients
]

{ #category : #searching }
MDSearchWord >> searchSender: aMDSearchMail [

	^regex search: aMDSearchMail sender
]

{ #category : #searching }
MDSearchWord >> searchSubject: aMDSearchMail [

	^regex search: aMDSearchMail subject
]

{ #category : #accessing }
MDSearchWord >> word [
	^ word
]

{ #category : #accessing }
MDSearchWord >> word: aString [

	word := aString.
	regex := aString asRegexIgnoringCase
]

{ #category : #enumerating }
MDSearchWord >> wordsDo: aBlock [
	"Evaluate aBlock for each of the receivers words"

	aBlock value: word
]
