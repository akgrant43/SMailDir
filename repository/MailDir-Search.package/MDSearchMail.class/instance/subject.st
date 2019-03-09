accessing
subject
	^ subject ifNil: [ subject := mdMail subject asLowercase asNonDiacritical ]