accessing
testSetUnread

	messageEntry setUnread.
	self assert: messageEntry hasBeenSeen not.
	self assert: messageEntry file basename equals: '81792873.3984_1.lovelace.staff.plugged.com.au;1,XYZ2,R'.
	self assert: messageEntry file parent equals: (boxDirectory / 'new')