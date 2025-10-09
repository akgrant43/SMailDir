Extension { #name : 'MailMessage' }

{ #category : '*MailDir-Core' }
MailMessage >> messageId [
	^self fieldsNamed: 'message-id' separatedBy: ', '
]
