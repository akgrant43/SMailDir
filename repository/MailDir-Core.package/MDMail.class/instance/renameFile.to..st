files
renameFile: fromFileReference to: toFileReference
	"Rename aFile to fileName"
	fileAccessMutex critical: [
		toFileReference exists ifFalse:
			[ fromFileReference copy moveTo: toFileReference ] ].
	^toFileReference 