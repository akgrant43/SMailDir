Class {
	#name : #MDSearchGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'expression',
		'searchAnd',
		'searchOr',
		'word',
		'ampersand',
		'pipe',
		'openBracket',
		'closeBracket',
		'parentheses',
		'primary'
	],
	#category : 'MailDir-Search'
}

{ #category : #grammar }
MDSearchGrammar >> ampersand [ 

	^$& asPParser
]

{ #category : #tokens }
MDSearchGrammar >> closeBracket [
	^ $) asPParser
]

{ #category : #grammar }
MDSearchGrammar >> expression [ 

	^searchAnd / searchOr / primary
]

{ #category : #tokens }
MDSearchGrammar >> openBracket [
	^ $( asPParser
]

{ #category : #grammar }
MDSearchGrammar >> parentheses [
	^ openBracket trim , expression , closeBracket trim
]

{ #category : #grammar }
MDSearchGrammar >> pipe [

	^$| asPParser
]

{ #category : #grammar }
MDSearchGrammar >> primary [
	^ word / parentheses
]

{ #category : #grammar }
MDSearchGrammar >> searchAnd [ 

	^primary, ampersand trim, expression
]

{ #category : #grammar }
MDSearchGrammar >> searchOr [

	^primary, pipe trim, expression
]

{ #category : #accessing }
MDSearchGrammar >> start [

	^expression end
]

{ #category : #grammar }
MDSearchGrammar >> word [ 

	^#identifier asPParser plus flatten
]
