Class {
	#name : #MimeEncodedWord,
	#superclass : #Object,
	#classVars : [
		'Encoders',
		'QPTranslation'
	],
	#category : 'MailDir-Core'
}

{ #category : #decoding }
MimeEncodedWord class >> decodeEncodedWord: aString [
	"Decode the supplied encoded word.  
	Don't return an error, just the best possible decoding"

	| readStream characterEncoding stringEncoding string encoder |

	"'\=\?(iso-8859-.|utf-8)\?([qb])\?(.*)\?=' asRegexIgnoringCase."
	readStream := aString readStream.
	(readStream next: 2) = '=?' ifFalse: [ ^aString ].

	characterEncoding := (readStream upTo: $?) asLowercase.
	stringEncoding := readStream next asUppercase.
	readStream next = $? ifFalse: [ ^aString ].
	string := readStream upTo: $?.

	string := [ stringEncoding = $Q ifTrue: 
			[self decodeQPString: string]
		ifFalse: [ stringEncoding = $B ifTrue: 
			[string base64Decoded]
		ifFalse: [ ^aString ]]]
			on: Error
			do: [ ^aString ].
	encoder := characterEncoding = 'utf-8'
		ifTrue: [ ZnCharacterEncoder utf8 ]
		ifFalse: [ ZnCharacterEncoder newForEncoding: characterEncoding ].
	string := [ encoder decodeBytes: string asByteArray ]
		on: Error 
		do: [ ^string asString ].

	^string
]

{ #category : #private }
MimeEncodedWord class >> decodeQPString: aString [
	"Decode the Mime Encoded QP string"

	| readStream byte resultStream |

	readStream := aString readStream.
	resultStream := ByteArray new writeStream.
	[ readStream atEnd ] whileFalse:
		[ byte := readStream next.
		byte = $_ ifTrue:
			[ resultStream nextPut: 32 "space" ]
		ifFalse: [ byte = $= ifTrue:
			[ resultStream nextPut: (readStream next digitValue * 16 + readStream next digitValue) ]
		ifFalse:
			[ resultStream nextPut: byte asInteger ] ] ].
	^resultStream contents
]

{ #category : #decoding }
MimeEncodedWord class >> decodeString: aString [
	"Decode the supplied string, which may contain 0 or more encoded words.
	Don't raise an error, just the best possible decoding"

	| resultStream start end |

	start := aString indexOfSubCollection: '=?'.
	start = 0 ifTrue: [ ^aString ].
	resultStream := String new writeStream.
	end := -1.
	[ start = 0 ] whileFalse:
		[ resultStream nextPutAll: (aString copyFrom: end+2 to: start-1).
		end := self findEndOfEncodedWordIn: aString startingAt: start.
		"end := aString indexOfSubCollection: '?=' startingAt: start".
		resultStream nextPutAll: (self decodeEncodedWord: (aString copyFrom: start to: end+1)).
		start := aString indexOfSubCollection: '=?' startingAt: end ].
	resultStream nextPutAll: (aString copyFrom: end+2 to: aString size).
	^resultStream contents
]

{ #category : #encoding }
MimeEncodedWord class >> encodeString: aString coding: coding charSet: charSet [

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
]

{ #category : #private }
MimeEncodedWord class >> findEndOfEncodedWordIn: aString startingAt: start [
	"Answer the index of the end of the encoded word starting at start,
	i.e. the index of the trailing '='"

	| endIndex followingIndex |

	endIndex := aString indexOfSubCollection: '?=' startingAt: start.
	endIndex = 0 ifTrue:
		"Assume word continues to the end of the string"
		[ ^aString size - 1 ].

	followingIndex := endIndex + 2.
	(followingIndex > aString size or: [ (aString at: followingIndex) isHexDigit not ])
		ifTrue: [ ^endIndex ]
		ifFalse: [ ^self findEndOfEncodedWordIn: aString startingAt: endIndex+1 ]
	
]

{ #category : #'class initialization' }
MimeEncodedWord class >> initialize [ 

	Encoders := { 
		#'utf-8' -> ZnCharacterEncoder utf8.
		#'iso-8859-1' -> (ZnCharacterEncoder newForEncoding: #'iso-8859-1') } asDictionary.

	QPTranslation := { 
		32 " " -> #'_'.
		61 "=" -> #'=3D'.
		63 "?" -> #'=3F'.
		 } asDictionary.
]

{ #category : #writing }
MimeEncodedWord class >> writeBase64: charEncoded on: stream [
	"Write the supplied ByteArray base64 encoded on stream"

	"stream nextPutAll: charEncoded base64Encoded"
	ZnBase64Encoder new encode: charEncoded readStream to: stream
]

{ #category : #private }
MimeEncodedWord class >> writeQP: charEncoded on: stream [
	"Write the supplied ByteArray on stream"

	charEncoded do: [ :byte | | encoded |
		encoded := QPTranslation at: byte ifAbsent: [ ].
		encoded ifNotNil: 
			[ stream << encoded ]
		ifNil: 
			[ (byte between: 33 and: 126) ifTrue: 
				[ stream nextPut: byte asCharacter ]
			ifFalse:
				[ stream nextPut: $=.
				stream << (byte printPaddedWith: $0 to: 2 base: 16) ] ] ]
]
