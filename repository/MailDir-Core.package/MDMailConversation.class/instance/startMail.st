accessing
startMail

	| links |
	links := mails collect: [:m |
		{m messageId . m inReplyTo . m}].

	^ (links detect: [:l | links noneSatisfy: [:l2 | l2 first = l second] ]) third