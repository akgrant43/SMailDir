accessing
header
	"Read the header records from the receiver's file.
	Don't cache to reduce memory."

	| stream |

	thisContext sender selector = #initializeHeaderInformation ifFalse: [ self halt ].
	stream := self fileStream.
	^[ MailMessage fromRfc822: stream headersOnly: true ]
		ensure: [ stream close ]

"	^ header ifNil: [ | stream result line |
		self file readStreamDo: [ :rstream |
			stream := ZnFastLineReader on: rstream.
			result := String streamContents: [ :sstream |
				line := stream nextLine trimLeft.
				[ line isEmpty ] whileFalse:
					[ sstream 
						nextPutAll: line;
						cr.
					line := stream nextLine trimLeft ] ].
			header := MailMessage from: result ] ].
"