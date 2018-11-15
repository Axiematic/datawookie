---
author: Andrew B. Collier
date: 2018-11-13T02:00:00Z
tags: ['R']
title: Installing RStudio & Shiny Servers
---

{{< comment >}}
https://support.rstudio.com/hc/en-us/articles/234653607-Getting-Started-with-RStudio-Server
{{< /comment >}}

I did a remote install of Ubuntu Server today. This was somewhat novel because it's the first time that I have not had physical access to the machine I was installing on. The server install went very smoothly indeed.

The next tasks were to install RStudio Server and Shiny Server. The installation process for each of these is well documented on the RStudio web site:

- [Installing RStudio Server](https://www.rstudio.com/products/rstudio/download-server/) and
- [Installing Shiny Server](https://www.rstudio.com/products/shiny/download-server/).

These are my notes. Essentially the same, with some small variations.

## RStudio Server

1. Install a recent version of R.
2. Download the distribution.

	{{< highlight bash >}}
wget https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb
{{< /highlight >}}

3. Install the server.

	{{< highlight bash >}}
sudo dpkg -i rstudio-server-1.1.463-amd64.deb
{{< /highlight >}}

4. Verify the installation.

	{{< highlight bash >}}
sudo rstudio-server verify-installation
{{< /highlight >}}

5. RStudio Server runs on port 8787, so you should be able to access it in a browser at `http://<server-ip>:8787`.

## Shiny Server

1. Become root and install the `shiny` package.

	{{< highlight bash >}}
sudo su
R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
exit
{{< /highlight >}}

2. Download the distribution.

	{{< highlight bash >}}
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
{{< /highlight >}}

3. Install the server.

	{{< highlight bash >}}
sudo dpkg -i shiny-server-1.5.9.923-amd64.deb
{{< /highlight >}}

4. Shiny Server runs on port 3838, so you should be able to access it in a browser at `http://<server-ip>:3838`.
