inspecting
gtBoxesFor: aView
	<gtView>

	^aView list 
		title: 'Boxes';
		priority: 10;
		items: [ self boxes keys ];
		send: [ :selection | self boxes at: selection ].