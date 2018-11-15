---
author: Andrew B. Collier
date: 2017-08-21T11:00:00Z
tags: ["Kaggle", "AWS"]
title: Retrieving Kaggle Data from the Command Line
---

We've been building some models for Kaggle competitions using an EC2 instance for compute. I initially downloaded the data locally and then pushed it onto EC2 using SCP. But there had to be a more efficient way to do this, especially given the blazing fast bandwidth available on AWS.

Enter [kaggle-cli](https://github.com/floydwch/kaggle-cli).

*Update:* Apparently kaggle-cli has been deprecated in favour of [kaggle-api](https://github.com/Kaggle/kaggle-api). More information below.
<!--more-->

## kaggle-cli

### Installation

Installation is very simple.

{{< highlight bash >}}
sudo pip install kaggle-cli
{{< /highlight >}}

This will expose the `kg` shell command. You can use it interactively or via an selection of command line arguments.

{{< highlight text >}}
usage: kg [--version] [-v | -q] [--log-file LOG_FILE] [-h] [--debug]

An unofficial Kaggle command line tool.

optional arguments:
  --version            show program's version number and exit
  -v, --verbose        Increase verbosity of output. Can be repeated.
  -q, --quiet          Suppress output except warnings and errors.
  --log-file LOG_FILE  Specify a file to log output. Disabled by default.
  -h, --help           Show help message and exit.
  --debug              Show tracebacks on errors.

Commands:
  complete       print bash completion command
  config         Set config.
  dataset        Download dataset from a specific user.
  download       Download data files from a specific competition.
  help           print detailed help for another command
  submissions    List recent submissions.
  submit         Submit an entry to a specific competition.
{{< /highlight >}}

### Downloading Data

We'd use the `download` command to get the data for a particular competition.

{{< highlight text >}}
usage: kg download [-h] [-c COMPETITION] [-u USERNAME] [-p PASSWORD]
                   [-f FILENAME]

Download data files from a specific competition.

optional arguments:
  -h, --help            show this help message and exit
  -c COMPETITION, --competition COMPETITION
                        competition
  -u USERNAME, --username USERNAME
                        username
  -p PASSWORD, --password PASSWORD
                        password
  -f FILENAME, --filename FILENAME
                        filename
{{< /highlight >}}

The minimum requirements for this to work are a username, password and competition identifier. You get the latter by simply visiting the competition page on [Kaggle](https://www.kaggle.com/) and grabbing the last part of the URL.

So, for instance, to get the data for the recently closed [Instacart Market Basket Analysis](https://www.kaggle.com/c/instacart-market-basket-analysis) you do something like this:

{{< highlight bash >}}
kg download -u 'dvader@dstar.gov' -p '6%puZ$9_' -c 'instacart-market-basket-analysis'
{{< /highlight >}}

You can use the `-f` switch to grab just a single data file.

### Other Capabilities

You can also use `kg` to make and list submissions.

## kaggle-api

### Installation

Installation is similarly trivial.

{{< highlight bash >}}
sudo pip3 install kaggle
{{< /highlight >}}

### Configuration

You'll need to create a Kaggle API token. Go to the Account tab of your user profile on [Kaggle](https://www.kaggle.com/) and click the "Create New API Token" button. This will automatically download a JSON file, which you should move to `~/.kaggle/kaggle.json`. You might want to ensure that only your user has access to this file.

At this stage you are ready to use the `kaggle` shell command.

{{< highlight text >}}
usage: kaggle [-h] [-v] {competitions,c,datasets,d,kernels,k,config} ...

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit

commands:
  {competitions,c,datasets,d,kernels,k,config}
                        Use one of:
                        competitions {list, files, download, submit, submissions, leaderboard}
                        datasets {list, files, download, create, version, init, metadata, status}
                        config {view, set, unset}
    competitions (c)    Commands related to Kaggle competitions
    datasets (d)        Commands related to Kaggle datasets
    kernels (k)         Commands related to Kaggle kernels
    config              Configuration settings
{{< /highlight >}}

### Downloading Data

To get the data for the Instacart Market Basket Analysis:

{{< highlight bash >}}
kaggle competitions download 'instacart-market-basket-analysis'
{{< /highlight >}}