accessing
recipients
	^ recipients ifNil: [ recipients := (mdMail recipients ifNil: [ '' ]) asLowercase asNonDiacritical ]