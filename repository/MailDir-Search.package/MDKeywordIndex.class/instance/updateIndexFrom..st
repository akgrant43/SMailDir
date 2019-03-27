index management
updateIndexFrom: searchNode
	"Ensure all the search terms in the supplied node are indexed"

	| updateRequired |

	updateRequired := false.
	searchNode wordsDo: [ :term |
		(self includesKeyword: term) ifFalse: 
			[ updateRequired := true.
			self addKeyword: term ] ].
	updateRequired ifTrue: [ self reindex ]