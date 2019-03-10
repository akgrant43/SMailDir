instance creation
fromSton: stonReader

	| mail |

	mail := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		each keysAndValuesDo: [ :key :value |
			mail perform: (key, ':') with: value ] ].
	^mail