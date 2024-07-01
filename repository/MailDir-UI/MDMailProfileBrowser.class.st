Class {
	#name : #MDMailProfileBrowser,
	#superclass : #Model,
	#instVars : [
		'profileSelected'
	],
	#category : 'MailDir-UI'
}

{ #category : #'initialize-release' }
MDMailProfileBrowser class >> initialize [
	"self initialize"

	"TheWorldMenu registerOpenCommand: {'Mail Dir Profiles'. {[(Smalltalk at: #MDMailProfileBrowser) open]. #value}}"
]

{ #category : #toolbuilder }
MDMailProfileBrowser class >> open [

	^ ToolBuilder default open: self new

]

{ #category : #actions }
MDMailProfileBrowser >> addProfileButtonClicked [
	
	self createTemporaryProfile.
	self changed: #listOfProfiles
]

{ #category : #'profile list' }
MDMailProfileBrowser >> addProfileButtonLabel [
	
	^ '+ Add new profile'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> archiveFolderNameLabel [

	^ 'Archive folder name (optional)'
]

{ #category : #toolbuilder }
MDMailProfileBrowser >> buildProfileFormWith: aBuilder [

	| panel fields archivePathButton archiveButtons archiveSynchronizeButton |
	panel := aBuilder pluggablePanelSpec new
		model: self;
		children: OrderedCollection new;
		layout: #vertical;
		yourself.
	
	fields := #((getProfileName setProfileName: profileNameLabel)
			     (getUserEmailAddress setUserEmailAddress: userEmailAddressLabel)
			     (getSmtpServer setSmtpServer: smtpServerLabel)
			     (getSmtpServerPort setSmtpServerPort: smtpServerPortLabel)
			     (getSmtpUsername setSmtpUsername: smtpUsernameLabel)
			     (getSmtpPassword setSmtpPassword: smtpPasswordLabel)) collect: [:fieldSpec |
		aBuilder pluggableInputFieldSpec new
			model: self;
			getText: fieldSpec first;
			editText: fieldSpec second;
			help: fieldSpec third;
			yourself].
		
	archiveButtons :=  aBuilder pluggablePanelSpec new
		layout: #horizontal;
		children: OrderedCollection new.
	
	archivePathButton := aBuilder pluggableButtonSpec new
		model: self;
		label: #mailArchivePathLabel;
		action: #setMailArchivePath;
		yourself.
		
	archiveSynchronizeButton := aBuilder pluggableButtonSpec new
		model: self;
		label: #mailArchiveSynchronizeLabel;
		action: #synchronizeArchive;
		yourself.	
		
	archiveButtons children 
		add: archivePathButton;
		add: archiveSynchronizeButton.
		
	fields := fields , {archiveButtons}.
	
	fields := fields , (#(
				(getFlagSeparator setFlagSeparator: flagSeparatorLabel)
				(getTrashFolderName setTrashFolderName: trashFolderNameLabel)
			     	(getSentFolderName setSentFolderName: sentFolderNameLabel)
				(getArchiveFolderName setArchiveFolderName: archiveFolderNameLabel)) collect: [:fieldSpec |
		aBuilder pluggableInputFieldSpec new
			model: self;
			getText: fieldSpec first;
			editText: fieldSpec second;
			help: fieldSpec third;
			yourself]).

	panel children addAll: fields.
	
	^ panel
]

{ #category : #toolbuilder }
MDMailProfileBrowser >> buildProfileListWith: aBuilder [

	| panel addProfileButton list removeProfileButton |
	panel := aBuilder pluggablePanelSpec new
		model: self;
		children: OrderedCollection new;
		yourself.
	
	list := aBuilder pluggableListSpec new
		model: self;
		frame: (LayoutFrame 
				fractions: (0@0 corner: 1@1)
				offsets: (0@0 corner: 0@self buttonBarHeight negated));
		list: #listOfProfiles;
		getIndex: #profileSelected;
		setIndex: #profileSelected:;
		yourself.
		
	addProfileButton := aBuilder pluggableButtonSpec new
		model: self;
		action: #addProfileButtonClicked;
		label: #addProfileButtonLabel;
		frame: (LayoutFrame 
				fractions: (0@1 corner: 1@1)
				offsets: (0@ self buttonBarHeight negated corner: 0@(self buttonBarHeight / 2) negated));
		yourself.
		
	removeProfileButton := aBuilder pluggableButtonSpec new
		model: self;
		action: #removeProfileButtonClicked;
		label: #removeProfileButtonLabel;
		frame: (LayoutFrame 
				fractions: (0@1 corner: 1@1)
				offsets: (0@ self buttonBarHeight negated / 2 corner: 0@0));
		yourself.
		
	panel children
		add: list;
		add: addProfileButton;
		add: removeProfileButton.
	
	^ panel
]

{ #category : #toolbuilder }
MDMailProfileBrowser >> buildWith: aBuilder [

	| profileForm profileList windowSpec |
	windowSpec := aBuilder pluggableWindowSpec new
		model: self;
		children: OrderedCollection new;
		label: 'Mail profiles';
		closeAction: #cleanUpNewProfile;
		yourself.
	
	profileList := self buildProfileListWith: aBuilder.
	profileList frame: (LayoutFrame new
			leftFraction: 0;
			topFraction: 0;
			rightFraction: 0.3;
			bottomFraction: 1).
	profileForm := self buildProfileFormWith: aBuilder.
	profileForm frame: (LayoutFrame new
			leftFraction: 0.3;
			topFraction: 0;
			rightFraction: 1;
			bottomFraction: 1).
	
	windowSpec children
		add: profileList;
		add: profileForm.
		
	^ aBuilder build: windowSpec

	
]

{ #category : #constants }
MDMailProfileBrowser >> buttonBarHeight [

	^ 40 "pixel"
]

{ #category : #actions }
MDMailProfileBrowser >> cleanUpNewProfile [
	
	(MDMailProfile Profiles anySatisfy: [:p | p profileName = self temporaryProfileName])
		ifTrue: [MDMailProfile Profiles remove: (MDMailProfile Profiles detect: [:p | p profileName = self temporaryProfileName])]
]

{ #category : #private }
MDMailProfileBrowser >> createTemporaryProfile [
	
	^ MDMailProfile Profiles 
		detect: [:p | p profileName = self temporaryProfileName]
		ifNone: [MDMailProfile create profileName: self temporaryProfileName; yourself]
	
]

{ #category : #'profile list' }
MDMailProfileBrowser >> currentProfile [

	^ self listOfProfiles at: self profileSelected ifAbsent: [nil]
]

{ #category : #'profile form' }
MDMailProfileBrowser >> flagSeparatorLabel [

	^ 'The character indicating the beginning of the flag list in the mail filename'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getArchiveFolderName [
	
	^ ((self currentProfile ifNotNil: [:p | p archive]) ifNotNil: [:a | a archiveBoxName]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getFlagSeparator [
	
	^ ((self currentProfile ifNotNil: [:p | p archive]) ifNotNil: [:a | a flagSeparator]) ifNil: ['']
	
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getProfileName [
	
	^ (self currentProfile ifNotNil: [:p | p profileName]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getSentFolderName [
	
	^ ((self currentProfile ifNotNil: [:p | p archive]) ifNotNil: [:a | a sentBoxName]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getSmtpPassword [
	
	^ (self currentProfile ifNotNil: [:p | p smtpPassword]) ifNil: [''] 
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getSmtpServer [
	
	^ (self currentProfile ifNotNil: [:p | p smtpServer]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getSmtpServerPort [
	
	^ ((self currentProfile ifNotNil: [:p | p smtpServerPort]) ifNil: '') asString
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getSmtpUsername [
	
	^ (self currentProfile ifNotNil: [:p | p smtpUsername]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getTrashFolderName [
	
	^ ((self currentProfile ifNotNil: [:p | p archive]) ifNotNil: [:a | a trashBoxName]) ifNil: ['']
]

{ #category : #'profile form' }
MDMailProfileBrowser >> getUserEmailAddress [
	
	^ (self currentProfile ifNotNil: [:p | p userEmailAddress]) ifNil: ['']
]

{ #category : #constants }
MDMailProfileBrowser >> lineHeight [

	^ 25 "pixel"
]

{ #category : #'profile list' }
MDMailProfileBrowser >> listOfProfiles [
	
	MDMailProfile Profiles ifEmpty: [self createTemporaryProfile].
	^ (MDMailProfile Profiles sorted: [:a :b | a hash < b hash])
]

{ #category : #'profile form' }
MDMailProfileBrowser >> mailArchivePathLabel [
	
	^ 'Set mail archive path (currently: ' 
		, (((self currentProfile ifNotNil: [:p | p archive]) ifNil: [^ '']) fileDirectory ifNil: [^ '']) localName , ')'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> mailArchiveSynchronizeLabel [
	
	^ 'Synchronize archive (can take several minutes)'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> profileNameLabel [

	^ 'profile name'
]

{ #category : #'profile list' }
MDMailProfileBrowser >> profileSelected [
	
	^ profileSelected ifNil: [profileSelected := 1]
]

{ #category : #'profile list' }
MDMailProfileBrowser >> profileSelected: anIndex [
	
	profileSelected := anIndex.
	#(profileSelected getProfileName getUserEmailAddress getSmtpServer getSmtpServerPort 
		getSmtpUsername getSmtpPassword mailArchivePathLabel getSentFolderName getTrashFolderName
		getArchiveFolderName getFlagSeparator)
			do: [:selector | self changed: selector]
]

{ #category : #actions }
MDMailProfileBrowser >> removeProfileButtonClicked [
	
	self currentProfile ifNil: [^ false].
	
	(UIManager default confirm: 'Do you really want to remove the profile ' translated , self currentProfile profileName)
		ifTrue: [	MDMailProfile removeFromSystem: self currentProfile]. 
	self changed: #listOfProfiles
]

{ #category : #'profile list' }
MDMailProfileBrowser >> removeProfileButtonLabel [
	
	^ '- Remove profile'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> sentFolderNameLabel [

	^ 'Sent folder name'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setArchiveFolderName: aString [
	
	self currentProfile archive archiveBoxName: aString asString.
	self changed: #getArchiveFolderName
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setFlagSeparator: aString [
	
	self currentProfile archive flagSeparator: aString asString.
	self changed: #getFlagSeparator
]

{ #category : #actions }
MDMailProfileBrowser >> setMailArchivePath [

	| directory |
	directory := UIManager default chooseDirectory: 'Select the root directory of the mail dir directory'.
	directory ifNotNil: [
		self currentProfile archive 
			ifNil: [ | flagSeparator |
				flagSeparator := UIManager default
					request: 'Please enter the flag separator of this mail dir directory'
					initialAnswer: ';'.
				flagSeparator ifNil: [^ false].
				flagSeparator := flagSeparator first.
				UIManager default inform: 'We will set up the initial archive. This can take several minutes'.
				self currentProfile archive: (MDMailArchive archiveIn: directory flagSeparator: flagSeparator).
				self currentProfile archive archiveName: self currentProfile profileName]
			ifNotNil: [
				(UIManager default confirm: 'Are you sure you want to change the archive root folder?')
					ifTrue: [self currentProfile archive fileDirectory: directory]]].
	self changed: #mailArchivePathLabel
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setProfileName: aString [

	self currentProfile profileName: aString asString.
	self currentProfile archive archiveName: aString asString.
	self changed: #getProfileName.
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setSentFolderName: aString [
	
	self currentProfile archive sentBoxName: aString asString.
	self changed: #getSentFolderName
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setSmtpPassword: aString [
	
	self currentProfile smtpPassword: aString asString.
	self changed: #getSmtpPassword.
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setSmtpServer: aString [
	
	self currentProfile smtpServer: aString asString.
	self changed: #getSmtpServer.
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setSmtpServerPort: aString [
	
	self currentProfile smtpServerPort: aString asString asNumber.
	self changed: #getSmtpServerPort.
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setSmtpUsername: aString [
	
	self currentProfile smtpUsername: aString asString.
	self changed: #getSmtpUsername.
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setTrashFolderName: aString [
	
	self currentProfile archive trashBoxName: aString asString.
	self changed: #getTrashFolderName
]

{ #category : #'profile form' }
MDMailProfileBrowser >> setUserEmailAddress: aString [
	
	self currentProfile userEmailAddress: aString asString.
	self changed: #getUserEmailAddress
]

{ #category : #'profile form' }
MDMailProfileBrowser >> smtpPasswordLabel [

	^ 'smtp server password'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> smtpServerLabel [

	^ 'smtp server'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> smtpServerPortLabel [

	^ 'smtp server port'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> smtpUsernameLabel [

	^ 'smtp server user name'
]

{ #category : #actions }
MDMailProfileBrowser >> synchronizeArchive [
	
	^ self currentProfile ifNotNil: [:p | p archive ifNotNil: [:a | a synchronize]]
]

{ #category : #private }
MDMailProfileBrowser >> temporaryProfileName [

	^ 'a new profile'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> trashFolderNameLabel [

	^ 'Trash folder name'
]

{ #category : #'profile form' }
MDMailProfileBrowser >> userEmailAddressLabel [

	^ 'email address'
]
