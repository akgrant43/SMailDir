private
generateFileNameFor: aMessage

	^ String streamContents: [ :stream | stream
		print:	DateAndTime now asUnixTime;
		<< '_';
		print: self nextFileNameCounter;
		<< '.';
		print: LibC uniqueInstance currentProcessId;
		<< '.';
		<< NetNameResolver localHostName;
		<< ',U=123456'; "To signal the synchronization process that this is a new email --pre"
		<< ',FMD5=123456'; "Also to signal the synchronization process that this is a new email --pre"
		nextPut: self mailArchive flagSeparator;
		<< '2,' ]