---
author: Andrew B. Collier
date: 2018-10-31T02:00:00Z
tags: ["tool"]
title: Embedding Dependencies into a HTML File
---

I use HTML to generate slide decks. Usually my HTML will reference a host of other files on my machine (CSS, JavaScript and images). If I want to distribute my deck then I have a couple of options:

- just send the HTML file without all of the dependencies or
- send the HTML file and dependencies (normally wrapped up in some sort of archive).

Both of these have problems. In the former case the HTML just ends up looking like ass because it relies on all of those dependencies to sort out the aesthetics. In the latter case I need to take care of the directory structure and, if those dependencies are distributed across my file system (which they generally are!) then this can be a challenge.

However, there's a very handy tool called [inliner](https://github.com/remy/inliner) which resolves these issues.

Installation is simple.

{{< highlight bash >}}
sudo npm install -g inliner
{{< /highlight >}}

And creating a single HTML with all of those dependencies embedded is easy too.

{{< highlight bash >}}
inliner original-document.html >embedded-document.html
{{< /highlight >}}

If an internet connection is going to be available then you can reduce the file size by not embedding dependencies which are referred to by absolute URLs.

{{< highlight bash >}}
inliner --skip-absolute-urls original-document.html >embedded-document.html
{{< /highlight >}}

The tool works perfectly with local HTML files but can just as easily be applied to URLs.