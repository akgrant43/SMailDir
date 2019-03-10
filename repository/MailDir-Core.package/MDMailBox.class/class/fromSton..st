instance creation
fromSton: stonReader

	| mailBox |

	mailBox := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			mailBox perform: (key, ':') with: value ] ].
	^mailBox