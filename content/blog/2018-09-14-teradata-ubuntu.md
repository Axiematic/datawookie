---
author: Andrew B. Collier
date: 2018-09-14T02:00:00Z
tags: ["Ubuntu"]
title: "Setting up Teradata on Ubuntu"
draft: true
---

These are instructions for getting Teradata up and running on an Ubuntu 18.04 system (although they might apply to other versions of Ubuntu too!).

## Driver Installation

### Dependencies

The drivers have a dependency on `lib32stdc++6`.

{{< highlight bash >}}
$ sudo apt install lib32stdc++6
{{< /highlight >}}

### Download and Install

Download the ODBC driver for Ubuntu from [here](https://downloads.teradata.com/download/connectivity/odbc-driver/linux) (there's a separate subsection for Ubuntu). To download anything from the Teradata site you'll need to first create an account. Then refresh the download page so that the links become active.

Unpack the archive and move into the resulting folder.

{{< highlight bash >}}
$ tar -zxf tdodbc1620__ubuntu_indep.16.20.00.45-1.tar.gz
$ cd tdodbc1620/
{{< /highlight >}}

Take a look around. There should be just a single `.deb` file. Install it.

{{< highlight bash >}}
$ sudo dpkg -i tdodbc1620-16.20.00.45-1.noarch.deb
{{< /highlight >}}

Check that the installation was successful.

{{< highlight bash >}}
$ dpkg -l "tdodbc*" | grep ^ii
{{< /highlight >}}

Let's see what was installed.

{{< highlight bash >}}
$ dpkg -L tdodbc1620 | more
{{< /highlight >}}

There's a command line client, `tdxodbc64`, installed in `/opt/teradata/client/16.20/bin/`. This folder has not been added to `PATH`, so you'll need to use the full path to execute it. Also note that there are some sample applications (in C and C++) which demonstrate how to connect to a data source and execute a query.

## Teradata from R

{{< comment >}}
https://vimeo.com/240227259
https://db.rstudio.com/databases/teradata/
{{< /comment >}}

### ODBC

<!-- https://downloads.teradata.com/blog/odbcteam/2016/02/r-with-teradata-odbc -->

Install the RODBC package.

{{< highlight r >}}
install.packages("RODBC")
{{< /highlight >}}

{{< comment >}}
Data Source Name (DSN)

FIND OUT HOW TO SET UP DSN.

https://community.teradata.com/t5/Database/Trying-to-use-Teradata-ODBC-drivers-on-linux-redhat-with/td-p/60217

https://wiki.scn.sap.com/wiki/display/EIM/To+configure+Teradata+ODBC+on+Linux+and+Unix

http://community.teradata.com/t5/Analytics/Connecting-to-Teradata-in-R-via-the-teradataR-package-Teradata/m-p/28012

https://db.rstudio.com/best-practices/drivers/
https://db.rstudio.com/databases/teradata/
{{< /comment >}}

If you don't have a `.odbc.ini` file in your home folder then copy the ODBC configuration file template.

{{< highlight bash >}}
# Make sure that this does not clobber an existing file!
cp /opt/teradata/client/16.20/odbc_64/odbc.ini ~/.odbc.ini
{{< /highlight >}}

Create an entry with the Data Source Name (DSN) for the connection. You need to at least specify the IP address or DNS entry for the server here.

{{< highlight text >}}
[teradb]
Description=Teradata Database
Driver=/opt/teradata/client/16.20/odbc_64/lib/tdataodbc_sb64.so
DBCName=172.92.253.25
# UID=
# PWD=
{{< /highlight >}}

Now connect using the freshly created DSN.

{{< highlight r >}}
db <- odbcConnect(dsn = "teradb", uid = "andrew", pwd = "ter@d@t@")
{{< /highlight >}}

When you're done, terminate the connection.

{{< highlight r >}}
# Close specific connection.
odbcClose(db)
# Close all connections.
odbcCloseAll()
{{< /highlight >}}

### dplyr

There's a `dplyr.teradata` package which you can install from [CRAN](https://cran.r-project.org/web/packages/dplyr.teradata/) or [GitHub](https://github.com/hoxo-m/dplyr.teradata). A good place to start is with the [vignette](https://cran.r-project.org/web/packages/dplyr.teradata/vignettes/dplyr.teradata.html).

{{< highlight r >}}
install.packages("dplyr.teradata")
{{< /highlight >}}

{{< highlight r >}}
library(odbc)
library(dplyr.teradata)
{{< /highlight >}}

{{< highlight r >}}
con <- dbConnect(todbc(), 
                 driver = "tdataodbc_sb64.so",
                 DBCName = "host_name_or_IP_address",
                 uid = "user_name",
                 pwd = "*****")
{{< /highlight >}}
