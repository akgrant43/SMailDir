inspecting
gtInspectBoxesIn: composite
	<gtInspectorPresentationOrder: 5>

	composite list 
		title: 'MailBoxes';
		display: [ self boxes values sorted: #boxName ascending ]