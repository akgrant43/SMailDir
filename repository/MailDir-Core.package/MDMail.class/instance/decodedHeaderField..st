private
decodedHeaderField: fieldName
	"Answer the header field decoded as a Mime Encoded-Word.
	The header must have been already cached."

	| value |

	value := header at: fieldName ifAbsent: [ ^nil ].
	^MimeEncodedWord decodeString: value