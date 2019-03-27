initialization
initialize

	super initialize.
	indexMutex := Mutex new.
	index := Dictionary new.
	reindexDate := Date today subtractDays: 180.
	autoIndex := true.