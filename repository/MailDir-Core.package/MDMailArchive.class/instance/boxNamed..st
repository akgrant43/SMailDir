boxes
boxNamed: aRelativeBoxName

	| box boxNameParts |

	self boxes detect: [ :b | b boxName = aRelativeBoxName ] ifFound: [ :b | ^b ].
	boxNameParts := aRelativeBoxName findTokens: '.'.
	boxNameParts size = 0 ifTrue: [^self].
	^ (self boxes detect: [:b | b boxName = boxNameParts first]) boxNamed: ('.' join: boxNameParts allButFirst)