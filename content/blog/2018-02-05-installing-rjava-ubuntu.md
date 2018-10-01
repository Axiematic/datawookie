---
author: Andrew B. Collier
date: 2018-02-05T07:00:00Z
excerpt_separator: <!-- more -->
title: Installing rJava on Ubuntu
draft: false
tags: ["R", "Linux"]
---

Installing the rJava package on Ubuntu is not quite as simple as most other R packages. Some quick notes on how to do it.

<!--more-->

1. Update the repository listings.
    {{< highlight text >}}
sudo apt update -y
{{< /highlight >}}
2. Install the Java Runtime Environment (JRE) and Java Development Kit (JDK).
    {{< highlight text >}}
sudo apt install -y openjdk-8-jdk openjdk-8-jre
{{< /highlight >}}
3. Update where R expects to find various Java files.
    {{< highlight text >}}
sudo R CMD javareconf
{{< /highlight >}}
4. Install the package.
    {{< highlight r >}}
> install.packages("rJava")
{{< /highlight >}}
5. If you have a RStudio session open, then exit and restart it. This is important (a running RStudio session will not pick up these changes!).

Sorted!
