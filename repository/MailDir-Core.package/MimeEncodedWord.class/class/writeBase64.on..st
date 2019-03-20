writing
writeBase64: charEncoded on: stream
	"Write the supplied ByteArray base64 encoded on stream"

	"stream nextPutAll: charEncoded base64Encoded"
	ZnBase64Encoder new encode: charEncoded readStream to: stream