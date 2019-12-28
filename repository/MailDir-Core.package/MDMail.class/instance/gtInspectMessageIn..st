inspecting
gtInspectMessageIn: composite
	<gtInspectorPresentationOrder: 5>

	self file exists ifTrue: 
		[ (self message gtInspectPayloadIn: composite)
			title: 'Message' ]