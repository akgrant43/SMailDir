inspecting
gtAttachmentsFor: aView
	<gtView>

	^ aView forward
		title: 'Attachments';
		priority: 15;
		object: [ (AkgMdMailVisitor new visitNode: self) attachments ];
		view: #gtLiveFor: