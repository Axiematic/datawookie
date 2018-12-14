---
author: Andrew B. Collier
date: 2018-12-14T10:00:00Z
tags: ['linux']
title: Citrix Receiver on Ubuntu 18.04
---

There's a Debian package available for Citrix Receiver, so in principle this task should be trivial.

It's not.

Simply installing the package leaves you with a SSL error whenever you try to connect to a Citrix resource. You need to jump through a couple of extra hoops to get it actually working.

## Installing the Package

Download the package from [here](https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html) (scroll down to the "Debian Packages" section).

Install it.

{{< highlight bash >}}
$ sudo dpkg -i icaclient_13.10.0.20_amd64.deb
{{< /highlight >}}

Now you need to sort out the SSL certificates.

## Sorting the Certificates

Link in the certificates (these should already be resident somewhere on your machine).

{{< highlight bash >}}
$ sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
{{< /highlight >}}

Create a hash for each certificate.

{{< highlight bash >}}
$ sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
{{< /highlight >}}

And you are ready to roll! Connect to your Citrix resources. Enjoy.