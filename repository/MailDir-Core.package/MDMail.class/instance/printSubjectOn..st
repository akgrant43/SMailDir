printing
printSubjectOn: aStream

	| max |
	subject ifNil: 
		[ aStream << '(no subject)' ]
	ifNotNil:
		[ max := 72.
		aStream nextPutAll:  
			(self subject size > max
				ifFalse: [self subject]
				ifTrue: [(String streamContents: [:s | s nextPutAll: self subject] limitedTo: max-2),'..']) ]