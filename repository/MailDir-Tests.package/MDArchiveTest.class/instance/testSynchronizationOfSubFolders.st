tests
testSynchronizationOfSubFolders

	| yab |

	yab := archiveDirectory / (boxName , '.' , 'yetAnotherBox').
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].

	archive synchronizeBoxes.
	
	self assert: 6 equals: archive allBoxes size.
	self assert: (archive allBoxes anySatisfy: [:b | b boxName = 'yetAnotherBox']).