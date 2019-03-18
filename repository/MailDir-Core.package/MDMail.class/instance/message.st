mails
message

	^self file binaryReadStreamDo: [ :bstream |
		ZnMimePart readFrom: (AkgMimeStream on: bstream) ].
