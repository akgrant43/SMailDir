private
decodeQPString: aString
	"Decode the Mime Encoded QP string"

	| readStream byte resultStream |

	readStream := aString asByteArray readStream.
	resultStream := ByteArray new writeStream.
	[ readStream atEnd ] whileFalse:
		[ byte := readStream next.
		byte = 95 "_" ifTrue:
			[ resultStream nextPut: 32 "space" ]
		ifFalse: [ byte = 61 "=" ifTrue:
			[ resultStream nextPut: (readStream next digitValue * 16 + readStream next digitValue) ]
		ifFalse:
			[ resultStream nextPut: byte ] ] ].
	^resultStream contents