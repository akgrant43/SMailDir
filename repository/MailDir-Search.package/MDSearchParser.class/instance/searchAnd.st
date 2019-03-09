operators
searchAnd

	^super searchAnd ==> [ :nodes | MDSearchAnd children: { nodes first. nodes third. } ]