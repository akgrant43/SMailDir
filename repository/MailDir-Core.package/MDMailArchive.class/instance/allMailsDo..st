accessing
allMailsDo: aBlock

	self boxes do: [ :box | box allMailsDo: aBlock]