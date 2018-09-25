---
author: Andrew B. Collier
date: 2018-07-25T03:30:00Z
tags: ["Julia"]
title: Stan.jl Setup
---

I'm busy preparing a poster about Stan.jl for [JuliaCon 2018](http://juliacon.org/2018/). Getting set up is pretty simple, although there are some minor details that I thought I'd document.

<!--more-->

![](/img/2018/07/julia-stan.png)

## Installing CmdStan

The Stan.jl uses the [CmdStan](http://mc-stan.org/users/interfaces/cmdstan) command line client for interacting with Stan. This is what I did to install CmdStan on my Ubuntu 18.04 system.

1. Download the source distribution.

    {{< highlight bash >}}
$ wget -P /tmp/ https://github.com/stan-dev/cmdstan/releases/download/v2.17.1/cmdstan-2.17.1.tar.gz
{{< /highlight >}}

2. Unpack it under `/opt/`.

    {{< highlight bash >}}
$ cd /opt
$ sudo tar -zxvf /tmp/cmdstan-2.17.1.tar.gz
$ cd cmdstan-2.17.1
{{< /highlight >}}

3. Build.

    {{< highlight bash >}}
$ sudo make build
{{< /highlight >}}

Since the distribution was unpacked under `/opt/` it was read only for non-root users. As a result I had a minor issue actually running my first Stan model because in the process Stan tried to create the precompiled header `model_header.hpp.gch` under `/opt/` which, of course, resulted in a permission denied error. Quick fix for this: apply the changes from [this](https://github.com/stan-dev/cmdstan/pull/611) pull request and rebuild. Sorted!

Upon success you can clean up the download.

{{< highlight bash >}}
$ rm /tmp/cmdstan-2.17.1.tar.gz
{{< /highlight >}}

## Julia Initialisation

There are a couple of ways to tell Julia where to find `stanc`. You can either set an environment variable (this should ideally be appended to the end of `~/.bashrc` so that it is applied to each session).

{{< highlight bash >}}
export CMDSTAN_HOME=/opt/cmdstan-2.17.1/
{{< /highlight >}}

Alternatively, if you don't want to clutter up your shell namespace you can define it in your personal Julia initialisation file, `~/.juliarc.jl`:

{{< highlight julia >}}
const CmdStanDir = "/opt/cmdstan-2.17.1/";
{{< /highlight >}}

I prefer the second approach.

## Install the Package

Now fire up Julia then install and load the `Stan.jl` package.

{{< highlight julia >}}
julia> Pkg.add("Stan")
julia> using Stan
{{< /highlight >}}

Find links to pertinent documentation in the [package repository](https://github.com/goedman/Stan.jl).