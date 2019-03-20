tests
testDecodeString

	self 
		assert: (MimeEncodedWord decodeString: '=?utf-8?B?YWJjPcOpw63DoT8=?=')
		equals: 'abc=éíá?'.

	self
		assert: (MimeEncodedWord decodeString: '=?iso-8859-1?Q?=A1Hola,_se=F1or!?=')
		equals: '¡Hola, señor!'.

	self 
		assert: (MimeEncodedWord decodeString: '=?utf-8?B?YWJjPcOpw63DoT8=?= and =?iso-8859-1?Q?=A1Hola,_se=F1or!?=')
		equals: 'abc=éíá? and ¡Hola, señor!'.
