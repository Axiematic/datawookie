---
author: Andrew B. Collier
draft: true
title: '#MonthOfDjango Day 3: Database Setup'
tags: ["Django"]
date: 2018-09-17T02:00:00Z
---

<!-- https://docs.djangoproject.com/en/2.1/intro/tutorial02/ -->

Open the `settings.py` file and search for "DATABASES".

By default a new project will use a SQLite database. This is perfect for experimental purpose (and, in some cases, can work in production), but generally you'll want to migrate to another database.

There are a bunch of backends available, but we'll use MySQL. Modify the `DATABASES` section so that it looks something like this:

{{< highlight text >}}
DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'demo',
            'USER': 'db_user',
            'PASSWORD': 'db_password',
            'HOST': 'localhost',
        }
}
{{< /highlight >}}

Insert appropriate values for the database username and password.

You'll need to create the database first.

{{< highlight bash >}}
$ mysql
mysql> CREATE DATABASE demo;
{{< /highlight >}}

You'll also need to install the `MySQLdb` Python module.

{{< highlight bash >}}
$ pip install mysqlclient
{{< /highlight >}}

Now you're ready to migrate the database.

{{< highlight bash >}}
$ python manage.py migrate
{{< /highlight >}}
