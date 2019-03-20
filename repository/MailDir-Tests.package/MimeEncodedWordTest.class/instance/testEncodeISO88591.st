tests
testEncodeISO88591

	self 
		assert: (MimeEncodedWord encodeString: 'abc=éíá?' coding: $Q charSet: #'iso-8859-1')
		equals: '=?iso-8859-1?Q?abc=3D=E9=ED=E1=3F?='.

	self
		assert: (MimeEncodedWord encodeString: '¡Hola, señor!' coding: $Q charSet: #'iso-8859-1')
		equals: '=?iso-8859-1?Q?=A1Hola,_se=F1or!?='.