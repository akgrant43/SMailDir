accessing
includesKeyword: aString
	"Answer a boolean indicating if the supplied keyword is currently indexed"

	^indexMutex critical: [ index includesKey: aString ]