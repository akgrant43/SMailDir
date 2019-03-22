mails
message
	"Answer the MIME document of the receiver.
	Emails should assume ascii as the default encoding."

	^self file binaryReadStreamDo: [ :bstream |
		ZnMaximumEntitySize
			value: (2 ** 26)
			during: 
				[ ZnDefaultCharacterEncoder 
					value: (ZnCharacterEncoder newForEncoding: #'null')
					during: [ ZnMimePart readFrom: (AkgMimeStream on: bstream) ] ] ].
