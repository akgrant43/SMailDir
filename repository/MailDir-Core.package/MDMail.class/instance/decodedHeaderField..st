private
decodedHeaderField: fieldName
	"Answer the header field decoded as a Mime Encoded-Word.
	The header must have been already cached."

	| values value |

	values := header at: fieldName ifAbsent: [ ^nil ].
	value := values isString 
		ifTrue: [ values ]
		ifFalse: [ ', ' join: values ].
	^MimeEncodedWord decodeString: value trimBoth.