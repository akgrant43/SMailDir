tests
testSynchronizationOfSubFoldersRemovesSubBoxes

	| yab |

	yab := archiveDirectory / (boxName , '.' , 'yetAnotherBox').
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.
	
	yab deleteAll.
	
	archive synchronizeBoxes.
	
	self assert: 5 equals: archive allBoxes size.
	self assert: (archive allBoxes noneSatisfy: [:b | b boxName = 'yetAnotherBox']).