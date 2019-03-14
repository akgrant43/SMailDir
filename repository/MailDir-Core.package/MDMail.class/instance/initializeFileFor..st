initialize-release
initializeFileFor: aMessage

	| fileName folder |
	self assert: self boxes size = 1.
	folder := self boxes first currentMessagesDirectory.
	fileName := folder / (self generateFileNameFor: aMessage).
	fileName writeStreamEncoded: 'null' do: [ :stream |
		stream << aMessage asSendableText].
	self addBox: self boxes first with: fileName