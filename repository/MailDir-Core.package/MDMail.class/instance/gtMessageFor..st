inspecting
gtMessageFor: aView
	<gtView>

	^ aView textEditor
		title: 'Message';
		priority: 10;
		text: [ (AkgMdMailVisitor new visitNode: self) text ]