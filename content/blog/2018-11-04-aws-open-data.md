---
author: Andrew B. Collier
date: 2018-11-04T02:00:00Z
tags: ['aws']
title: Accessing Open Data from AWS
---

There's a magnificent variety of open data available on AWS. To see the full list, head over to the [Registry of Open Data on AWS](https://registry.opendata.aws/).

When you find something that's of interest to you, click through to the respective page.

![](/img/2018/10/aws-open-data-openaq.png)

The vital piece of information on this page is the Amazon Resource Name (ARN). Grab the final portion of the ARN. That's the string that uniquely identifies the bucket on S3.

You can start by listing the contents of that bucket.

{{< highlight bash >}}
$ s3cmd ls s3://openaq-fetches
                       DIR   s3://openaq-fetches/daily/
                       DIR   s3://openaq-fetches/realtime-gzipped/
                       DIR   s3://openaq-fetches/realtime/
                       DIR   s3://openaq-fetches/test-realtime-events/
                       DIR   s3://openaq-fetches/test-realtime-gzip/
                       DIR   s3://openaq-fetches/test-realtime/
2017-11-13 17:22     25503   s3://openaq-fetches/index.html
{{< /highlight >}}

You'll want to dig deeper into those sub-folders.

{{< highlight bash >}}
$ s3cmd ls s3://openaq-fetches/daily/
2017-08-28 21:15  94659264   s3://openaq-fetches/daily/2017-08-11.csv
2017-08-28 21:30 100374293   s3://openaq-fetches/daily/2017-08-12.csv
2017-08-28 21:31  88065532   s3://openaq-fetches/daily/2017-08-13.csv
2017-08-28 21:39 101833818   s3://openaq-fetches/daily/2017-08-14.csv
2017-08-28 21:34 103143205   s3://openaq-fetches/daily/2017-08-15.csv
2017-08-28 21:34  94515910   s3://openaq-fetches/daily/2017-08-16.csv
2017-08-28 21:36  97968988   s3://openaq-fetches/daily/2017-08-17.csv
2017-08-28 21:42  97053154   s3://openaq-fetches/daily/2017-08-18.csv
2017-08-28 22:39  90520622   s3://openaq-fetches/daily/2017-08-19.csv
2017-08-20 23:57  82922740   s3://openaq-fetches/daily/2017-08-20.csv
2017-08-21 23:57  94653416   s3://openaq-fetches/daily/2017-08-21.csv
2017-08-22 23:57  92992684   s3://openaq-fetches/daily/2017-08-22.csv
2017-08-23 23:45  95234179   s3://openaq-fetches/daily/2017-08-23.csv
2017-08-24 23:54  93823825   s3://openaq-fetches/daily/2017-08-24.csv
2017-08-25 23:54  86603287   s3://openaq-fetches/daily/2017-08-25.csv
2017-08-26 23:56  90258727   s3://openaq-fetches/daily/2017-08-26.csv
2017-08-27 23:54  91695222   s3://openaq-fetches/daily/2017-08-27.csv
2017-08-28 23:54  96754902   s3://openaq-fetches/daily/2017-08-28.csv
2017-08-29 23:54  96610694   s3://openaq-fetches/daily/2017-08-29.csv
2017-08-30 23:57  93460333   s3://openaq-fetches/daily/2017-08-30.csv
2017-08-31 23:57 103100958   s3://openaq-fetches/daily/2017-08-31.csv
2017-09-01 23:54 103594588   s3://openaq-fetches/daily/2017-09-01.csv
2017-09-02 23:54 107980504   s3://openaq-fetches/daily/2017-09-02.csv
2017-09-03 23:54 105724371   s3://openaq-fetches/daily/2017-09-03.csv
2017-09-04 23:54  98595954   s3://openaq-fetches/daily/2017-09-04.csv
2017-09-05 23:54 106101931   s3://openaq-fetches/daily/2017-09-05.csv
2017-09-06 23:54  99360240   s3://openaq-fetches/daily/2017-09-06.csv
2017-09-07 21:34  82533516   s3://openaq-fetches/daily/2017-09-07.csv
2017-08-31 05:00         0   s3://openaq-fetches/daily/db_dump.csv
{{< /highlight >}}

Once you've found the data that you're looking for, simply retrieve it.

{{< highlight bash >}}
$ s3cmd get s3://openaq-fetches/daily/2017-09-07.csv
{{< /highlight >}}

Some of these files can be very large indeed. So prepare for a lengthy download or perhaps launch an EC2 instance on which to explore the data.