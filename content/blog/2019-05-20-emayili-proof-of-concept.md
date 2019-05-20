---
title: 'emayili: Proof of Concept'
date: 2019-04-11T03:30:00+00:00
author: Andrew B. Collier
tags: ["R"]
draft: true
---

I do a lot of automated reporting with R. Being able to easily and reliably send emails is a high priority. Although there is a selection of packages for this purpose, none of them ticks all of my boxes. So I wrote my own called [imeyili](https://datawookie.github.io/emayili/).

## Background

## What is curl?

## Can you send emails with curl?

https://ec.haxx.se/usingcurl-smtp.html (REFERENCE)
https://curl.haxx.se/libcurl/c/smtp-tls.html


$ export PASSWORD="my_secret_password"
$ curl smtps://smtp.gmail.com:465 -v --mail-from "craig@gmail.com" --mail-rcpt "bob@gmail.com" --ssl --ssl-reqd -u andrew.b.collier@gmail.com:$PASSWORD -T mail.txt --anyauth
$ curl smtp://smtp.gmail.com:587 -v --mail-from "craig@gmail.com" --mail-rcpt "bob@gmail.com" --ssl -u andrew.b.collier@gmail.com:$PASSWORD -T mail.txt -k --anyauth


The contents of the `mail.txt` file are:

```
From: "Craig" <craig@gmail.com>
To: "Bob" <bob@gmail.com>
Subject: Bazinga!

Hi John,

I’m sending this email using curl. Ain't I l33t?

Bye, Bob.
```

```
From: "Bob Smith" <andrew.b.collier@gmail.com>
To: "John Smith" <andrew@exegetic.biz>
Cc: "John Smith" <collierab@gmail.com>
Subject: This is a test

Hi John,
I’m sending this mail with curl thru my gmail account.
Bye!
```