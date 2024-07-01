Class {
	#name : #MimeEncodedWordTest,
	#superclass : #TestCase,
	#category : 'MailDir-Tests'
}

{ #category : #tests }
MimeEncodedWordTest >> testDecodeString [

	self 
		assert: (MimeEncodedWord decodeString: '=?utf-8?B?YWJjPcOpw63DoT8=?=')
		equals: 'abc=éíá?'.

	self
		assert: (MimeEncodedWord decodeString: '=?iso-8859-1?Q?=A1Hola,_se=F1or!?=')
		equals: '¡Hola, señor!'.

	self 
		assert: (MimeEncodedWord decodeString: '=?utf-8?B?YWJjPcOpw63DoT8=?= and =?iso-8859-1?Q?=A1Hola,_se=F1or!?=')
		equals: 'abc=éíá? and ¡Hola, señor!'.

]

{ #category : #tests }
MimeEncodedWordTest >> testEncodeISO88591 [

	self 
		assert: (MimeEncodedWord encodeString: 'abc=éíá?' coding: $Q charSet: #'iso-8859-1')
		equals: '=?iso-8859-1?Q?abc=3D=E9=ED=E1=3F?='.

	self
		assert: (MimeEncodedWord encodeString: '¡Hola, señor!' coding: $Q charSet: #'iso-8859-1')
		equals: '=?iso-8859-1?Q?=A1Hola,_se=F1or!?='.
]

{ #category : #tests }
MimeEncodedWordTest >> testEncodeUTF8 [

	self 
		assert: (MimeEncodedWord encodeString: 'abc=éíá?' coding: $B charSet: #'utf-8')
		equals: '=?utf-8?B?YWJjPcOpw63DoT8=?='.

	self
		assert: (MimeEncodedWord encodeString: 'abc+ěščřžýáíé' coding: $B charSet: #'utf-8')
		equals: '=?utf-8?B?YWJjK8SbxaHEjcWZxb7DvcOhw63DqQ==?='.
]
