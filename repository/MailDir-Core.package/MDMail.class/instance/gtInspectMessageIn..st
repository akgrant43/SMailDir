inspecting
gtInspectMessageIn: composite
	<gtInspectorPresentationOrder: 5>

	^(self message gtInspectPayloadIn: composite)
		title: 'Message'