initialize-release
readRootBoxNames
	"Determine the mail box names.  Mail boxes are directories that have the cur, new and tmp subdirectories"
	| boxNames |

	^self readBoxNames select: [ :each | | boxDir |
		boxDir := self fileDirectory / each.
		(boxDir / 'cur') isDirectory and: [ (boxDir / 'new') isDirectory and: [ (boxDir / 'tmp') isDirectory ] ] ]

"Original definition: This should be removed when confident.
	boxNames := self readBoxNames.
	^ (boxNames collect: [:boxName | (boxName findTokens: '.') first]) asSet."
	