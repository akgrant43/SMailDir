inspecting
gtMessagesFor: aView
	<gtView>

	^aView columnedList 
		title: 'Messages';
		priority: 10;
		items: [ self mails sorted: #date descending ];
		column: 'From' evaluated: [ :mail | mail sender ];
		column: 'Date' evaluated: [ :mail | self humanDateStringFor: mail date ];
		column: 'Subject' evaluated: [ :mail | mail subject ];
		send: [ :result | result].