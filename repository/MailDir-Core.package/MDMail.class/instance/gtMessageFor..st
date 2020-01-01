inspecting
gtMessageFor: aView
	<gtView>

	^((GtDocument forMDMail: self)
		gtTextFor: aView)
			priority: 1;
			title: 'Message';
			yourself.