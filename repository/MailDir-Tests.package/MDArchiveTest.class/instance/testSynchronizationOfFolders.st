tests
testSynchronizationOfFolders

	| yab |

	yab := archiveDirectory / 'yetAnotherBox'.
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.
	
	self assert: 6 equals: archive boxes size.
	self assert: (archive boxes anySatisfy: [:b | b boxName = 'yetAnotherBox']).