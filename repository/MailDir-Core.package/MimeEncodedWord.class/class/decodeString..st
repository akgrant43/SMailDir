decoding
decodeString: aString
	"Decode the supplied string.
	Don't return an error, just the best possible decoding"

	| readStream characterEncoding stringEncoding string encoder resultStream |

	"'\=\?(iso-8859-.|utf-8)\?([qb])\?(.*)\?=' asRegexIgnoringCase."
	readStream := aString readStream.

	(readStream next: 2) = '=?' ifFalse: [ ^aString ].
	characterEncoding := (readStream upTo: $?) asLowercase.
	stringEncoding := readStream next asUppercase.
	readStream next = $? ifFalse: [ ^aString ].
	string := readStream upToAll: '?='.

	string := [ stringEncoding = $Q ifTrue: 
			[string decodeQuotedPrintable]
		ifFalse: [ stringEncoding = $B ifTrue: 
			[string base64Decoded]
		ifFalse: [ ^aString ]]]
			on: Error
			do: [ ^aString ].
	encoder := characterEncoding = 'utf-8'
		ifTrue: [ ZnCharacterEncoder utf8 ]
		ifFalse: [ ZnCharacterEncoder iso88591 ].
	string := [ encoder decodeBytes: string asByteArray ]
		on: Error 
		do: [ ^string ].

	resultStream := (String new: string size) writeStream.
	resultStream << string.
	[ readStream peek isSeparator ] whileTrue:
		[ resultStream nextPut: readStream next ].

	readStream atEnd ifFalse: 
		[ resultStream nextPutAll: (self decodeString: readStream upToEnd) ].

	^resultStream contents