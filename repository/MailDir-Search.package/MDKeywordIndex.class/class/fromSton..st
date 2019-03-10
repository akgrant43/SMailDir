instance creation
fromSton: stonReader

	| index |

	index := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		index
			directory: (each at: 'directory');
			archiveName: (each at: 'archiveName');
			trashBoxName: (each at: 'trashBoxName');
			index: (each at: 'index') ].
	^index