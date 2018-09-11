---
author: Andrew B. Collier
date: 2018-09-11T02:00:00Z
tags: ["Docker"]
title: "Spinning Up a VPN with Docker"
---

https://www.digitalocean.com/community/tutorials/how-to-run-openvpn-in-a-docker-container-on-ubuntu-14-04
https://github.com/kylemanna/docker-openvpn/blob/master/docs/tcp.md

https://serverfault.com/questions/226185/ssh-and-other-services-over-openvpn-are-slow

OVPN_DATA="ovpn-data-example"

docker volume create --name $OVPN_DATA

DNSNAME="ec2-18-218-49-6.us-east-2.compute.amazonaws.com"

Make sure that port 443 is open on this machine.

## UDP

docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://$DNSNAME
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki

docker run --name openvpn -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

## TCP

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u tcp://$DNSNAME:443
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

docker run --name openvpn -v $OVPN_DATA:/etc/openvpn -d -p 443:1194/tcp --cap-add=NET_ADMIN kylemanna/openvpn

## User and Configuration

docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass

docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn

## Connecting

Copy the .ovpn file back from the server.

sudo openvpn --config CLIENTNAME.ovpn

