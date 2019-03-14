accessing
fileStream
	"Answer the contents of the first of the receiver's files.
	Messages are ascii encoded by default."

	^self file readStreamEncoded: 'null'
	"^[self file contents ]
		on: ZnInvalidUTF8 
		do: [ [self file readStreamEncoded: 'iso88592' do: [ :stream | stream upToEnd ] ]
				on: ZnCharacterEncodingError 
				do: [ self file readStreamEncoded: 'null' do: [ :stream2 | stream2 upToEnd ] ] ]."
