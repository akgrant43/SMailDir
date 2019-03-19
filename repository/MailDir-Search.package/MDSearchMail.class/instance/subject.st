accessing
subject
	^ subject ifNil: [ subject := (mdMail subject ifNil: [ '' ]) asLowercase asNonDiacritical ]