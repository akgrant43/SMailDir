accessing
senderAddress
	^ senderAddress ifNil: [ mdMail senderAddress asLowercase asNonDiacritical ]