instance creation
fromSton: stonReader

	| conversation |

	conversation := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			conversation perform: (key, ':') with: value ] ].
	^conversation