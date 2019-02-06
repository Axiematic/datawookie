---
author: Andrew B. Collier
date: 2017-09-11T08:30:00Z
tags: ["R", "OSRM"]
title: Building a Local OSRM Instance
---

The [Open Source Routing Machine (OSRM)](http://project-osrm.org/) is a library for calculating routes, distances and travel times between spatial locations. It can be accessed via either an HTTP or C++ API. Since it's open source you can also install locally, download appropriate map data and start making efficient travel calculations.

These are the instructions for getting OSRM installed on a Ubuntu machine and hooking up the `osrm` R package.

<!--more-->

{{< comment >}}
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-osrm-server-on-ubuntu-14-04
https://github.com/Project-OSRM/osrm-backend/wiki/Running-OSRM
{{< /comment >}}

## Setup

Building OSRM is memory intensive, so unless you are installing on a machine with a good chunk of RAM, you'll want to ensure that there's around 4 Gb of [swap space]({{< relref "2015-06-19-amazon-ec2-adding-swap.md" >}}) available.

## Building OSRM

First make sure that you have the necessary infrastructure and libraries required to build OSRM. Strictly `htop` is not necessary but it's handy for monitoring performance.

{{< highlight bash >}}
sudo apt update
sudo apt install -y git cmake build-essential jq htop
sudo apt install -y liblua5.2-dev libboost-all-dev libprotobuf-dev libtbb-dev libstxxl-dev libbz2-dev
{{< /highlight >}}

Now grab the source directly from the repository on GitHub.

{{< highlight bash >}}
git clone https://github.com/Project-OSRM/osrm-backend.git
{{< /highlight >}}

Move into the source folder.

{{< highlight bash >}}
cd osrm-backend/
{{< /highlight >}}

Although you could probably just build from the current state of the repository, it might make sense to choose the most recent [release](https://github.com/Project-OSRM/osrm-backend/releases). So, for example, to checkout version v5.18.0:

{{< highlight bash >}}
git checkout v5.18.0
{{< /highlight >}}

Create a `build` folder and then run `cmake` to generate Makefiles.

{{< highlight bash >}}
mkdir build
cd build/
cmake ..
{{< /highlight >}}

Next initiate the build.

{{< highlight bash >}}
make
{{< /highlight >}}

Time to kick back and wait: this will take some time!

If you are on a multi-core machine then you can build in parallel too.

{{< highlight bash >}}
make -j$(nproc)
{{< /highlight >}}

When the build completes, make the `install` target.

{{< highlight bash >}}
sudo make install
{{< /highlight >}}

The complete recipe above is available as a [gist](https://gist.github.com/DataWookie/6403a0fe3692d03b15627eae6d6d2ad0).

<script src="https://gist.github.com/DataWookie/6403a0fe3692d03b15627eae6d6d2ad0.js"></script>

## Getting OpenStreetMap Data

### OpenStreetMap Export

Go to the [export page](http://www.openstreetmap.org/export) on OpenStreetMap. Zoom in on you area of interest and then press the Export button. The area I was working with was too large to download directly from OpenStreetMap, so I followed the link to the [Overpass API](http://overpass-api.de/), which worked flawlessly.

I'm installing on a remote instance, so I used `wget` to do the download.

{{< highlight bash >}}
wget -O map.xml http://overpass-api.de/api/map?bbox=29.5,-30.5,31.5,-29.0
{{< /highlight >}}

The resulting download will be a (possibly rather large) XML file. Move it to the `osrm-backend` folder created above.

![](/img/2017/09/openstreetmap-export.png)

### Data from Geofabrik

You can also download the OpenStreetMap data in a variety of formats from [Geofabrik](http://download.geofabrik.de/).

## Extracting the Map

In the `profiles` folder you'll find three files (`bicycle.lua`, `car.lua` and `foot.lua`) which provide speed profiles for various means of transportation. You can create a custom profile if necessary, but the ones provided will suffice for most situations. We'll go with the car profile.

The next step is to extract the routing data. This can be very memory intensive, so make sure that you have sufficient swap space or that you're using [STXXL](http://stxxl.org/).

{{< highlight bash >}}
osrm-extract map.xml -p profiles/car.lua
{{< /highlight >}}

## Creating a Hierarchy

Now to create data structures that facilitate finding the shortest route between two points.

{{< highlight bash >}}
osrm-contract map.xml.osrm
{{< /highlight >}}

## Launching the Service

We can launch a HTTP server which exposes the OSRM API as follows:

{{< highlight bash >}}
osrm-routed map.xml.osrm
{{< /highlight >}}

Let's try a few test queries. First we'll find the nearest road to a location specified by a longitude/latitude pair.

{{< highlight bash >}}
curl "http://localhost:5000/nearest/v1/driving/31.043515,-29.778562" | jq
{{< /highlight >}}

{{< highlight bash >}}
{
  "waypoints": [
    {
      "distance": 37.79936,
      "hint": "Cr0BgIG9AYD-AAAAYgAAAAAAAAAAAAAA_gAAAGIAAAAAAAAAAAAAACYAAAAosdkBA505_ruv2QF-nTn-AABfAS51HLo=",
      "name": "St Andrews Drive",
      "location": [
        31.04388,
        -29.778685
      ]
    }
  ],
  "code": "Ok"
}
{{< /highlight >}}

Next the distance and time between two locations.

{{< highlight bash >}}
curl "http://127.0.0.1:5000/route/v1/driving/31.043515,-29.778562;31.029080,-29.795506" | jq
{{< /highlight >}}

{{< highlight text >}}
{
  "code": "Ok",
  "routes": [
    {
      "geometry": "xcwtDggn|DfHbC|AjHnFjBxAlNdDjAwA|Fvq@rUvFTF`KtAL|@g@vIvDRvASzHVr@dBVj@uD",
      "legs": [
        {
          "steps": [],
          "distance": 2926.9,
          "duration": 357.6,
          "summary": "",
          "weight": 357.6
        }
      ],
      "distance": 2926.9,
      "duration": 357.6,
      "weight_name": "routability",
      "weight": 357.6
    }
  ],
  "waypoints": [
    {
      "hint": "Cr0BgIG9AYD-AAAAYgAAAAAAAAAAAAAA_gAAAGIAAAAAAAAAAAAAACYAAAAosdkBA505_ruv2QF-nTn-AABfAS51HLo=",
      "name": "St Andrews Drive",
      "location": [
        31.04388,
        -29.778685
      ]
    },
    {
      "hint": "p7kBgMO5AYANAAAAeAAAAGACAAALAAAADQAAAHgAAABgAgAACwAAACYAAAB_d9kBwls5_lh32QFOWzn-CQDvES51HLo=",
      "name": "Gainsborough Drive",
      "location": [
        31.029119,
        -29.79539
      ]
    }
  ]
}
{{< /highlight >}}

The `duration` values are in seconds and the `distance` is in metres. Looks pretty legit!

More information on the API can be found [here](https://github.com/Project-OSRM/osrm-backend/blob/master/docs/http.md).

If you were wanting to expose this service to the outside world then you'd need to integrate it with your web server and maybe set up something to restart the service if the machine reboots. I'm only planning on using OSRM locally, so these are not issues for me.

## The `osrm` R Package

My primary motivation for setting up OSRM is so that I can use it from within R.

First install a couple of packages.

{{< highlight bash >}}
sudo apt install -y libcurl4-openssl-dev libgeos-dev
{{< /highlight >}}

Now install the `osrm` package.

{{< highlight r >}}
install.packages("osrm")
{{< /highlight >}}

Load the package and point it at the local OSRM service.

{{< highlight bash >}}
> library(osrm)
Data (c) OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright
Routes: OSRM. http://project-osrm.org/
If you plan to use the OSRM public API, read the OSRM API Usage Policy:
https://github.com/Project-OSRM/osrm-backend/wiki/Api-usage-policy
> options(osrm.server = "http://127.0.0.1:5000/")
{{< /highlight >}}

Now create a couple of locations.

{{< highlight bash >}}
> locations = data.frame(comm_id = c("A", "B", "C"),
+                        lon = c(31.043515, 31.029080, 31.002896),
+                        lat = c(-29.778562, -29.795506, -29.836168))
{{< /highlight >}}

Generate a table of travel times between those locations.

{{< highlight bash >}}
> osrmTable(loc = locations)
$durations
     A   B    C
A  0.0 6.0 11.9
B  6.0 0.0  9.6
C 11.5 9.7  0.0

$sources
       lon       lat
A 31.04388 -29.77868
B 31.02913 -29.79539
C 31.00286 -29.83625

$destinations
       lon       lat
A 31.04388 -29.77868
B 31.02913 -29.79539
C 31.00286 -29.83625
{{< /highlight >}}

Calculate the optimal route between two locations.

{{< highlight bash >}}
> route = osrmRoute(src = locations[1,], dst = locations[2,], sp = TRUE)
> route$duration
[1] 5.96
> route$distance
[1] 2.9269
{{< /highlight >}}

The units are now minutes for `duration` and kilometres for `distance`.

I've been using the `gmapsdistance` package until now. It has worked brilliantly but I've had to manage it carefully to avoid overstepping API limits. With a local OSRM I'll be making the calculations unconstrained!

## OSRM on AWS

An AWS instance is a good option for running an OSRM instance.

A few things to consider:

- potentially use [OpenStreetMap on AWS](https://aws.amazon.com/public-datasets/osm/) as a data source;
- make sure that port 5000 is open in the security group applied to your instance.

![](/img/2017/09/security-group-port-5000.png)