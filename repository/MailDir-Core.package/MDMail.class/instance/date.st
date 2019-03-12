meta information
date
	"Answer the receiver's date in US format (MM/DD/YY)"

	^ self timestamp asDate printFormat: #(2 1 3 47 1 2)