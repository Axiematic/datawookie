---
author: Andrew B. Collier
date: 2013-06-14T13:22:43Z
title: Kagi Chart Indicator
---

In addition to a range of [data analysis services](http://www.exegetic.biz/services.html), [Exegetic Analytics](http://www.exegetic.biz/) also implements algorithms for automated FOREX trading. I am currently developing an expert advisor (EA) for a client. The strategy was developed on the ProRealTime charting software using [Kagi Charts](http://en.wikipedia.org/wiki/Kagi_chart). My client wants to automate the strategy and implement it in MQL on the MetaTrader platform. One snag: Kagi Charts are independent of time. Or, more accurately, they do not have a uniform time axis. Charts in MetaTrader are of the classical variety with a nice linear time axis. So my first problem was to implement something analogous to the Kagi Chart under MetaTrader.

<!--more-->

The result is a new Kagi Chart indicator, pictured below. The yin and yang components of the chart are indicated by green and orange lines. There is a single adjustable parameter for the indicator which is the percentage change which results in a transition from yin to yang (or vice versa).

<img src="/img/2013/06/Selection_058.png" width="100%">

A quick proof of concept implementation of the trading algorithm using the signals generated by the new Kagi Chart indicator looks very promising.