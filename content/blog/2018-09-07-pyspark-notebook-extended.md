---
author: Andrew B. Collier
date: 2018-08-09T02:00:00Z
tags: ["spark", "python", "jupyter"]
title: "Extending PySpark Notebook"
draft: true
---

The easiest way to launch a Jupyter Notebook with Spark functionality is to use a Docker image. There are two options:

- [jupyter/pyspark-notebook](https://hub.docker.com/r/jupyter/pyspark-notebook/) (Python) and
- [jupyter/all-spark-notebook](https://hub.docker.com/r/jupyter/all-spark-notebook/) (Python, Scala and R).

The development repositories for these Docker images (and a few others) can be found [here](https://github.com/jupyter/docker-stacks).

However, in using these images I have encountered some challenges when trying to access files on S3 and streaming from Kafka. In both instances I needed a [JAR](https://en.wikipedia.org/wiki/JAR_(file_format)) which was not included in the Docker image.

One way to deal with this issue is to download the required JAR and then modify the Spark submit arguments before creating a `SparkContext`.

```
import os
os.environ['PYSPARK_SUBMIT_ARGS'] = '--jars /home/jovyan/spark-streaming-kafka-0-8-assembly_2.11-2.3.1.jar pyspark-shell'
```

That works but it's a bit of a hack.

It'd be much better if the JARs were already included in the image.

SAY SOMETHING ABOUT NEW DOCKER IMAGE WHICH SOLVES THE PROBLEM.