Class {
	#name : #MDTestCase,
	#superclass : #TestCase,
	#instVars : [
		'messageEntry',
		'boxDirectory',
		'box',
		'boxName',
		'archiveName',
		'archive',
		'newMessageEntry',
		'testDirectory',
		'box2Name',
		'box2Directory',
		'box2',
		'trashBoxName',
		'trashBoxDirectory',
		'trashBox',
		'doubleMessageEntry',
		'archiveBoxName',
		'archiveBoxDirectory',
		'archiveBox',
		'archiveDirectory',
		'sentBoxName',
		'sentBoxDirectory',
		'sentBox'
	],
	#category : 'MailDir-Tests'
}

{ #category : #accessing }
MDTestCase >> directoryForTestName [
	
	^ 'mdTestArchive121'
]

{ #category : #accessing }
MDTestCase >> doubleMailFileContent [

	^ 'Received: from MXSTU2012.hpi.uni-potsdam.de ([fe80::b539:e00:3268:a932]) by
 OWA-2012.hpi.uni-potsdam.de ([fe80::9d94:d459:bf45:5d57%22]) with mapi id
 14.03.0210.002; Sat, 15 Nov 2014 01:35:26 +0100
From: "Hoasd, Askdjas" <hoasd.askdjas@uni-potsdam.de>
To: Rein, Patrick" <Patrick.Rein@hpi.de>, "Uio
 Fdf (uio.fdf@gmail.com)" <uio.fdf@gmail.com>
Subject: Ski fahren?
Thread-Topic: Ski fahren?
Thread-Index: AdAAa8EJMxDuxnv/RkCZwR3Ig6ITLw==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Sat, 15 Nov 2014 01:35:25 +0100
Message-ID:
	<A5D573DC3A4D504E94F179A430DB329E0E0DAE6F@MXSTU2012.hpi.uni-potsdam.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 04
X-MS-Exchange-Organization-AuthSource: OWA-2012.hpi.uni-potsdam.de
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
x-originating-ip: [141.89.225.161]
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0

<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<meta name="Generator" content="Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.E-MailFormatvorlage17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang="EN-GB" link="blue" vlink="purple">
<div class="WordSection1">
<p class="MsoNormal"><span lang="DE">Aber sicher!<o:p></o:p></span></p>
</div>
</body>
</html>'
]

{ #category : #accessing }
MDTestCase >> doubleMailFileName1 [

	^ '81742993.3224_1.lovelace.staff.plugged.com.au;2,FS'
]

{ #category : #accessing }
MDTestCase >> doubleMailFileName2 [

	^ '817456783.3224_1.lovelace.staff.plugged.com.au;2,FS'
]

{ #category : #accessing }
MDTestCase >> doubleMailMessageId [

	^ '<A5D573DC3A4D504E94F179A430DB329E0E0DAE6F@MXSTU2012.hpi.uni-potsdam.de>'
]

{ #category : #accessing }
MDTestCase >> mailFileContent [

	^ 'Delivered-To: patrick.rein@gmail.com
Received: by 10.202.229.6 with SMTP id c6csp137255oih;
        Thu, 13 Nov 2014 15:51:59 -0800 (PST)
X-Received: by 10.107.29.197 with SMTP id d188mr6376327iod.57.1415922719073;
        Thu, 13 Nov 2014 15:51:59 -0800 (PST)
Return-Path: <bounce+73ec63.947b4-patrick.rein=gmail.com@mg.gitlab.com>
Received: from so254-15.mailgun.net (so254-15.mailgun.net. [198.61.254.15])
        by mx.google.com with ESMTPS id ih15si1109047igb.60.2014.11.13.15.51.58
        for <patrick.rein@gmail.com>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2014 15:51:59 -0800 (PST)
Received-SPF: pass (google.com: domain of bounce+73ec63.947b4-patrick.rein=gmail.com@mg.gitlab.com designates 198.61.254.15 as permitted sender) client-ip=198.61.254.15;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of bounce+73ec63.947b4-patrick.rein=gmail.com@mg.gitlab.com designates 198.61.254.15 as permitted sender) smtp.mail=bounce+73ec63.947b4-patrick.rein=gmail.com@mg.gitlab.com;
       dkim=pass header.i=@mg.gitlab.com
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.gitlab.com; q=dns/txt;
 s=mailo; t=1415922718; h=Sender: Content-Transfer-Encoding:
 Content-Type: Mime-Version: Subject: Message-Id: To: Reply-To: From:
 Date: X-Feedback-Id; bh=Xx1NHgREi73lLaHPGKmaJ8+Tn5zR8sDxJIDKAjHEg74=; b=a8eYAj3yzNlQ0f9sKrCoMK6C6cNotJ/DllblPpDJ2kwtC+R3dp5gjz90JLVMBThAXog3ECUc
 U09xYmLv9eUZdvaSHLqwXEiJXyAZ3CDH3TBAzC8p/TXLVUzDjEIVJj1MVub3C2tKmJu4vibF
 nbgqxKkktH0QK4zngaqA++0MkeI=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=mg.gitlab.com; s=mailo;
 q=dns; h=X-Feedback-Id: Date: From: Reply-To: To: Message-Id: Subject:
 Mime-Version: Content-Type: Content-Transfer-Encoding: Sender;
 b=EMJ1nd/ilee0AjxovudCbfYU7SjE/Wjt5NWIexXnEAtc3yLSf/7fZo4+kOoJWUZSg2dIGE
 ZmbiskPLbycXl5orUM0/iM5Anp55pOXJ9TeiZrffj/DIZW9oUrLjttoSstIHODOqT81t37NC
 OGjsEyAA+dOmrgyM0b85vlU3cvhnk=
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mailgun.org; q=dns/txt; s=mg;
 t=1415922718; h=Sender: Content-Transfer-Encoding: Content-Type:
 Mime-Version: Subject: Message-Id: To: Reply-To: From: Date:
 X-Feedback-Id; bh=Xx1NHgREi73lLaHPGKmaJ8+Tn5zR8sDxJIDKAjHEg74=; b=Gh0UlDduxSaH+Cgp88Yoid27qLQZHk53MJ/rJPmkK6PKguXBhQEqY0Y4NlMJ+JB43W5SVktk
 bQSWuOWNNY3nRd2Q0CQV86yHKQWFNs3RDgliQHFw5V1zPswW6UaZr/i0E09zCroA7xoT8xlA
 Kh+RIgsze1Vdpwl1VEUMliTFGBQ=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=mailgun.org; s=mg; q=dns;
 h=X-Feedback-Id: Date: From: Reply-To: To: Message-Id: Subject:
 Mime-Version: Content-Type: Content-Transfer-Encoding: Sender;
 b=AYMbSj82bd9YbL5JNpkvsHMC+qTmbJpvTF6YI+jnG9/wZz4+tWOOqGRm6AZVg8iNqEegxN
 DorJlzmRkzQAcKUg5sXksrBSSD1OarF9m2X3g6hXzo0TdsnZzvhMcHFmKmsJG2Q2WDtDzF96
 r4L+i/5mt9ChUXW4BCgDTu6aLBtnI=
X-Feedback-Id: 531ee07d5a76185406c6480b:mailgun
Received: from mg.gitlab.com (Unknown [62.204.93.102]) by mxa.mailgun.org
 with ESMTP id 5465440e.7fdd6cb48848-in7; Thu, 13 Nov 2014 23:51:42 -0000
 (UTC)
Date: Thu, 13 Nov 2014 23:51:40 +0000
From: GitLab <gitlab@gitlab.com>
Reply-To: noreply@gitlab.com
To: patrick.rein@gmail.com
Message-Id: <5465440cb4a02_1108f88ea050778@monty.mail>
Subject: editable views | Access to project was granted
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="--==_mimepart_5465440cb29d9_1108f88ea0506d2"; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailgun-Sid: WyJlNjEyNCIsICJwYXRyaWNrLnJlaW5AZ21haWwuY29tIiwgIjk0N2I0Il0=
Sender: gitlab=gitlab.com@mg.gitlab.com
X-GmailLabel: \Important

----==_mimepart_5465440cb29d9_1108f88ea0506d2
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit


You have been granted Developer access to project CDG Internal / editable views

https://gitlab.com/cdg/editable-views

----==_mimepart_5465440cb29d9_1108f88ea0506d2
Content-Type: text/html;
 charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html lang=3D"en">
<head>
<meta content=3D"text/html; charset=3Dutf-8" http-equiv=3D"Content-Type">=

<title>
GitLab
</title>
</meta>
</head>
<style>
  img {
    max-width: 100%;
    height: auto;
  }
  p.details {
    font-style:italic;
    color:#777
  }
  .footer p {
    font-size:small;
    color:#777
  }
</style>
<body>
<div class=3D"content">
<p>
You have been granted Developer access to project
</p>
<p>
<a href=3D"https://gitlab.com/cdg/editable-views">CDG Internal / editable=
 views
</a></p>

</div>
</body>
</html>

----==_mimepart_5465440cb29d9_1108f88ea0506d2--'
]

{ #category : #accessing }
MDTestCase >> mailFileName [
          
	^ '81792873.3984_1.lovelace.staff.plugged.com.au;1,XYZ2,RS'
]

{ #category : #accessing }
MDTestCase >> mailMessageId [

	^ '<5465440cb4a02_1108f88ea050778@monty.mail>'
]

{ #category : #accessing }
MDTestCase >> messageEntry [

	^ messageEntry
]

{ #category : #accessing }
MDTestCase >> messageEntry: anObject [

	messageEntry := anObject
]

{ #category : #accessing }
MDTestCase >> newMailFileContent [

	^ 'Delivered-To: patrick.rein@gmail.com
Received: by 10.202.229.6 with SMTP id c6csp132411oih;
        Thu, 13 Nov 2014 15:00:10 -0800 (PST)
X-Received: by 10.50.154.33 with SMTP id vl1mr2104267igb.48.1415919609991;
        Thu, 13 Nov 2014 15:00:09 -0800 (PST)
Return-Path: <bounce+fb6311.8e06-patrick.rein=gmail.com@slack.com>
Received: from so254-87.mailgun.net (so254-87.mailgun.net. [198.61.254.87])
        by mx.google.com with ESMTPS id l13si42133499ica.82.2014.11.13.15.00.09
        for <patrick.rein@gmail.com>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2014 15:00:09 -0800 (PST)
Received-SPF: pass (google.com: domain of bounce+fb6311.8e06-patrick.rein=gmail.com@slack.com designates 198.61.254.87 as permitted sender) client-ip=198.61.254.87;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of bounce+fb6311.8e06-patrick.rein=gmail.com@slack.com designates 198.61.254.87 as permitted sender) smtp.mail=bounce+fb6311.8e06-patrick.rein=gmail.com@slack.com;
       dkim=pass header.i=@slack.com;
       dmarc=pass (p=NONE dis=NONE) header.from=slack.com
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=slack.com; q=dns/txt; s=mailo;
 t=1415919609; h=Sender: Date: Message-Id: Content-Type: Mime-Version:
 From: Reply-To: Subject: To: X-Feedback-Id;
 bh=Mb6dwbkWLY1AeilujcCIhIfQmsoH5Q4va5XSb1TD9d4=; b=MShriaLL/XT1vP55pJsbvI9inKmjnrTrNXUZkn3JXrI+HcRffiDxxVYNGJCso5OOCugt7FqH
 5fRRH/9+ClmGJwEZOmVKOVMNfVjtKJuBZEdW6jUAzM4AntRm1bGFpSD5joBH5MoCBe8LMSKT
 7o6rcisfkC2fxtMYEMP23Vkj3cA=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slack.com; s=mailo; q=dns;
 h=X-Feedback-Id: To: Subject: Reply-To: From: Mime-Version:
 Content-Type: Message-Id: Date: Sender;
 b=q/T6FPCgI1V+CU0vzscmzR6+Cw+DU5fpGklBfzd8Q8oJ5Q7KE4cNiY598eyoUzYT2M5x3T
 YF2U//Z3Mfy5k1ZaBaXvF5N8Mk1rH9n4RsXwBeXwA6e4A2/zfRt4NYGUM0AWoQPdIGlAcLC2
 KrpJgNX9g/eiaTKXW7v93Ff+VKJzg=
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mailgun.org; q=dns/txt; s=mg;
 t=1415919609; h=Sender: Date: Message-Id: Content-Type: Mime-Version:
 From: Reply-To: Subject: To: X-Feedback-Id;
 bh=Mb6dwbkWLY1AeilujcCIhIfQmsoH5Q4va5XSb1TD9d4=; b=OGYVWiek+Kk3MU1lzmmVdCNwb7FGvxFk0N47K5yVVgx2AUDC10mHNW23TsxxLS1SncFRB/7S
 YwostSTxnUixjREgViWq/BocvNUZHlQIjwKwXO5uw8iEAp1mgBhHnZwqdY3lC3YcGuz73Ifu
 /DU1qDWTW5AvOZMKvk/ITAaiQV8=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=mailgun.org; s=mg; q=dns;
 h=X-Feedback-Id: To: Subject: Reply-To: From: Mime-Version:
 Content-Type: Message-Id: Date: Sender;
 b=Fu3lT0V+HOdmPXJlaQaKi8Dya0Kx9xntrlIqqjJRiLBVziEcewQvQilkxr8LOmzi5uQ66f
 yscXgvPsqN8zdOWE+5uq4gD8KbHHnT1RSEGewF6jXiXDJXbI6BTvg2X0/wVOJP5mVawa9OSG
 EPWSwyVdHkMWOxHNA/4uUtwGcGegs=
X-Feedback-Id: 51fc4124fea39869d1d31bd1:mailgun
Received: from slack-www140.tinyspeck.com
 (ec2-184-73-55-119.compute-1.amazonaws.com [184.73.55.119]) by
 mxa.mailgun.org with ESMTP id 546537f0.506d430-in7; Thu, 13 Nov 2014
 23:00:00 -0000 (UTC)
Received: by slack-www140.tinyspeck.com (Postfix, from userid 33)	id
 C20CD25738; Thu, 13 Nov 2014 14:59:59 -0800 (PST)
To: patrick.rein@gmail.com
Subject: Asd has invited you to join CDG Labs on Slack
Reply-To: asd@gmail.com
In-reply-to: <5465440cb4a02_1108f88ea050778@monty.mail>
From: "Slack" <feedback@slack.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="__slack_304307350__"
Message-Id: <20141113225959.C20CD25738@slack-www140.tinyspeck.com>
Date: Thu, 13 Nov 2014 14:59:59 -0800 (PST)
X-Mailgun-Sid: WyJjMzk2MSIsICJwYXRyaWNrLnJlaW5AZ21haWwuY29tIiwgIjhlMDYiXQ==
Sender: feedback@slack.com
X-GmailLabel: 

--__slack_304307350__
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome

Once youve activated your account, you can sign in at
https://cdglabs.slack.com/signin, or enter "" as your team domain
when signing in from https://slack.com/signin.

--__slack_304307350__--'
]

{ #category : #accessing }
MDTestCase >> newMailFileName [

	^ '81742873.3924_1.lovelace.staff.plugged.com.au;2,F'
]

{ #category : #accessing }
MDTestCase >> newMailMessageId [

	^ '<20141113225959.C20CD25738@slack-www140.tinyspeck.com>'
]

{ #category : #running }
MDTestCase >> setUp [

	| new cur |

	super setUp.
	testDirectory := (FileLocator temp / self directoryForTestName) resolve.
	testDirectory createDirectory.

	archiveName := 'MailDirTests'.
	archiveDirectory := testDirectory / archiveName.
	archiveDirectory createDirectory.
	
	boxName := 'MailDirBox'.
	boxDirectory := archiveDirectory / boxName.
	boxDirectory createDirectory. 
	new := boxDirectory / 'new'.
	new createDirectory.
	cur := boxDirectory / 'cur'.
	cur createDirectory.
	(boxDirectory / 'tmp') createDirectory.

	(new / self newMailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self newMailFileContent ].
	(cur / self mailFileName) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self mailFileContent ].
	(cur / self doubleMailFileName1) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self doubleMailFileContent ].
	
	box2Name := 'MailDirBox2'.
	box2Directory := archiveDirectory / box2Name.
	box2Directory createDirectory.
	new := box2Directory / 'new'.
	new createDirectory.
	cur := box2Directory / 'cur'.
	cur createDirectory.
	(box2Directory / 'tmp') createDirectory.
	
	(cur / self doubleMailFileName2) writeStreamEncoded: 'null' do: [ :stream |
		stream nextPutAll: self doubleMailFileContent ].
	
	trashBoxName := 'MailDirTrash'.
	trashBoxDirectory := archiveDirectory / trashBoxName.
	trashBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (trashBoxDirectory / each) createDirectory ].

	archiveBoxName := 'MailBoxArchive'.
	archiveBoxDirectory := archiveDirectory / archiveBoxName.
	archiveBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (archiveBoxDirectory / each) createDirectory ].

	sentBoxName := 'MailBoxSent'.
	sentBoxDirectory := archiveDirectory / sentBoxName.
	sentBoxDirectory createDirectory.
	#(new cur tmp) do: [ :each | (sentBoxDirectory / each) createDirectory ].

	archive := MDMailArchive archiveIn: archiveDirectory flagSeparator: $;.
	archive trashBoxName: trashBoxName.
	archive archiveBoxName: archiveBoxName.
	archive sentBoxName: sentBoxName.
	box := archive boxes detect: [:b | b fileDirectory = boxDirectory].
	box2 := archive boxes detect: [:b | b fileDirectory = box2Directory].
	trashBox := archive boxes detect: [:b | b fileDirectory = trashBoxDirectory].
	archiveBox := archive boxes detect: [:b | b fileDirectory = archiveBoxDirectory].
	sentBox := archive boxes detect: [:b | b fileDirectory = sentBoxDirectory].
	
	messageEntry := archive allMails detect: [:m | m messageId = self mailMessageId].
	newMessageEntry := archive allMails detect: [:m | m messageId = self newMailMessageId].
	doubleMessageEntry := archive allMails detect: [:m | m messageId = self doubleMailMessageId].
]

{ #category : #running }
MDTestCase >> tearDown [
	
	testDirectory ensureDeleteAll.
	super tearDown

]

{ #category : #accessing }
MDTestCase >> timeoutForSetUp [

	^ 20 minutes asSeconds
]
