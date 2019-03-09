accessing
recipients
	^ recipients ifNil: [ recipients := mdMail recipients asLowercase asNonDiacritical ]