---
author: Andrew B. Collier
date: 2018-09-28T02:00:00Z
tags: ["Docker", "Spark"]
title: "Docker Images for Spark"
---

I recently put together a short training course on [Spark](http://spark.apache.org/). One of the initial components of the course involved deploying a Spark cluster on AWS. I wanted to have Jupyter Notebook and RStudio servers available on the master node too and the easiest way to make that happen was to install [Docker](https://www.docker.com/) and then run appropriate images.

There's already a [jupyter/pyspark-notebook](https://hub.docker.com/r/jupyter/pyspark-notebook/) image which includes Spark and Jupyter. It's a simple matter to extend the [rocker/verse](https://hub.docker.com/r/rocker/verse/) image (which already includes RStudio server, the tidyverse, `devtools` and some publishing utilities) to include the `sparklyr` package.

Creating an instance from either of these images immediately allows access to Spark from Python and R. However, I wanted to cover two topics that would not work immediately with either:

- access to files on S3 and
- streaming data from Kafka.

Both of these operations require additional Java artifacts. Specifically you need `hadoop-aws`, `aws-java-sdk` and `spark-streaming-kafka`.

Now it's perfectly possible to download these manually and insert them into the appropriate location on a container. But you'd have to do that every time you launch a new container. Nobody has time for that.

Docker comes into its own in precisely this situation: adding new capabilities to an existing image. I've derived two new images which include these artifacts:

- [datawookie/pyspark-notebook](https://hub.docker.com/r/datawookie/pyspark-notebook/) and
- [datawookie/rstudio-sparklyr](https://hub.docker.com/r/datawookie/rstudio-sparklyr/).

So if you want to access S3 or Kafka from Spark, then pull and run one of these images. Feedback for how these images can be improved or extended is very welcome.

## Jupyter with Spark

To pull and launch the `datawookie/pyspark-notebook` image:

```
docker pull datawookie/pyspark-notebook
docker run --name jupyter -p 8888:8888 datawookie/pyspark-notebook
```

## RStudio with Spark

To pull and launch the `datawookie/rstudio-sparklyr` image:

```
deocker pull datawookie/rstudio-sparklyr
docker run --name rstudio -p 8787:8787 datawookie/rstudio-sparklyr
```