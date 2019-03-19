private
messageTextIn: aMimePart
	"Answer the text in aMimeEntity and its parts"

	^String streamContents: [ :stream |
		self messageTextIn: aMimePart entity on: stream ]