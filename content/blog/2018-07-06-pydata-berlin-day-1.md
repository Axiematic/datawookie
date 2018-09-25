---
author: Andrew B. Collier
date: 2018-07-06T18:00:00Z
tags: ["Python", "Conference"]
title: PyData (Berlin) 2018
draft: true
---

## Day 1

These are notes from Day 1 of PyData (Berlin) 2018. Opinions are those of the speakers and not necessarily mine.

### Tricks, Tips and Topics in Text Analysis

The tutorial material are available [here](https://github.com/bhargavvader/personal/tree/master/notebooks/text_analysis_tutorial).

NLTK is an academic package, somewhat bloated and not suited to production.

The idea was to follow along with the tutorial, but the WiFi was not working, so unfortunately that was not possible.

### PyTorch

[PyTorch](https://pytorch.org) is a deep learning framework which leverages GPUs for computation.

Apparently in the context of Deep Learning, a "tensor" is just another term for a multi-dimensional array. I feel that this is an over-simplification. Most (all?) of the operations that can be applied to a NumPy `ndarray` can also be applied to a `Tensor` in PyTorch. But there's more to it than that.

### Production ready Data-Science with Python and Luigi (Mark Keinhörster)

NOTE NOTE NOTE: tuty-fruity data set from Kaggle

Built a Deep Learning model to differentiate between images of bananas and lemons. First he created a benchmark model using OpenCV. This model already achieved an accuracy of 95%.

Luigi provides a framework for stringing together long running tasks. It has existing templates for a variety of systems.

### Deploying a machine learning model to the cloud using AWS Lambda (Benjamin Weigel)

The code for this workshop can be found [here](https://github.com/bweigel/ml_at_awslambda_pydatabln2018). The [slides](https://bweigel.github.io/pydata_bln_2018/) and a [Docker image](https://hub.docker.com/r/bweigel/ml_at_awslambda_pydatabln2018_autobuild/) are also available.

## Day 2

### Hacking the Iron Curtain: From smuggling computer parts to owning the world (Andrada Fiscutean)

Andrada Fiscutean ([@AFiscutean](https://twitter.com/AFiscutean)): What do you do when you can't buy a computer? You build one yourself!

"Computers used cassette tapes for storage back then." I remember this clearly. The first computer I got my hands on was a ZX-81.

Building computers with components purchased on the black market was illegal. However, the police generally turned a blind eye: perhaps I'll need this guy to build me a computer in the future, so I'll leave him alone.

https://arstechnica.com/gadgets/2017/11/the-underground-story-of-cobra-the-1980s-illicit-handmade-computer/

### Five things I learned from turning research papers into industry prototypes (Ellen König)

https://www.quora.com/What-does-baseline-mean-in-machine-learning

http://codecapsule.com/2012/01/18/how-to-implement-a-paper/

### Spatial Data Analysis With Python (Dillon R. Gardner)

The repository for this talk is [here](https://github.com/dillongardner/PyDataSpatialAnalysis).

Tools: Shapely, GeoPandas... and others.

### Launch Jupyter to the Cloud: an example of using Docker and Terraform (Cheuk Ting Ho)

Terraform is a tool for building, changing and combining infrastructure safely and efficiently. It's infrastructure as code. The [repository](https://github.com/hashicorp/terraform) for Terraform.

How to launch Jupyter on Google Cloud Platform.

The repository for the demo is [here](https://github.com/Cheukting/jupyter-cloud-demo).

### 

Alejandro Saucedo [@axsaucedo](https://twitter.com/axsaucedo/)