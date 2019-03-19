inspecting
gtInspectConversationIn: composite
	<gtInspectorPresentationOrder: 7>

	^(self conversation gtInspectMessagesIn: composite)
		title: 'Conversation'