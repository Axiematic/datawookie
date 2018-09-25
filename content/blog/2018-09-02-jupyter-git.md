---
author: Andrew B. Collier
date: 2018-08-09T02:00:00Z
tags: ["spark", "python", "jupyter"]
title: "Fostering Cooperation between Jupyter and Git"
---

## Install 

git clone git@github.com:kynan/nbstripout.git

Select version 0.3.3.

cd nbstripout
git checkout 1a4e006320f2e2949c8f52c852c98de97100b42f

python3 setup.py install --user

That will create a `nbstripout` script in `~/.local/bin/`. Make sure that folder is in your `PATH`.

## Updates to Git Repository

In the repository edit `.gitattributes`:

{{< highlight text >}}
*.ipynb filter=nbstripout
*.ipynb diff=ipynb
{{< /highlight >}}

Also add these to `.git/config`:

{{< highlight text >}}
[filter "nbstripout"]
	clean = "nbstripout"
	smudge = cat
	required = true
[diff "ipynb"]
	textconv = nbstripout -t
{{< /highlight >}}