instance creation
fromSton: stonReader

	| archive |

	archive := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			archive perform: (key, ':') with: value ] ].
	^archive