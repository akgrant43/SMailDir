boxes
createSubBoxNamed: aString 
	
	| directoryName boxDirectory |

	directoryName := self fullBoxName , '.' , aString.
	boxDirectory := self mailArchive fileDirectory / directoryName.
	boxDirectory ensureCreateDirectory.
	#(new cur tmp) do: [ :each | (boxDirectory / each) ensureCreateDirectory ].
	self synchronizeSubBoxes.