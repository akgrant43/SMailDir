Class {
	#name : #MDEmailReader,
	#superclass : #MailComposition,
	#category : 'MailDir-UI'
}

{ #category : #toolbuilder }
MDEmailReader >> buildButtonBarSpecWith: aBuilder [

	| buttonBarSpec |
	buttonBarSpec := super buildButtonBarSpecWith: aBuilder.
	
	buttonBarSpec children removeAll.
	
	buttonBarSpec children add: (aBuilder pluggableButtonSpec new
		model: self;
		action: #replyToMail;
		label: #replyMailButtonLabel;
		yourself).
		
	buttonBarSpec children add: (aBuilder pluggableButtonSpec new
		model: self;
		action: #replyAllToMail;
		label: #replyAllMailButtonLabel;
		yourself).
	
	^ buttonBarSpec
]

{ #category : #toolbuilder }
MDEmailReader >> createDetailsFieldsIn: detailsPanelSpec by: aBuilder [

	super createDetailsFieldsIn: detailsPanelSpec by: aBuilder.
	
	detailsPanelSpec children 
		insert: (self createFieldInputNamed: #dateLabel getter: #messageDateAndTime setter: #messageDateAndTime: with: aBuilder)
		before: detailsPanelSpec children size.
]

{ #category : #toolbuilder }
MDEmailReader >> createFieldInputNamed: fieldLabelGetter getter: fieldGetter setter: fieldSetter with: aBuilder [

	| field |
	field := super 
		createFieldInputNamed: fieldLabelGetter 
		getter: fieldGetter 
		setter: fieldSetter 
		with: aBuilder.
	
	field 
		borderWidth: 0; 
		readOnly: true; 
		color: #windowColorToUse; 
		indicateUnacceptedChanges: false.
	
	^ field	
]

{ #category : #toolbuilder }
MDEmailReader >> dateLabel [

	^ 'Date'
]

{ #category : #toolbuilder }
MDEmailReader >> dialogTitle [

	^ self messageSubject 
]

{ #category : #toolbuilder }
MDEmailReader >> messageDateAndTime [

	^ mailMessage date printString
]

{ #category : #accessing }
MDEmailReader >> messageDateAndTime: aString [

	^ mailMessage date
]

{ #category : #'access to mail object' }
MDEmailReader >> messageRecipient [

	| recipients recipientsText |
	recipients := mailMessage to.
	recipientsText := recipients asText.
	(MailAddressParser addressesIn: recipients) do: [:address | | start end block |
		start := recipients findString: address.
		end := (start + address size) - 1.
		block := [(soup search: (Person all search: address) printString) explore].
		recipientsText addAttribute: (PluggableTextAttribute evalBlock: block) from: start to: end ].
	
	^ recipientsText
]

{ #category : #'access to mail object' }
MDEmailReader >> messageText [

	^ mailMessage bodyTextFormatted
]

{ #category : #private }
MDEmailReader >> prepareReplyTextFor: mailMessage [
	
	| replyText |
	replyText := #('' '') , (mailMessage bodyTextFormatted asString withSqueakLineEndings lines collect: [:l | '>' , l ]) joinSeparatedBy: String cr.
	^ (MIMEDocument 
		contentType: MIMEDocument contentTypePlainText
		content: replyText)
			charset: 'UTF-8';
			yourself.
]

{ #category : #toolbuilder }
MDEmailReader >> replyAllMailButtonLabel [

	^ 'reply all' translated
]

{ #category : #actions }
MDEmailReader >> replyAllToMail [

	| reply |
	reply := MailMessage replyAllFor: mailMessage excluding: {}.
	reply body: (self prepareReplyTextFor: mailMessage).
	MDMailComposition sendMailMessage: reply.
			
	^ true 
]

{ #category : #toolbuilder }
MDEmailReader >> replyMailButtonLabel [

	^ 'reply' translated
]

{ #category : #actions }
MDEmailReader >> replyToMail [

	| reply |
	reply := MailMessage replyFor: mailMessage.
	reply body: (self prepareReplyTextFor: mailMessage).
	MDMailComposition sendMailMessage: reply.
			
	^ true 
]
