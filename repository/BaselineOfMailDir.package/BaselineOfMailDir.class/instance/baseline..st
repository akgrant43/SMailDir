baseline
baseline: spec
	<baseline>
	spec
		for: #'common'
		do: [
			"spec
				baseline: 'Rack' with: 
					[spec repository: 'github://akgrant43/Rack:akg/repository']."
			
			spec
				package: 'MailDir-Core';
				package: 'MailDir-Tests' with: [spec requires: #('MailDir-Core')] ";
				package: 'MailDir-UI' with: [spec requires: #('MailDir-Core' 'Rack')]".
			spec
				group: 'default' with: #('MailDir-Core');
				"group: 'ui' with: #('MailDir-UI');"
				group: 'tests' with: #('MailDir-Tests')]