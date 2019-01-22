---
author: Andrew B. Collier
date: 2019-01-21T04:00:00Z
tags: ['R', 'Docker']
title: "Docker Images for R: r-base versus r-apt"
draft: false
---

I need to deploy a Plumber API in a Docker container. The API has some R package dependencies which need to be baked into the Docker image. There are a few options for the base image:

- [r-base](https://hub.docker.com/_/r-base/)
- [tidyverse](https://hub.docker.com/r/rocker/tidyverse) or
- [r-apt](https://hub.docker.com/r/rocker/r-apt).

The first option, r-base, would require building the dependencies from source, a somewhat time consuming operation. The last option, r-apt, makes it possible to install most packages using `apt`, which is likely to be much quicker. I'll immediately eliminate the other option, tidyverse, because although it already contains a load of packages, many of those are not required and, in addition, it incorporates RStudio Server, which is definitely not necessary for this project.

I'm trying to optimise the image for two criteria:

- small image and
- quick build time.

Of these the latter is the most important. Under normal circumstances I would not be too concerned about build time because Docker caches complete layers. However, this image is going to be built using a [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) system which will build the entire image from scratch each time.

## r-base

Let's start with the r-base image. Installing the required packages is as simple as executing R using `RUN` and then running `install.packages()`. The packages are installed from source, which takes some time (compiling source code and installing further dependencies).

{{< highlight text >}}
FROM r-base

RUN R -e 'install.packages(c("plumber", "jsonlite", "dplyr", "stringr", "here"))'
{{< /highlight >}}

## r-apt

Using the r-apt image allows you to install binary versions of those packages.

{{< highlight text >}}
FROM rocker/r-apt:bionic

RUN apt-get update && \
    apt-get install -y -qq \
    	r-cran-plumber \
    	r-cran-jsonlite \
    	r-cran-dplyr \
    	r-cran-stringr

RUN R -e 'install.packages("here")'

CMD ["R"]
{{< /highlight >}}

The `here` package is not (curently) available as a binary, so you still need to compile that from source. This package alone does not have much impact on the build time.

The base r-apt image will launch `bash` by default, so we need to explicitly start R using `CMD`.

## Build Times

What's the difference in build times? Well it turns out that this really does make a big difference.

{{< highlight bash >}}
$ time docker build --no-cache -t r_apt -f Dockerfile-r-apt .
real    3m39.590s
user    0m0.115s
sys     0m0.082s
{{< /highlight >}}

{{< highlight bash >}}
$ time docker build --no-cache -t r_base -f Dockerfile-r-base .
real    14m2.068s
user    0m0.467s
sys     0m0.456s
{{< /highlight >}}

Using binary packages takes just less than 4 minutes (there is still some download time and I'm not on a very fast connection). Building those packages from source is much more time consuming, taking more than three times longer.

## Image Sizes

What about the sizes of the images?

{{< highlight bash >}}
$ docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
r_base                              latest              9e278980b348        2 minutes ago       944MB
r_apt                               latest              493e243d84fe        12 minutes ago      805MB
{{< /highlight >}}

The image built using binary packages is smaller too.

Based on these results I'll be using the r-apt base image for this project, but there's no saying that r-base won't come in handy for the next project!