private
humanDateStringFor: aDateAndTime

	| localTime |

	localTime := aDateAndTime asLocal.
	^localTime asDate = Date today ifTrue: 
		[ String streamContents: [ :stream | localTime asTime
			print24: true showSeconds: false on: stream ] ]
	ifFalse:
		[ localTime asDate printFormat: #(1 2 3 $  2 1) ]