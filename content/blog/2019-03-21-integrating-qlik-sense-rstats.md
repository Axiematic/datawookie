---
author: Andrew B. Collier
date: 2019-03-21T08:30:00Z
title: Integrating Qlik Sense and R
draft: true
---

## Components

[Qlik Sense](https://www.qlik.com/us/products/qlik-sense) is a tool for exploratory data analysis and visualisation. It's powerful and versatile. It's can, however, be significantly enhanced by interfacing with R. Qlik Sense does not currently integrate directly with R. However, it's not too tricky to get the two systems talking to each other. We'll need two things to make this happen:

- [Rserve](https://www.rforge.net/Rserve/) — A TCP/IP server which allows other programs to use R without initialising a separate R process or linking against an R library; and
- [SSE R-plugin](https://github.com/qlik-oss/sse-r-plugin) — A server-side extension (SSE) which provides the interface between Qlik Sense and Rserve.

## SSE Plugin on Windows

![](/img/2019/03/qlik-sense-rserve-windows.svg)

Getting Qlik Sense to talk to Rserve on a Windows machine is a relatively simple process. There's a document with detailed instructions [here](https://community.qlik.com/cyjdu72974/attachments/cyjdu72974/qlik-sense-enterprise-documents/2141/1/R%20Integration%20with%20QSFeb2018.pdf). This is a brief summary:

1. Install a [recent version of R](https://cran.r-project.org/bin/windows/base/). Select the 64-bit version during installation.
2. Run R and install the Rserve package.

	```r
install.packages("Rserve")
```

3. Install other R packages. The list of packages will depend on what functionality you want to use, but this is a good start.

    ```r
install.packages(c("jsonlite", "forecast", "rpart", "partykit"))
```

4. Load and run Rserve.

    ```r
library(Rserve)
Rserve()
```

5. Configure Qlik Sense Desktop to find the plugin by editing the `Settings.ini` which you'll find in `\Documents\Qlik\Sense\` within the user's home folder.

    ```text
[Settings 7]
SSEPlugin=R,localhost:50051
```

6. Download and install the [SSE R-plugin](https://github.com/qlik-oss/sse-r-plugin).

7. Launch the plugin by running `SSEtoRserve.exe`.

This is fine if you are happy with running everything in a Windows environment. This, however, is not what we want! Rather we prefer to host Rserve and the plugin on a separate Linux machine (probably in the Cloud), making it accessible to multiple Windows clients.

## SSE Plugin on Linux

![](/img/2019/03/qlik-sense-rserve-linux.svg)

The SSE R-plugin is written in C#. It's fairly simple to build under Windows. Getting it up and running under Linux requires a bit more work. There is a [fork](https://github.com/wbvreeuwijk/sse-r-plugin) of the SSE R-plugin repository which builds the C# code using Mono and then wraps the result in a [Docker image](https://hub.docker.com/r/wbvreeuwijk/docker-rserve). However, it was forked midway through 2017, so it's missing recent development on the plugin.

It was a but if a slog, but we figured out how to get the current plugin to build with Mono. To ensure that it will still build in the future, we have fixed on a specific build of the [Mono Docker image](https://hub.docker.com/_/mono/) and a particular commit on the SSE R-plugin repository. We also wrapped Rserve up in a separate Docker image, again choosing a specific version for reproducibility.

Now it's just a question of running `docker-compose up` on the Linux machine. This creates containers for Rserve and SSE R-plugin, which communicate via port 6311. The latter container exposes port 50051, which is used for the connection from Qlik Sense.

Before connecting from Qlik Sense it's necessary to tweak the settings file, replacing `localhost` with the IP address of the Linux machine.

```
[Settings 7]
SSEPlugin=R,192.168.0.4:50051
```

At this point you're ready to connect from Qlik Sense to the remote Rserve instance.

## Testing

In the SSE R-plugin repository there's a `sense_apps/` folder which contains a few example applications. There's also a sub-folder with a couple of Qlik Sense extensions which need to be installed before running the examples.

Once the extensions are installed, simply drag any of the `.qvf` files under the `sense_apps` folder onto the Qlik Sense desktop. Below is the Decision Tree app, which uses R to build a model on the Titanic data.

![](/img/2019/03/qlik-sense-rstats-decision-tree.png)