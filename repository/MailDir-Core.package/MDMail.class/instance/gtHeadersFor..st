inspecting
gtHeadersFor: aView
	<gtView>

	^ aView forward
		title: 'Headers';
		priority: 20;
		object: [ self header ];
		view: #gtHeadersFor: