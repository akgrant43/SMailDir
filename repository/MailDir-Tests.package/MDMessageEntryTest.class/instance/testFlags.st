accessing
testFlags
	self assert: (messageEntry flags includesAll: #($R $S)).
	self assert: messageEntry flags size = 2