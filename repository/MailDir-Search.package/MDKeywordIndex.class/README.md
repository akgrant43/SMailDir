Create an index for fast searching of an archive. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

MSKeywordIndex new 
	addKeyword: 'keyword1';
	addKeyword: 'keyword2';
	directory: '/path/to/archive';
	search: 'keyword1 keyword2'.

 
!!Internal Representation and Key Implementation Points.

!!!Instance Variables
	archive:			<MDMailArchive>
	archiveName:		<String>
	autoIndex:		<Object>
	directory:		<FileReference>
	index:				<Dictionary>
	indexMutex:		<Mutex>
	process:			<Process>
	reindexDate:		<DateAndTime>
	trashBoxName:	<String>


!!!Implementation Points