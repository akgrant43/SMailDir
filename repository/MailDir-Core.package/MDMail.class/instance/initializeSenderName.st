initialize-release
initializeSenderName

	| nameAndAddress |
	sender isEmptyOrNil ifTrue: [^ senderName := 'unkown'].
	[nameAndAddress := (MailAddressParser addressesIn: sender) first]
		on: Error
		do: [:e | senderName := 'unretrievable'. ^ self].
	"In Pharo, MailAddressParser appears to only return the email address string (name is discarded)"
	senderName := nameAndAddress.
"	senderName := nameAndAddress first
		ifEmpty: [nameAndAddress second]
		ifNotEmpty: [nameAndAddress first]."