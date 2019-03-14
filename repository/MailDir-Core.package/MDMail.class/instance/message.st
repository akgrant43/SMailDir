mails
message

	| stream |

	stream := self fileStream.
	^ [ MailMessage fromRfc822: stream ]
		ensure: [ stream close ]