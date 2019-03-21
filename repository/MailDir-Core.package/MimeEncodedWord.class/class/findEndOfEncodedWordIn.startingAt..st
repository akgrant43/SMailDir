private
findEndOfEncodedWordIn: aString startingAt: start
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
	