private
timestampFrom: aString
	"Answer a DateAndTime from aString"

	| regex dateString tsDate tsTime offsetString offset minutes |

	dateString := aString.
	regex := '(\d\d? \w\w\w \d\d\d\d) (\d\d\:\d\d\:\d\d)\s?([-+]\d\d\d\d|GMT)?' asRegex.
	(regex search: dateString) ifFalse: [ self error: 'Unable to parse date' ].
	tsDate := Date readFrom: (regex subexpression: 2) readStream.
	tsTime := Time readFrom: (regex subexpression: 3) readStream.
	offsetString := regex subexpression: 4.
	
	minutes := (offsetString isNil or: [ offsetString = 'GMT']) ifTrue:
		[ 0 ]
	ifFalse:
		[ ((((offsetString second codePoint - 16r30) * 10) +
			(offsetString third codePoint - 16r30)) * 60 +
			(((offsetString fourth codePoint - 16r30) * 10) +
			(offsetString fifth codePoint - 16r30))) *
			(offsetString first = $- ifTrue: [ -1 ] ifFalse: [ 1 ]) ].
	offset := Duration minutes: minutes. 
 	^DateAndTime
		year: tsDate year
		month: tsDate monthName
		day: tsDate dayOfMonth
		hour: tsTime hour
		minute: tsTime minute 
		second: tsTime second 
		nanoSecond: 0
		offset: offset.