inspecting
gtMessagesFor: aView

	<gtView>
	^ aView columnedList
		  title: 'Messages';
		  priority: 10;
		  items: [ self mails sorted: #date descending ];
		  column: 'From' text: [ :mail | mail sender ];
		  column: 'Date'
		  text: [ :mail | self humanDateStringFor: mail date ];
		  column: 'Subject' text: [ :mail | mail subject ];
		  send: [ :result | result ]