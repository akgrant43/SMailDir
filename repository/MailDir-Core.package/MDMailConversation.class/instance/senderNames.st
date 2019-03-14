accessing
senderNames

	^ ', ' join: (self mails collect: [:ea | ea senderName]) asSet