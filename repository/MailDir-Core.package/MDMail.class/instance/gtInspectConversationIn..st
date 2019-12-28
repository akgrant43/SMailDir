inspecting
gtInspectConversationIn: composite
	<gtInspectorPresentationOrder: 7>

	self conversation ifNotNil: [ :conv |
		(conv gtInspectMessagesIn: composite)
			title: 'Conversation' ]