---
author: Andrew B. Collier
date: 2018-12-26T04:00:00Z
tags: ['R', 'survey']
title: "Survey Raking: An Illustration"
---

{{< comment >}}
Useful references:

http://sdaza.com/survey/2012/08/25/raking/

Pasek, J. (2010). ANES Weighting Algorithm: A Description. Stanford University.

Battaglia, M., D. Izrael, D. C. Hoaglin, and M. Frankel. 2004. “Tips and Tricks for Raking Survey Data (Aka Sample Balancing).” American Association of Public Opinion Research.

Gelman, Andrew. 2007. “Struggles with Survey Weighting and Regression Modeling.” Statistical Science 22(2):153-64.

Heeringa, Steven, Brady T. West, and Patricia A. Berglund. 2010. Applied Survey Data Analysis. Boca Raton, FL: Chapman & Hall/CRC.

Valliant, Richard, Jill A. Dever, and Frauke Kreuter. 2013. Practical Tools for Designing and Weighting Survey Samples. New York, NY: Springer New York.
{{< /comment >}}

<img src="/img/2018/12/garden-rake.jpg" width="100%">

Analysing survey data can be tricky. There's often a mismatch between the characteristics of the survey respondents and and those of the general population. If the discrepancies are not accounted for then the survey results can (and generally will!) be misleading.

A common approach to this problem is to weight the individual survey responses so that the marginal proportions of the survey are close to those of the population. Raking (also known as *proportional fitting*, *sample-balancing*, or *ratio estimation*) is a technique for generating the required weights.

A fictional population and an imaginary survey are used to illustrate how survey raking works.

## Fictional Population Characteristics

A census gives a breakdown of the fictional population according to three categories: mood, sex and age.

{{< highlight r >}}
> population
      mood    sex    age fraction
1    happy female  young   0.0750
2  neutral female  young   0.1250
3   grumpy female  young   0.0500
4    happy   male  young   0.0750
5  neutral   male  young   0.1250
6   grumpy   male  young   0.0500
7    happy female middle   0.0600
8  neutral female middle   0.1000
9   grumpy female middle   0.0400
10   happy   male middle   0.0600
11 neutral   male middle   0.1000
12  grumpy   male middle   0.0400
13   happy female senior   0.0165
14 neutral female senior   0.0275
15  grumpy female senior   0.0110
16   happy   male senior   0.0135
17 neutral   male senior   0.0225
18  grumpy   male senior   0.0090
{{< /highlight >}}

To apply raking we only need to know the marginal proportions of these categories, which can be derived from the data above. Use the `wpct()` function from the [`weights`](https://cran.r-project.org/web/packages/weights/index.html) package.

{{< highlight r >}}
library(weights)
target <- with(population, list(
  mood = wpct(mood, fraction),
  sex  = wpct(sex, fraction),
  age  = wpct(age, fraction)
))
{{< /highlight >}}

Store the marginal proportions in a `list`, where the elements of the list are named according to variable they'll match in survey data.

{{< highlight r >}}
> str(target)
List of 3
 $ mood: Named num [1:3] 0.3 0.5 0.2
  ..- attr(*, "names")= chr [1:3] "happy" "neutral" "grumpy"
 $ sex : Named num [1:2] 0.505 0.495
  ..- attr(*, "names")= chr [1:2] "female" "male"
 $ age : Named num [1:3] 0.5 0.4 0.1
  ..- attr(*, "names")= chr [1:3] "young" "middle" "senior"
{{< /highlight >}}

## Imaginary Survey Results

The imaginary survey has ten thousand responses to a binary question. I'm imagining that it's a survey for an important referendum, gauging the sentiment of the population on a particular proposal.

{{< highlight r >}}
> nrow(survey)
[1] 10000
{{< /highlight >}}

Here's a sample of the results.

{{< highlight r >}}
> head(survey)
  caseid    mood    sex    age response
1      1  grumpy   male  young        1
2      2   happy   male senior        1
3      3 neutral   male senior        1
4      4   happy female  young        1
5      5  grumpy   male  young        1
6      6   happy female  young        0
{{< /highlight >}}

Now let's take a look at the proportions of the survey characteristics.

{{< highlight r >}}
> wpct(survey$mood)
  happy neutral  grumpy 
 0.3308  0.3372  0.3320 
> wpct(survey$sex)
female   male 
0.4971 0.5029 
> wpct(survey$age)
 young middle senior 
0.3393 0.3341 0.3266 
{{< /highlight >}}

The survey design was such that the levels of each of the survey characteristics were sampled in similar proportion. For sex this works well because the sample proportions are close to those in the population. For mood, however, this means that the proportion of neutral in the survey is less than in the population, while the sample proportion of grumpy is higher than in the population. Similarly, for age the senior category is oversampled in the survey, while the middle and young categories are undersampled.

What's the result of the survey if we naively just average the responses?

{{< highlight r >}}
> wpct(survey$response)
     0      1 
0.4277 0.5723
{{< /highlight >}}

It *appears* that 57% of the survey respondents were in favour of the proposal. Of course, we know that this is probably not an accurate reflection of the sentiment of the population, because our survey is not an accurate representation of the population demographics.

Let's use raking to fix that!

## Raking

We'll use the [`anesrake`](https://cran.r-project.org/web/packages/anesrake/index.html) package, which implements the ANES (American National Election Study) [weighting algorithm](https://web.stanford.edu/group/iriss/cgi-bin/anesrake/resources/RakingDescription.pdf). The algorithm, documented by DeBell and Krosnick ([Computing Weights for American National Election Study Survey Data](https://www.electionstudies.org/wp-content/uploads/2018/04/nes012427.pdf), 2009), aims to provide a default approach to survey weighting (there's no single "right" way to do survey weighting, but this is a decent starting point). It uses an iterative procedure to generate multiplicative weights. The weights are chosen so that the survey marginals agree with the population marginals for a specific set of parameters. In each iteration all parameters are considered in turn. For each parameter weights are adjusted to align the survey marginals with the population marginals. These weights are then used as the starting point for the next parameter.

{{< highlight r >}}
> library(anesrake)
{{< /highlight >}}

The `anesrake()` function has three required parameters:

- `inputter` - a list of target values
- `dataframe` - the survey results and
- `caseid` - a unique identifier for each respondent in the survey (normally a part of the survey results).

The remaining parameters are optional. The `choosemethod` and `type` parameters affect the way that parameters are selected for inclusion in the weighting procedure. Ideally you want to choose only those parameters where there is a *significant* discrepancy between the sample and population proportions.

One important thing to note is that `anesrake()` does not play nicely with tibbles. So if your data are in a tibble, then convert to a data frame first!

{{< highlight r >}}
> raking <- anesrake(target,
+                    survey,
+                    survey$caseid,
+                    cap = 5,                      # Maximum allowed weight per iteration
+                    choosemethod = "total",       # How are parameters compared for selection?
+                    type = "pctlim",              # What selection criterion is used?
+                    pctlim = 0.05                 # Threshold for selection
+                    )
[1] "Raking converged in 7 iterations"
{{< /highlight >}}

It returns a list with a number of components. Fortunately there's a `summary()` method which gives a quick overview of the results.

{{< highlight r >}}
> raking_summary <- summary(raking)
{{< /highlight >}}

Which variables were used for weighting?

{{< highlight r >}}
> raking_summary$raking.variables
[1] "mood" "age" 
{{< /highlight >}}

Only mood and age were used. As we observed previously, the sample proportions for sex are already pretty close to those of the population.

Let's take a look at the specifics for those two variables.

{{< highlight r >}}
> raking_summary$mood
        Target Unweighted N Unweighted % Wtd N Wtd % Change in % Resid. Disc. Orig. Disc.
happy      0.3         3308       0.3308  3000   0.3     -0.0308            0     -0.0308
neutral    0.5         3372       0.3372  5000   0.5      0.1628            0      0.1628
grumpy     0.2         3320       0.3320  2000   0.2     -0.1320            0     -0.1320
Total      1.0        10000       1.0000 10000   1.0      0.3256            0      0.3256
{{< /highlight >}}

The summary data for mood gives the number of cases and proportions for each level in both the unweighted and weighted survey. It also tells us

- how the proportions change between the unweighted and weighted surveys (the `Change in %` column);
- the discrepancy between the unweighted and target proportions (the `Orig. Disc.`) --- the discrepancy before weighting; and
- the discrepancy between the weighted and target proportions (the `Resid. Disc.`) --- the residual discrepancy after weighting.

Obviously we want the residual discrepancy to be as small as possible and here we can see that the mood proportions are perfect after weighting.

{{< highlight r >}}
> raking_summary$age
       Target Unweighted N Unweighted % Wtd N Wtd % Change in %  Resid. Disc. Orig. Disc.
young     0.5         3393       0.3393  5000   0.5      0.1607  1.110223e-16      0.1607
middle    0.4         3341       0.3341  4000   0.4      0.0659  0.000000e+00      0.0659
senior    0.1         3266       0.3266  1000   0.1     -0.2266 -1.387779e-17     -0.2266
Total     1.0        10000       1.0000 10000   1.0      0.4532  1.249001e-16      0.4532
{{< /highlight >}}

Similarly, for age the proportions are effectively perfect after weighting.

What about sex? Well, although sex was not used in the weighting algorithm, the weightings still have an effect on their proportions.

{{< highlight r >}}
> raking_summary$sex
       Target Unweighted N Unweighted %     Wtd N     Wtd %  Change in % Resid. Disc. Orig. Disc.
female  0.505         4971       0.4971  5006.939 0.5006939  0.003593906  0.004306094      0.0079
male    0.495         5029       0.5029  4993.061 0.4993061 -0.003593906 -0.004306094     -0.0079
Total   1.000        10000       1.0000 10000.000 1.0000000  0.007187812  0.008612188      0.0158
{{< /highlight >}}

The discrepancies in the unweighted results are small and the residual discrepancies after weighting are smaller still (it could have gone the other way too!).

## Examining the Weights

It makes sense to inject the weights into the survey data.

{{< highlight r >}}
> survey$weight <- raking$weightvec
{{< /highlight >}}

What does that look like?

{{< highlight r >}}
> head(survey, 10)
   caseid    mood    sex    age response    weight
1       1  grumpy   male  young        1 0.8790030
2       2   happy   male senior        1 0.2732412
3       3 neutral   male senior        1 0.4531776
4       4   happy female  young        1 1.3322952
5       5  grumpy   male  young        1 0.8790030
6       6   happy female  young        0 1.3322952
7       7 neutral   male middle        1 1.8035884
8       8  grumpy   male senior        1 0.1802753
9       9  grumpy female  young        0 0.8790030
10     10   happy female  young        0 1.3322952
{{< /highlight >}}

What is the range of weights?

{{< highlight r >}}
> survey %>% select(mood, age, weight) %>% unique() %>% arrange(weight)
     mood    age    weight
1  grumpy senior 0.1802753
2   happy senior 0.2732412
3 neutral senior 0.4531776
4  grumpy middle 0.7174723
5  grumpy  young 0.8790030
6   happy middle 1.0874649
7   happy  young 1.3322952
8 neutral middle 1.8035884
9 neutral  young 2.2096458
> raking_summary$weight.summary
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1803  0.4532  0.8790  1.0000  1.3323  2.2096
{{< /highlight >}}

The weights are always adjusted so that the average weight is precisely one. Large weights are likely to be problematic. The `cap` parameter to `anesrake()` places an upper limit on the weights in each iteration. The largest weight in our survey falls below the default upper limit of 5. It's always worthwhile checking on the range of weights just so that you are aware of whether they are being capped or not.

## Interpreting the Weights

Characteristics that were oversampled in the survey (like grumpy young females) get a weight smaller than one, while those that were undersampled (like middle aged neutral males) get a weight that is larger than one. Note that since sex was not included in the weighting algorithm, it does not influence weight: the weight for a grumpy young female is the same as that for a grumpy young male.

{{< highlight r >}}
> survey %>% group_by(mood) %>% summarise(count = n(), weight = sum(weight))
# A tibble: 3 x 3
  mood    count weight
  <fct>   <int>  <dbl>
1 happy    3308  3000.
2 neutral  3372  5000.
3 grumpy   3320  2000.
> survey %>% group_by(age) %>% summarise(count = n(), weight = sum(weight))
# A tibble: 3 x 3
  age    count weight
  <fct>  <int>  <dbl>
1 young   3393  5000.
2 middle  3341  4000.
3 senior  3266  1000.
{{< /highlight >}}

Although the proportions of samples (the `count` column) are not consistent with those in the population, the proportions of total weights most definitely are. So as long as we interpret the survey results taking into account these weights them we can be reasonably confident that they represent the population and not just the (possibly biased) survey.

## Effect on Survey Results

What was the effect of raking on the survey results?

{{< highlight r >}}
> wpct(survey$response, survey$weight)
        0         1 
0.5340386 0.4659614
{{< /highlight >}}

Wow! The outcome swings completely the other way. A naive interpretation of the survey results would have been completely misleading. Actually around 53% of the population are opposed to the proposal.

Weighting results in an increase in the variance of means or proportions derived from survey results. We can get an idea of how large this effect is by looking at the design effect.

{{< highlight r >}}
> raking_summary$general.design.effect
[1] 1.422105
{{< /highlight >}}

This indicates that weighting results in a 42% increase in variance. Unfortunately this means that conclusions are less likely to be statistically significant. However, this is probably a worthwhile trade off: they might not be significant, but at least they will be representative of the population!
