private
nextFileNameCounter
	"Increment and answer the filename counter"

	FileNameCounter ifNil: [ FileNameCounter := 0 ].
	^FileNameCounter := FileNameCounter + 1.
	