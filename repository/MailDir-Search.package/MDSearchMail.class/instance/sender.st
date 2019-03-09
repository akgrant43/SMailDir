accessing
sender
	^ sender ifNil: [ sender := mdMail sender asLowercase asNonDiacritical ]