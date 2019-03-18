accessing
header
	"Read the header records from the receiver's file.
	Don't cache to reduce memory."

	"thisContext sender selector = #initializeHeaderInformation ifFalse: [ self halt ]."
	^self file binaryReadStreamDo: [ :bstream |
		ZnHeaders readFrom: (AkgMimeStream on: bstream) ].

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