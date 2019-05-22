enumerating
wordsDo: aBlock
	"Evaluate aBlock for each of the receivers words"

	self children do: [ :child | child wordsDo: aBlock ]