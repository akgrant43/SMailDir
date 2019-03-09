initialization
initialize

	super initialize.
	indexMutex := Mutex new.
	index := Dictionary new.