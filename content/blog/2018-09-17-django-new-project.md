---
author: Andrew B. Collier
draft: true
title: '#MonthOfDjango Day 2: Kicking off a New Project'
tags: ["Django"]
date: 2018-09-17T02:00:00Z
---

<!-- https://docs.djangoproject.com/en/2.1/intro/tutorial01/ -->

Check that Python 3 and Django are installed.

{{< highlight bash >}}
$ python -m django --version
{{< /highlight >}}

I've got Django version 2.1.1.

{{< highlight bash >}}
$ django-admin startproject demo
{{< /highlight >}}

That will create a new `demo` folder and populate it with some boilerplate code.

{{< highlight bash >}}
$ tree demo
demo
├── demo
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── manage.py

1 directory, 5 files
{{< /highlight >}}

## Starting the Development Server

{{< highlight bash >}}
$ cd demo
{{< /highlight >}}

{{< highlight bash >}}
$ python manage.py runserver
{{< /highlight >}}

You can safely ignore the warnings about unapplied migrations for the moment.

You can change the port on which the development server is running and also make it visible to other computers on the network.

{{< highlight bash >}}
$ python manage.py runserver 0:8080
{{< /highlight >}}

## Adding an App

{{< highlight bash >}}
$ python manage.py startapp core
{{< /highlight >}}

{{< highlight bash >}}
$ tree -L 2
.
├── core
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   ├── models.py
│   ├── tests.py
│   └── views.py
├── db.sqlite3
├── demo
│   ├── __init__.py
│   ├── __pycache__
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── manage.py

4 directories, 12 files
{{< /highlight >}}

## Next Steps

We're now ready to start adding functionality to the new app. This is typically how we'd proceed:

- add a view in `demo/views.py`
- map a URL to the view via `demo/urls.py` and
- link the root 
