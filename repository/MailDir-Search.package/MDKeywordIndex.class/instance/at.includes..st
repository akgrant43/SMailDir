searching
at: keyword includes: messageId
	"Answer a boolean indicating whether the supplied messageId contains keyword"

	^indexMutex critical:
		[ (index at: keyword ifAbsent: #()) includes: messageId ]