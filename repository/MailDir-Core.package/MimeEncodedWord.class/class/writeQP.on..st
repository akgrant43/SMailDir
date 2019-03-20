private
writeQP: charEncoded on: stream
	"Write the supplied ByteArray on stream"

	charEncoded do: [ :byte | | encoded |
		encoded := QPTranslation at: byte ifAbsent: [ ].
		encoded ifNotNil: 
			[ stream << encoded ]
		ifNil: 
			[ (byte between: 33 and: 126) ifTrue: 
				[ stream nextPut: byte asCharacter ]
			ifFalse:
				[ stream nextPut: $=.
				stream << (byte printPaddedWith: $0 to: 2 base: 16) ] ] ]