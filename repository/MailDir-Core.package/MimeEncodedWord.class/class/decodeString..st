decoding
decodeString: aString
	"Decode the supplied string, which may contain 0 or more encoded words.
	Don't raise an error, just the best possible decoding"

	| resultStream start end |

	start := aString indexOfSubCollection: '=?'.
	start = 0 ifTrue: [ ^aString ].
	resultStream := String new writeStream.
	end := -1.
	[ start = 0 ] whileFalse:
		[ resultStream nextPutAll: (aString copyFrom: end+2 to: start-1).
		end := aString indexOfSubCollection: '?=' startingAt: start.
		resultStream nextPutAll: (self decodeEncodedWord: (aString copyFrom: start to: end+1)).
		start := aString indexOfSubCollection: '=?' startingAt: end ].
	resultStream nextPutAll: (aString copyFrom: end+2 to: aString size).
	^resultStream contents