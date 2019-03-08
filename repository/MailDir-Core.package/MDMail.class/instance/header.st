accessing
header
	"Read the header records from the receiver's file if necessary.
	ToDo: Add retry with different file encodings, e.g. ISO88592"

	| contents |

	^header ifNil: 
		[ contents := [self file reference contents ]
				on: ZnInvalidUTF8 
				do: [ self file reference readStreamEncoded: 'iso88592' do: [ :stream | stream upToEnd ] ].
		header := MailMessage fromRfc822: contents ]

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