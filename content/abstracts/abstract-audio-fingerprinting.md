---
title: "Audio Fingerprinting"
date: 2017-09-13T09:30:00+00:00
author: Andrew B. Collier
---

An audio fingerprint is a digital summary of an audio signal which can be used to identify a sample from the signal. The technique underlies services like [Shazam](http://www.shazam.com/), [SoundHound](https://soundhound.com/) and Google’s Sound Search. Due to the fact that fingerprinting is often applied in a noisy environment, it's important that the algorithm be robust. It should also account for audio perception: if two sounds are alike to the human ear then their fingerprints should match.

In this talk I'll describe the audio fingerprinting algorithm implemented in the Python [dejavu](https://github.com/datawookie/dejavu) package, illustrate how well it works and speculate on some interesting applications.