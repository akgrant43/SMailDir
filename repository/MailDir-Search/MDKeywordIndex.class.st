"
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
"
Class {
	#name : #MDKeywordIndex,
	#superclass : #Object,
	#instVars : [
		'directory',
		'index',
		'archive',
		'archiveName',
		'trashBoxName',
		'indexMutex',
		'process',
		'reindexDate',
		'autoIndex'
	],
	#category : 'MailDir-Search'
}

{ #category : #'instance creation' }
MDKeywordIndex class >> fromFile: aFileReference [

	| index |

	index := aFileReference asFileReference binaryReadStreamDo: [ :bstream |
		STON fromStream: (ZnCharacterReadStream 
			on: (GZipReadStream on: bstream)
			encoding: 'utf8') ].
	^index
]

{ #category : #'instance creation' }
MDKeywordIndex class >> fromSton: stonReader [

	| index |

	index := self new.
	stonReader parseListDo: [ :each :idx |
		idx = 1 ifFalse: [ self error: 'Invalid STON' ].
		index
			basicDirectory: (each at: 'directory');
			archiveName: (each at: 'archiveName');
			trashBoxName: (each at: 'trashBoxName');
			index: (each at: 'index');
			archive: (each at: 'archive') ].
	^index
]

{ #category : #'index management' }
MDKeywordIndex >> addKeyword: aString [

	| keyword |

	keyword := aString trimBoth.
	self assert: (keyword allSatisfy: [ :char | char isAlphaNumeric or: 
			[ '_@.:' includes: char ] ]).
	keyword := keyword copyReplaceAll: ':' with: '\:'.
	indexMutex critical: [ index at: keyword ifAbsentPut: Set new ].

]

{ #category : #accessing }
MDKeywordIndex >> archive [
	^ archive
]

{ #category : #'ston persistence' }
MDKeywordIndex >> archive: aMDMailArchive [

	archive := aMDMailArchive
]

{ #category : #accessing }
MDKeywordIndex >> archiveName [
	^ archiveName ifNil: [ directory basename ]
]

{ #category : #accessing }
MDKeywordIndex >> archiveName: aString [

	archiveName := aString.
	archive ifNotNil: [ archive archiveName: aString ]
]

{ #category : #'ston persistence' }
MDKeywordIndex >> asStonDictionary [

	^Dictionary new
		at: 'directory' put: directory;
		at: 'archiveName' put: archiveName;
		at: 'trashBoxName' put: trashBoxName;
		at: 'archive' put: archive;
		at: 'index' put: index;
		yourself.
]

{ #category : #searching }
MDKeywordIndex >> at: keyword includes: messageId [
	"Answer a boolean indicating whether the supplied messageId contains keyword"

	^indexMutex critical:
		[ (index at: keyword ifAbsent: #()) includes: messageId ]
]

{ #category : #accessing }
MDKeywordIndex >> autoIndex [
	"Answer the flag indicating whether the index should be automatically updated with new search terms"
	^ autoIndex
]

{ #category : #accessing }
MDKeywordIndex >> autoIndex: aBoolean [
	"Set the flag indicating whether the index should be automatically updated with new search terms"

	autoIndex := aBoolean
]

{ #category : #'ston persistence' }
MDKeywordIndex >> basicDirectory: aFileReference [
	"Set the directory without building the archive"

	directory := aFileReference
]

{ #category : #accessing }
MDKeywordIndex >> directory: aFileReference [

	directory := aFileReference asFileReference.
	process ifNil:
		[ process := [ archive := MDMailArchive archiveIn: directory.
		archive archiveName: self archiveName.
		archive trashBoxName: self trashBoxName.
		self reindex.
		process := nil ] forkAt: Processor userBackgroundPriority named: 'MDKeywordIndex load' ]
	ifNotNil:
		[ self error: 'Unable to load - process already running' ]
]

{ #category : #'index management' }
MDKeywordIndex >> forkReindex [

	process ifNil:
		[ process := [ 
				self reindex.
				process := nil. ] 
			forkAt: Processor userBackgroundPriority 
			named: 'MDKeywordIndex reindex' ]
	ifNotNil: 
		[ self error: 'Unable to load - process already running' ]
]

{ #category : #accessing }
MDKeywordIndex >> includesKeyword: aString [
	"Answer a boolean indicating if the supplied keyword is currently indexed"

	^indexMutex critical: [ index includesKey: aString ]
]

{ #category : #accessing }
MDKeywordIndex >> index [
	^ index
]

{ #category : #accessing }
MDKeywordIndex >> index: anObject [
	index := anObject
]

{ #category : #initialization }
MDKeywordIndex >> initialize [

	super initialize.
	indexMutex := Mutex new.
	index := Dictionary new.
	reindexDate := Date today subtractDays: 180.
	autoIndex := true.
]

{ #category : #searching }
MDKeywordIndex >> isIndexed: aKeyword [
	"Answer a boolean indicating whether the receiver has indexed the given keyword"

	^self keywords includes: aKeyword
]

{ #category : #accessing }
MDKeywordIndex >> keywords [ 
	"Answer the collection of keywords currently indexed"

	^indexMutex critical: [ index keys ]
]

{ #category : #'index management' }
MDKeywordIndex >> reindex [
	"Reindex all the receivers keywords"

	| searchTerms dateFrom |

	self keywords ifEmpty: [ ^self ].
	dateFrom := MDSearchDateAfter new 
		date: reindexDate;
		yourself.
	searchTerms := self keywords collect: [ :keyword |
		keyword -> (MDSearchAnd new
			add: dateFrom;
			add: (MDSearchWord word: keyword);
			yourself) ].
	archive allMailsDo: [ :each | | searchMail |
		searchMail := MDSearchMail mdMail: each.
		searchTerms do: [ :searchTerm |
			(searchTerm value search: searchMail) ifTrue: 
				[ indexMutex critical: 
					[ (index at: searchTerm key) add: each messageId ] ] ] ].

]

{ #category : #'ston persistence' }
MDKeywordIndex >> saveToFile [

	| file backup stream |

	file := (self archiveName, '-index.stgz') asFileReference.
	file exists ifTrue: 
		[ backup := file nextVersion.
		file copy moveTo: backup ].

	stream := (ZnCharacterWriteStream 
		on: (GZipWriteStream on: file binaryWriteStream)
		encoding: 'utf8') asNewLineStream.
	[ STON put: self onStreamPretty: stream ]
		ensure: [ stream close ].
	^file pathString
]

{ #category : #searching }
MDKeywordIndex >> search: expressionString [

	| results unique messageIds |

	results := (Array streamContents: [ :stream |
		self search: expressionString onStream: stream ]).
	messageIds := Set new.
	unique := Array streamContents: [ :stream |
		results do: [ :each |
			(messageIds includes: each messageId) ifFalse: 
				[ stream nextPut: each.
				messageIds add: each messageId ] ] ].
	^unique sorted: #date descending.

]

{ #category : #searching }
MDKeywordIndex >> search: expressionString onStream: aStream [

	| searchString searchNode |

	searchString := expressionString copyReplaceAll: ':' with: '\:'.
	searchNode := MDSearchParser new parse: searchString.
	searchNode isPetit2Failure ifTrue: [ self error: searchNode printString ].
	autoIndex ifTrue: [ self updateIndexFrom: searchNode ].
	searchNode index: self.
	archive allMails do: [ :each | | mail |
		mail := MDSearchMail mdMail: each.
		(searchNode search: mail) ifTrue: [ aStream nextPut: each ] ]
]

{ #category : #'ston persistence' }
MDKeywordIndex >> stonOn: stonWriter [

	stonWriter writeObject: self streamShortList: [ :array |
		array add: self asStonDictionary ]
]

{ #category : #accessing }
MDKeywordIndex >> trashBoxName [
	^ trashBoxName ifNil: [ 'trash' ]
]

{ #category : #accessing }
MDKeywordIndex >> trashBoxName: aString [

	trashBoxName := aString.
	archive ifNotNil: [ archive trashBoxName: aString ]
]

{ #category : #'index management' }
MDKeywordIndex >> updateIndexFrom: searchNode [
	"Ensure all the search terms in the supplied node are indexed"

	| updateRequired |

	updateRequired := false.
	searchNode wordsDo: [ :term |
		(self includesKeyword: term) ifFalse: 
			[ updateRequired := true.
			self addKeyword: term ] ].
	updateRequired ifTrue: [ self reindex ]
]
