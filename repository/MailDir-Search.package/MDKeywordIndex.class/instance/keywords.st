accessing
keywords 
	"Answer the collection of keywords currently indexed"

	^indexMutex critical: [ index keys ]