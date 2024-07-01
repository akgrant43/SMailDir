Extension { #name : #PP2NodeFactory }

{ #category : #'*MailDir-Search' }
PP2NodeFactory >> identifier [
	^ PP2PredicateObjectNode new
		predicate: (PP2CharSetPredicate on: [ :char | char isAlphaNumeric or: 
			[ '_@.' includes: char ] ]);
		predicateMessage: 'identifier expected';
		negated: (PP2CharSetPredicate on: [ :char | (char isAlphaNumeric or: 
			[ '_@.' includes: char ]) not ]);
		negatedMessage: 'identifier not expected';
		yourself
]
