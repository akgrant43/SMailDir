searching
search: expressionString

	^(Array streamContents: [ :stream |
		self search: expressionString onStream: stream ])
			sorted: #date descending