accessing
timestamp
	^ timestamp ifNil: [ timestamp := mdMail timestamp ]