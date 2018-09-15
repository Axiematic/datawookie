---
author: Andrew B. Collier
date: 2018-09-11T05:00:00Z
tags: ["Docker"]
title: "DIY VPN with Docker"
---

<!--
https://www.digitalocean.com/community/tutorials/how-to-run-openvpn-in-a-docker-container-on-ubuntu-14-04
https://github.com/kylemanna/docker-openvpn/blob/master/docs/tcp.md
https://samwize.com/2016/09/10/setup-your-own-vpn-with-docker-openvpn-and-digital-ocean/
https://heavymetaldev.com/openvpn-with-docker
https://serverfault.com/questions/226185/ssh-and-other-services-over-openvpn-are-slow
https://medium.com/@gurayy/set-up-a-vpn-server-with-docker-in-5-minutes-a66184882c45
-->

<div>
	<img style="float: right; margin-left: 10px;" src="/img/logo/logo-openvpn.png">
</div>

I've worked with both [ExpressVPN](https://www.expressvpn.com/) and [NordVPN](https://nordvpn.com/). Both are great services but, from my perspective, have one major shortcoming: they're currently blocked by Amazon Web Services (AWS). When using either of them you are simply not able to access any of the AWS services.

The most common scenario in which I'd be using a VPN is if I'm on a restrictive network where I'm only able to access web sites. Typically just ports 80, 8080 and 443 are open. Forget about SSH (port 22), SMTP (ports 25, 465 and 587) or NTP (port 123). I want to be able to connect by SSH to my AWS servers, send mail over SMTP and synchronise my clock. The latter items are normally possible over commercial VPN providers (like ExpressVPN and NordVPN) but not being able to connect to AWS is a deal breaker.

Luckily there is a simple solution: run your own VPN server. Using a low end cloud instance on AWS or DigitalOcean (costing $5 or less per month) this is eminently plausible.

## Launch a Cloud Server

Obviously this step needs to be done *before* you actually need the VPN! Spin up a minimal Ubuntu server on the cloud service of your choice (we'll be using AWS for illustration).

Open ports 1194 (UDP) and 443 (TCP) on the server.

Make a SSH connection to the remote server (assuming that port 22 is open by default!). The instructions which follow should all be executed on the remote server.

## Preliminaries

We're going to need Docker, so [install](https://gist.github.com/DataWookie/9f29795059e6bccf9892bc85ed285337) it now! We'll be using the [kylemanna/openvpn](https://hub.docker.com/r/kylemanna/openvpn/) Docker image (source repository is [here](https://github.com/kylemanna/docker-openvpn)). Start by pulling the image.

{{< highlight bash >}}
docker pull kylemanna/openvpn
{{< /highlight >}}

The VPN configuration and certificates will be stored in a [Docker volume](https://docs.docker.com/storage/volumes/). Create that now.

{{< highlight bash >}}
OVPN_DATA="ovpn-data"
docker volume create --name $OVPN_DATA
{{< /highlight >}}

You can check the contents of this volume using the following:

{{< highlight bash >}}
sudo ls /var/lib/docker/volumes/ovpn-data/_data
{{< /highlight >}}

Grab the DNS name for the server and stash it in a shell variable.

{{< highlight bash >}}
DNSNAME="ec2-18-218-49-6.us-east-2.compute.amazonaws.com"
{{< /highlight >}}

To reduce the volume of logging information it can be handy to include the ` --log-driver=none` option with the folowing invocations of `docker`.

## UDP

First we'll set up a VPN operating over UDP on port 1194. From a bandwidth perspective this is efficient, but this port may well be closed (in which case see the TCP option below).

Generate the OpenVPN configuration.

{{< highlight bash >}}
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$DNSNAME -b
{{< /highlight >}}

Initialise the EasyRSA Public Key Infrastructure (PKI).

{{< highlight bash >}}
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
{{< /highlight >}}

Enter and verify a suitable private key (PEM) pass phrase when prompted. At the prompt for a Common Name, just accept the default. Boil the kettle. Enter the pass phrase when prompted. And again.

Now launch the OpenVPN daemon process.

{{< highlight bash >}}
docker run --name openvpn -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
{{< /highlight >}}

## TCP

Execute the commands below for a VPN over TCP on port 443 (this is the port for HTTPS, so is almost definitely going to be open, no matter how repressive the network!).

{{< highlight bash >}}
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u tcp://$DNSNAME:443 -b
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
{{< /highlight >}}

{{< highlight bash >}}
docker run --name openvpn -v $OVPN_DATA:/etc/openvpn -d -p 443:1194/tcp --cap-add=NET_ADMIN kylemanna/openvpn
{{< /highlight >}}

## User and Configuration

Regardless of whether you are creating a VPN over TCP or UCP, you now need to create the configuration file which will be used with the `openvpn` client on your local machine.

{{< highlight bash >}}
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass
{{< /highlight >}}

Enter the pass phrase when prompted.

{{< highlight bash >}}
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient CLIENTNAME >CLIENTNAME.ovpn
{{< /highlight >}}

Now disconnect from the server.

## Connecting

Now, back on your local machine use SFTP or SCP to get a local copy of the `.ovpn` file from the server.

Install OpenVPN.

{{< highlight bash >}}
sudo apt install openvpn
{{< /highlight >}}

Connect to the VPN.

{{< highlight bash >}}
sudo openvpn --config CLIENTNAME.ovpn
{{< /highlight >}}

If everything goes well then you should see "Initialization Sequence Completed". [Confirm](https://www.google.com/search?q=whats+my+ip) that your effective IP address is now that of the VPN server. Enjoy!

## Conclusion

This setup is simple and cost effective. Typically I'll only need a VPN for a few days in succession, so it's very convenient that I can literally spin up a VPN when I know that I'm going to need it, then take it down when I'm done. No long term commitment. No hassles accessing any port or protocol I need.