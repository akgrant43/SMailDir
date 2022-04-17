mails
message
	"Answer the MIME document of the receiver.
	Emails should assume ascii as the default encoding."
	| options |

	options := ZnOptions root clone
		at: #maximumEntitySize put: 2 ** 26 "64MB";
		yourself.
	^ self file binaryReadStreamDo: [ :bstream |
		ZnCurrentOptions
			value: options
			during: 
				[ ZnDefaultCharacterEncoder 
					value: (ZnCharacterEncoder newForEncoding: #'null')
					during: [ ZnMimePart readFrom: (AkgMimeStream on: bstream) ] ] ].
