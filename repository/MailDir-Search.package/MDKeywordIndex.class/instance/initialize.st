initialization
initialize

	super initialize.
	indexMutex := Mutex new.
	index := Dictionary new.
	reindexDate := Date today - 180 days.