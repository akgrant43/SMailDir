instance creation
conversationsIn: aCollectionOfMails
	"Answer the set of conversations in aCollectionOfMails.
	All mails must be in the same archive."

	| newConversations archive |
	aCollectionOfMails ifEmpty: [^ #()].
	
	newConversations := Dictionary new.
	
	archive := aCollectionOfMails first mailArchive.
	^ (aCollectionOfMails collect: [:m | 
		archive 
			conversationForId: m messageId 
			ifAbsent: [self error: 'Mails are not properly indexed']]) asSet
	