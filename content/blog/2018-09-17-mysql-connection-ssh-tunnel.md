---
author: Andrew B. Collier
draft: true
title: 'Connecting to MySQL via a SSH Tunnel'
tags: ["MySQL", "SSH"]
date: 2018-09-17T02:00:00Z
---

Create the tunnel.

{{< highlight bash >}}
ssh -L 3307:localhost:3306 andrew@db.remote-server.com
{{< /highlight >}}

Connect using the MySQL client.

{{< highlight bash >}}
mysql -uandrew -p -P 3307 -h 127.0.0.1 
{{< /highlight >}}

Type in your password for the remote DB and you're done!
