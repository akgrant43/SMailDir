class initialization
initialize 

	Encoders := { 
		#'utf-8' -> ZnCharacterEncoder utf8.
		#'iso-8859-1' -> (ZnCharacterEncoder newForEncoding: #'iso-8859-1') } asDictionary.

	QPTranslation := { 
		32 " " -> #'_'.
		61 "=" -> #'=3D'.
		63 "?" -> #'=3F'.
		 } asDictionary.