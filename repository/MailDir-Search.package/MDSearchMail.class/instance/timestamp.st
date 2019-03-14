accessing
timestamp
	^ timestamp ifNil: [ timestamp := mdMail date ]