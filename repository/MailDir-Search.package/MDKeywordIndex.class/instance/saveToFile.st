ston persistence
saveToFile

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