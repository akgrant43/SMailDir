private
decodeQPString: aString
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