accessing
testDoubleMessageFlags
	self assert: (doubleMessageEntry flags includesAll: #($F $S)).
	self assert: doubleMessageEntry flags size = 2