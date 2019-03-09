accessing
senderName
	^ senderName ifNil: [ mdMail senderName asLowercase asNonDiacritical ]