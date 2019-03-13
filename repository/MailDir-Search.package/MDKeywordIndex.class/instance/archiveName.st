accessing
archiveName
	^ archiveName ifNil: [ directory basename ]