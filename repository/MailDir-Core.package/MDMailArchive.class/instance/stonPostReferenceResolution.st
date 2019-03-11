ston persistence
stonPostReferenceResolution 

	| convIndex |

	"The conversationIndex has been serialised as an Array of associations.
	Convert back to a WeakKeyDictionary"
	convIndex := WeakKeyDictionary new.
	conversationIndex do: [ :assoc |
		convIndex at: assoc key put: assoc value ].
	conversationIndex := convIndex.
