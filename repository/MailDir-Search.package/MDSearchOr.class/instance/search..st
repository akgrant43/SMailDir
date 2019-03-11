searching
search: aMDMail
	"Search each of the receiver's children and terminate as soon as possible, 
	i.e. on the first false"

	children do: [ :each | (each search: aMDMail) ifTrue: [ ^true ] ].
	^false