encoding
encodeString: aString coding: coding charSet: charSet

	| result encoder charEncoded |

	encoder := Encoders at: charSet 
		ifAbsent: [ self error: 'Invalid character encoding' ].
	('QB' includes: coding) ifFalse: 
		[ self error: 'Invalid coding' ].
	result := String new writeStream.
	result 
		<< '=?';
		<< charSet;
		<< '?';
		<< coding;
		<< '?'.

	charEncoded := encoder encodeString: aString.
	coding = $Q
		ifTrue: [ self writeQP: charEncoded on: result ]
		ifFalse: [ self writeBase64: charEncoded on: result ].
	result << '?='.
	^result contents