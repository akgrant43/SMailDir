tests
testEncodeUTF8

	self 
		assert: (MimeEncodedWord encodeString: 'abc=éíá?' coding: $B charSet: #'utf-8')
		equals: '=?utf-8?B?YWJjPcOpw63DoT8=?='.

	self
		assert: (MimeEncodedWord encodeString: 'abc+ěščřžýáíé' coding: $B charSet: #'utf-8')
		equals: '=?utf-8?B?YWJjK8SbxaHEjcWZxb7DvcOhw63DqQ==?='.