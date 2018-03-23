---
title: 'Remote Desktop on an Ubuntu EC2 Instance'
date: 2017-08-08T03:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
category: Cloud
tags:
  - AWS
  - EC2
---

A couple of options for remote access to desktop applications on a EC2 host.

<!-- more -->

<!-- https://www.youtube.com/watch?v=ljvgwmJCUjw -->
<!-- https://aws.amazon.com/premiumsupport/knowledge-center/connect-to-linux-desktop-from-windows/ -->

## Option 1: SSH with X11 Forwarding

1. Connect to the EC2 host using SSH with X11 forwarding enabled.

{% highlight bash %}
ssh -X 13.57.185.127
{% endhighlight %}

{:start="2"}
2. In the resulting session you should find that the `DISPLAY` environment variable is set.

{% highlight bash %}
echo $DISPLAY
{% endhighlight %}

With this in place you can launch an application on the remote host and it will show up on your local desktop. Try starting `gvim` (assuming that you have it installed).

## Option 2: Remote Desktop

1. Connect via SSH.
2. Install a few packages.

{% highlight bash %}
sudo apt update
sudo apt install -y ubuntu-desktop xrdp
{% endhighlight %}

{:start="3"}
3. Edit the RDP configuration file, `/etc/xrdp/xrdp.ini`, on the host. A minimal configuration might look like this:

{% highlight text %}
[globals]
bitmap_cache=yes
bitmap_compression=yes
port=3389
crypt_level=low
channel_code=1
max_bpp=24

[xrdp1]
name=sesman-Xvnc
lib=libvnc.so
username=ask
password=ask
ip=127.0.0.1
port=ask-1
{% endhighlight %}

Note the entry for `port`, which will be important for making a connection.

{:start="4"}
4. In the AWS Dashboard edit the Security Group for the EC2 instance and allow inbound TCP connections on port 3389.
5. Restart RDP.

{% highlight bash %}
sudo service xrdp restart
{% endhighlight %}

{:start="6"}
6. Choose the Window Manager for RDP connections. This involves changing the contents of a user's `.xsession` file. You can copy the modified `.xsession` into `/etc/skel/` so that it will be propagated into any newly created accounts. However, you'll need to copy it manually into existing accounts.

Select one of the Window Manager options below (there are certainly other options too!).

- [XFCE](https://xfce.org/)

{% highlight bash %}
sudo apt install -y xfce4 xfce4-goodies
echo xfce4-session >~/.xsession
{% endhighlight %}

- [Unity](https://unity.ubuntu.com/)

{% highlight bash %}
echo unity >~/.xsession
{% endhighlight %}

{:start="7"}
7. Connect.

- On a Linux machine, connect using `vinagre`. You'll need to specify the IP address for the EC2 host and the RDP port.

![]({{ site.baseurl }}/static/img/2017/08/vinagre-login.png)

A connection will be initiated and you'll be prompted to provide your password. Leave the port unchanged.

![]({{ site.baseurl }}/static/img/2017/08/remote-desktop-login.png)

Once you're authenticated you should see your desktop.

![]({{ site.baseurl }}/static/img/2017/08/remote-desktop.png)

- On a Windows machine use the Remote Desktop client.