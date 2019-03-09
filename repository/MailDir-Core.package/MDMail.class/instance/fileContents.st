accessing
fileContents
	"Answer the contents of the first of the receiver's files"

	^[self file reference contents ]
		on: ZnInvalidUTF8 
		do: [ [self file reference readStreamEncoded: 'iso88592' do: [ :stream | stream upToEnd ] ]
				on: ZnCharacterEncodingError 
				do: [ self file reference readStreamEncoded: 'null' do: [ :stream2 | stream2 upToEnd ] ] ].
