---
author: Andrew B. Collier
draft: true
title: '#MonthOfDjango Day 3: Database Setup'
tags: ["Django"]
date: 2018-09-17T02:00:00Z
---

<!-- https://docs.djangoproject.com/en/2.1/intro/tutorial02/ -->

## Creating Models

You can add models to the `core` app by editing `core/models.py`.

## Adding to 

Add `core` to the list of installed apps in `settings.py`.

{{< highlight text >}}
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core'
]
{{< /highlight >}}

## Creating Migrations

Create and apply the migrations for the new models.

{{< highlight bash >}}
$ python manage.py makemigrations core
$ python manage.py migrate
{{< /highlight >}}
