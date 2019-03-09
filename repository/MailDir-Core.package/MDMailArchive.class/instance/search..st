searching
search: expressionString
	"Search the receives messages and answer a collection of message matching the supplied expression"

	^MDSearchParser search: expressionString inArchive: self.