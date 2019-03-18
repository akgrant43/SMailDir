inspector
gtInspectMessagesIn: composite
	<gtInspectorPresentationOrder: 50> 

	^composite fastTable 
		title: 'Messages';
		display: [ self mails sorted: #date descending ];
		beMultiple;
		enableElementIndex;
		wantsAutomaticRefresh: true;
		column: 'From' evaluated: [ :mail | mail sender ];
		column: 'Date' evaluated: [ :mail | self humanDateStringFor: mail date ];
		column: 'Subject' evaluated: [ :mail | mail subject ];
		send: [ :result | 
			result isNil
				ifTrue: [ nil ]
				ifFalse: [ result size = 1 
					ifTrue: [result anyOne ]  
					ifFalse: [self species withAll: result]]]
