instance creation
fromFile: aFileReference

	| index |

	index := aFileReference asFileReference binaryReadStreamDo: [ :bstream |
		STON fromStream: (ZnCharacterReadStream 
			on: (GZipReadStream on: bstream)
			encoding: 'utf8') ].
	^index