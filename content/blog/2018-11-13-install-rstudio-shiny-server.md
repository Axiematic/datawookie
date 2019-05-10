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
wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb
{{< /highlight >}}

3. Install the server.

	{{< highlight bash >}}
sudo dpkg -i rstudio-server-1.2.1335-amd64.deb
{{< /highlight >}}

If this generates an error you can run the following then try again.

	{{< highlight bash >}}
sudo apt-get --fix-broken install
{{< /highlight >}}

4. Verify the installation.

	{{< highlight bash >}}
sudo rstudio-server verify-installation
{{< /highlight >}}

5. RStudio Server runs on port 8787, so you should be able to access it in a browser at `http://<server-ip>:8787`.

### Whether or not to Start at Boot

RStudio Server does not consume an awful lot of RAM. But on a small machine, every bit of memory can be precious. So perhaps you don't want to have RStudio Server running all the time? No problem!

{{< highlight bash >}}
# Check whether RStudio Server is running.
systemctl is-active rstudio-server

# Disable RStudio Server at boot.
sudo systemctl disable rstudio-server

# Enable RStudio Server at boot.
sudo systemctl enable rstudio-server
{{< /highlight >}}

You can then start and stop RStudio Server as and when required.

{{< highlight bash >}}
# Start RStudio Server.
sudo systemctl start rstudio-server

# Stop RStudio Server.
sudo systemctl stop rstudio-server

# Stop and then start RStudio Server.
sudo systemctl restart rstudio-server
{{< /highlight >}}

### Configuration Options

Configuration settings are stored in `/etc/rstudio/rserver.conf`.

One of the most common configuration changes that I make is to change the port on which RStudio Server is running. This can be done by adding the following line to the above configuration file:

{{< highlight bash >}}
www-port=80
{{< /highlight >}}

After making any changes to the configuration you need to restart the server.

Find out more about [configuring](https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server) and [managing](https://support.rstudio.com/hc/en-us/articles/200532327-Managing-the-Server) the server.

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

### Whether or not to Start at Boot

You can also disable Shiny Server being automatically started at boot.

{{< highlight bash >}}
# Disable Shiny Server at boot.
sudo systemctl disable shiny-server
{{< /highlight >}}

### Installing Apps

You should install apps into folders below `/srv/shiny-server`. Also ensure that all of the files in the app (source) are owned by `shiny.shiny`.
