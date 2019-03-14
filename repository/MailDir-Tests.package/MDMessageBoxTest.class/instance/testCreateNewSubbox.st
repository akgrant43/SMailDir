tests
testCreateNewSubbox

	| subBox |

	box createSubBoxNamed: 'myNewSubBox'.
	subBox := archiveDirectory / (boxName , '.' , 'myNewSubBox').
	self assert: subBox isDirectory.
	#(cur new tmp) do: [ :each |
		self assert: (subBox / each) isDirectory ].
	self assert: box subBoxes size equals: 1.