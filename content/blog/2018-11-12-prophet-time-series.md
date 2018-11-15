---
author: Andrew B. Collier
date: 2018-11-04T02:00:00Z
tags: ['R']
title: Prophet for Multi-Seasonal Time Series
draft: true
---

A colleague recently suggested that [Prophet]() was "simplistic". This surprised me, because I've always thought of it as a rather intricate tool. Regardless of the true level of sophistication, this prompted me to think about the relative merits of [TBATS](https://robjhyndman.com/hyndsight/forecasting-weekly-data/) and Prophet for a particular project that we're working on.

The Prophet model has three parts:

- trend (non-periodic)
- seasonality (periodic) and
- holidays (irregular events).

The approach used by Prophet is essentially regression, yielding a model which is quite distinct from classical time series models like ARIMA. This approach has a number of advantages:

- fitting is fast;
- observations need not be at regular intervals;
- multiple seasonalities are possible; and
- the model has parameters which are readily interpreted.

- Taylor, S. J., & Letham, B. (2018). [Forecasting at Scale](https://doi.org/10.1080/00031305.2017.1380080). The American Statistician, 72(1), 37–45.
- de Livera, A. M., Hyndman, R. J., & Snyder, R. D. (2011). [Forecasting time series with complex seasonal patterns using exponential smoothing](https://doi.org/10.1198/jasa.2011.tm09771). Journal of the American Statistical Association, 106(496), 1513–1527.

{{< highlight r >}}
{{< /highlight >}}


{{< highlight r >}}
{{< /highlight >}}

{{< highlight r >}}
{{< /highlight >}}

{{< highlight r >}}
{{< /highlight >}}

## Adding Seasonalities

By default Prophet will consider yearly, weekly and daily seasonalities. It's pretty clever about figuring out which of these should be included in a model. For example, if your data are sampled at intervals of a day or more than the daily seasonality will be automatically excluded.

It's possible to include seasonality at other time scales using `add_seasonality()`. For example, to add monthly seasonality to the model we could do something like this:

{{< highlight r >}}
prophet() %>%
  add_seasonality(name = 'monthly', period = 30.5) %>%
  fit.prophet(df)
{{< /highlight >}}

For each new seasonal component you can also specify the Fourier order, prior scale and mode (additive or multiplicative) using optional arguments to `add_seasonality()`.

## Holidays & Events

https://facebook.github.io/prophet/docs/seasonality,_holiday_effects,_and_regressors.html

## Trend Changepoints

https://facebook.github.io/prophet/docs/trend_changepoints.html

## Outliers

https://facebook.github.io/prophet/docs/outliers.html

## Prior Scales

EXPLORE PRIOR SCALES FOR SEASONALITY, HOLIDAYS AND CHANGEPOINTS

## Forecast Components

Breaking the model down into parts to understand the contributions to the model.

## Bayesian or MAP?

https://facebook.github.io/prophet/docs/uncertainty_intervals.html

By defauly Prophet will use Stan to find a maximum *a posteriori* (MAP) estimate. However, it's also possible to perform a full Bayesian analysis, which will then include parameter uncertainties into the model.

## Cross Validation

