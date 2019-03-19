accessing
body
	^ body ifNil: [ body := (self messageTextIn: mdMail message) asLowercase asNonDiacritical ]