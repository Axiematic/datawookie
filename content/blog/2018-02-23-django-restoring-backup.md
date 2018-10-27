---
author: Andrew B. Collier
date: 2018-02-23T10:00:00Z
tags: ["Django"]
title: Restoring a Django Backup
slug: django-restoring-backup
---

It took me a little while to figure out the correct sequence for restoring a Django backup. If you have borked your database, this is how to put it back together.

<!--more-->

1. Drop the old database.
2. Create a new database.
3. `python manage.py migrate`. Build all of the tables. Nothing in them yet though!
4. `python manage.py dbrestore`. Retrieve the data and insert it into appropriate tables. This will restore the most recent backup.

And you're back! It seems pretty trivial, but I hit my head against this a number of times and got very frustrated when things just wouldn't work. Follow this recipes and you're good.

As a side note, if it's taking a long, long, long time to restore your backup then you can add the following SQL code to the backup file:

{{< highlight sql >}}
-- Near the top of the file.
SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, AUTOCOMMIT = 0;
-- Near the bottom of the file.
SET AUTOCOMMIT = @OLD_AUTOCOMMIT;
COMMIT;
{{< /highlight >}}
