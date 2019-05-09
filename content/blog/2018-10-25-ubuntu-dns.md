---
author: Andrew B. Collier
date: 2018-10-25T04:30:00Z
tags: ["Ubuntu"]
title: "DNS on Ubuntu 18.04"
---

For years it's been simple to set up DNS on a Linux machine. Just add a couple of entries to `/etc/resolv.conf` and you're done.

{{< highlight text >}}
# Use Google's public DNS servers.
nameserver 8.8.4.4
nameserver 8.8.8.8
{{< /highlight >}}

But things change and now it's not that simple. If you now edit `/etc/resolv.conf` on Ubuntu you'll find that the edits are ephemeral. If you restart (or even hibernate) your machine then they'll be overwritten by default content.

{{< highlight text >}}
nameserver 127.0.0.53
search Home
{{< /highlight >}}

This is pretty simple to fix though.

1. Install the `resolvconf` package.

	{{< highlight bash >}}
sudo apt install resolvconf
{{< /highlight >}}

2. Edit `/etc/resolvconf/resolv.conf.d/head` and add the following:

	{{< highlight text >}}
# Make edits to /etc/resolvconf/resolv.conf.d/head.
nameserver 8.8.4.4
nameserver 8.8.8.8
{{< /highlight >}}

3. Restart the `resolvconf` service.

	{{< highlight bash >}}
sudo service resolvconf restart
{{< /highlight >}}

Fix should be permanent.
