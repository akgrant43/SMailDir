tests
testStoreSentMail

	| mail |
	self skip: 'MailMessage still broken on Pharo'.

	"mail := archive storeSentMail: self sentMailMessage.
 
	self assert: (sentBox mails includes: mail).
	self assert: (mail boxes includes: sentBox).
	
	self assert: ((sentBoxDirectory / 'cur') children includes: mail file)  "