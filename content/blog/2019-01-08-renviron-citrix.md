---
author: Andrew B. Collier
date: 2019-01-08T04:00:00Z
tags: ['R']
title: "Where does .Renviron live on Citrix?"
---

<img src="/img/2019/01/citrix-rstudio.png" width="100%">

At one of my clients I run RStudio under Citrix in order to have access to their data.

For the most part this works fine. However, every time I visit them I spend the first few minutes of my day installing packages because my environment does not seem to be persisted from one session to the next.

I finally had a gap and decided to fix the problem.

## Where are the packages being installed?

Installed packages just spontaneously disappear... That's weird. Where are they being installed?

{{< highlight r >}}
# Install package under Citrix.
> install.packages("devtools")
Installing package into ‘C:/Users/andrewcol/Documents/R/win-library/3.5’
{{< /highlight >}}

It looks like the packages are being installed into a folder on my C: drive. But if I look for that folder it's not there.

How does this make sense?

A bit of investigation revealed that the folder is actually on the C: drive on the Citrix server (rather than my local machine).

I confirmed this by installing the same package using RStudio running on my local machine.

{{< highlight r >}}
# Install package on local.
> install.packages("devtools")
Installing package into ‘C:/Users/AndrewCol/Documents/R/win-library/3.4’
{{< /highlight >}}

Note the difference in the path (`andrewcol` versus `AndrewCol`) and R versions.

## Environment

I know that files on my network H: drive will not disappear between sessions, so this seems like a natural place to install packages. I can make this happen by changing the `R_LIBS_USER` environment variable.

{{< highlight r >}}
# Environment on Citrix.
> Sys.getenv("R_LIBS_USER")
[1] "C:/Users/andrewcol/Documents/R/win-library/3.5"
{{< /highlight >}}

We'll assign a new value by setting up a `.Renviron` file. Where should this file live? On my local C: drive, my network H: drive or the Citrix server C: drive?

{{< highlight r >}}
# Environment on Citrix.
> Sys.getenv("R_USER")
[1] "C:/Users/andrewcol/Documents"
{{< /highlight >}}

Okay, so it needs to go on the Citrix C: drive. This is really the crux of the entire process, because if you put it on H: or local C: then it will not be picked up by RStudio on Citrix.

## Writing to Citrix C:

It turns out that it's remarkably difficult to access C: on the Citrix server. I couldn't get there using File Explorer. I couldn't create a new file there using Notepad or RStudio.

No problem! Write an R script.

{{< highlight r >}}
renviron <- file("C:/Users/andrewcol/Documents/.Renviron", "w")
cat(
    "R_LIBS_USER='H:/myCitrixFiles/Documents/R/%p-library/%v'",
    "R_USER='H:/myCitrixFiles/Documents'",
    file = renviron,
    sep = "\n"
)
close(renviron)
{{< /highlight >}}

That'll create the `.Renviron` file in the right place and insert the required content. Note the use of the `%p` and `%v` placeholders which will be automatically replaced with the appropriate platform and R version. See `?R_LIBS_USER`. Thanks to [Henrik Bengtsson](https://github.com/HenrikBengtsson) for reminding me about that!

Quick check that it's been created.

{{< highlight r >}}
setwd("C:/Users/andrewcol/Documents")
list.files(all.files = TRUE)
readLines(".Renviron")
{{< /highlight >}}

Restart RStudio under Citrix. Packages will be installed to H: and should not mysteriously disappear between sessions.

