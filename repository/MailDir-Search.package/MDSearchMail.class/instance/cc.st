accessing
cc
	^ cc ifNil: [ mdMail cc asLowercase asNonDiacritical ]