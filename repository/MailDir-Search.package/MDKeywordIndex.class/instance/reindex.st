index management
reindex
	"Reindex all the receivers keywords"

	| searchTerms dateFrom |

	self keywords ifEmpty: [ ^self ].
	dateFrom := MDSearchDateAfter new 
		date: reindexDate;
		yourself.
	searchTerms := self keywords collect: [ :keyword |
		keyword -> (MDSearchAnd new
			add: dateFrom;
			add: (MDSearchWord word: keyword);
			yourself) ].
	archive allMailsDo: [ :each | | searchMail |
		searchMail := MDSearchMail mdMail: each.
		searchTerms do: [ :searchTerm |
			(searchTerm value search: searchMail) ifTrue: 
				[ indexMutex critical: 
					[ (index at: searchTerm key) add: each messageId ] ] ] ].
