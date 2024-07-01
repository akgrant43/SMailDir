Class {
	#name : #MDArchiveTest,
	#superclass : #MDTestCase,
	#category : 'MailDir-Tests'
}

{ #category : #fixtures }
MDArchiveTest >> sentMailMessage [

	^ MailMessage fromRfc822: 'Delivered-To: patrick.rein@gmail.com
To: patrick.rein@gmail.com
Subject: Asd has invited you to join CDG Labs on Slack
Reply-To: asd@gmail.com
In-reply-to: <20141113225959.C20CD25738@slack-www140.tinyspeck.com>
From: patrick.rein@gmail.com
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="__slack_304307350__"
Message-Id: <20171113225959.C20CD25738@slack-www140.tinyspeck.com>
Date: Thu, 13 Nov 2017 14:59:59 -0800 (PST)
Sender: patrick.rein@gmail.com

--__slack_304307350__
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome again

you are doing just fine.

--__slack_304307350__--'
]

{ #category : #tests }
MDArchiveTest >> testAfterLastRemoveTheMailIsRemoved [

	| conversation |
	newMessageEntry file delete.
	conversation := (MDMailConversation conversationsIn: {newMessageEntry}) anyOne. 
	
	archive synchronize.
	
	self 
		assert: newMessageEntry files isEmpty;
		shouldnt: (box allMails includes: newMessageEntry);
		shouldnt: (archive mailIdIndex includesKey: newMessageEntry messageId);
		shouldnt: (archive conversationIndex includesKey: newMessageEntry messageId);
		shouldnt: (conversation includes: newMessageEntry)
	
]

{ #category : #tests }
MDArchiveTest >> testAllBoxes [

	self assert: {box . box2 . trashBox . archiveBox . sentBox} asSet equals: archive allBoxes asSet
]

{ #category : #tests }
MDArchiveTest >> testStoreSentMail [

	| mail |
	self skip: 'MailMessage still broken on Pharo'.

	"mail := archive storeSentMail: self sentMailMessage.
 
	self assert: (sentBox mails includes: mail).
	self assert: (mail boxes includes: sentBox).
	
	self assert: ((sentBoxDirectory / 'cur') children includes: mail file)  "
]

{ #category : #tests }
MDArchiveTest >> testSynchronizationOfFolders [

	| yab |

	yab := archiveDirectory / 'yetAnotherBox'.
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.
	
	self assert: 6 equals: archive boxes size.
	self assert: (archive boxes anySatisfy: [:b | b boxName = 'yetAnotherBox']).
]

{ #category : #tests }
MDArchiveTest >> testSynchronizationOfFoldersRemovesBoxes [

	| yab |

	yab := archiveDirectory / 'yetAnotherBox'.
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.

	yab deleteAll.
	
	archive synchronizeBoxes.
	
	self assert: 5 equals: archive boxes size.
	self assert: (archive boxes noneSatisfy: [:b | b boxName = 'yetAnotherBox']).
]

{ #category : #tests }
MDArchiveTest >> testSynchronizationOfSubFolders [

	| yab |

	yab := archiveDirectory / (boxName , '.' , 'yetAnotherBox').
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].

	archive synchronizeBoxes.
	
	self assert: 6 equals: archive allBoxes size.
	self assert: (archive allBoxes anySatisfy: [:b | b boxName = 'yetAnotherBox']).
]

{ #category : #tests }
MDArchiveTest >> testSynchronizationOfSubFoldersRemovesSubBoxes [

	| yab |

	yab := archiveDirectory / (boxName , '.' , 'yetAnotherBox').
	yab createDirectory.
	#(new cur tmp) do: [ :each | (yab / each) createDirectory ].
	
	archive synchronizeBoxes.
	
	yab deleteAll.
	
	archive synchronizeBoxes.
	
	self assert: 5 equals: archive allBoxes size.
	self assert: (archive allBoxes noneSatisfy: [:b | b boxName = 'yetAnotherBox']).
]
