private
messageTextIn: aMimeEntity on: aStream
	"Write the text in aMimeEntity and its parts on aStream"

	aMimeEntity ifNil: [ ^self ].
	(aMimeEntity contentType main = 'text') ifTrue: 
		[ aStream 
			<< aMimeEntity contents;
			cr ].
	aMimeEntity partsDo: [ :part |
		self messageTextIn: part on: aStream ].
