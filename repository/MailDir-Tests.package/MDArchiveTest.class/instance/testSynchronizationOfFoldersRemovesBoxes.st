tests
testSynchronizationOfFoldersRemovesBoxes

	| yab |

	yab := archiveDirectory / 'yetAnotherBox'.
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.

	yab deleteAll.
	
	archive synchronizeBoxes.
	
	self assert: 5 equals: archive boxes size.
	self assert: (archive boxes noneSatisfy: [:b | b boxName = 'yetAnotherBox']).