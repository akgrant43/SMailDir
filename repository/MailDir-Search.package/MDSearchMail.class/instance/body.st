accessing
body
	^ body ifNil: [ body := mdMail message body contents asLowercase asNonDiacritical ]