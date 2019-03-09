operators
searchOr

	^super searchOr ==> [ :nodes | MDSearchOr children: { nodes first. nodes third. } ]