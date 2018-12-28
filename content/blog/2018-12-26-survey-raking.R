library(dplyr)

set.seed(13)

LEVELS_MOOD = c("happy", "neutral", "grumpy")
LEVELS_AGE    = c("young", "middle", "senior")

# Census data (synthetic).
#
population <- expand.grid(
  mood = LEVELS_MOOD,
  sex  = c("female", "male"),
  age  = LEVELS_AGE
) %>%
  mutate(
    fraction = c(rep(0.5, 6) * rep(c(0.50, 0.50), each = 3) * c(0.3, 0.5, 0.2),
                 rep(0.4, 6) * rep(c(0.50, 0.50), each = 3) * c(0.3, 0.5, 0.2),
                 rep(0.1, 6) * rep(c(0.55, 0.45), each = 3) * c(0.3, 0.5, 0.2)
    ))

population

library(weights)

# Marginal proportions.
#
# NB: Elements of list need to be named according to variable that they will match in survey data.
#
target <- with(population, list(
  mood = wpct(mood, fraction),
  sex  = wpct(sex, fraction),
  age  = wpct(age, fraction)
))

str(target)

# Number of survey respondents.
#
N <- 10000

# Generate survey results.
#
# NB: Use a data.frame because a tibble will result in a "non-numeric argument to binary operator" error.
#
survey <- data.frame(
  caseid = 1:N,
  mood   = sample(LEVELS_MOOD, N, replace = TRUE) %>% factor(levels = LEVELS_MOOD),
  sex    = sample(c("female", "male"), N, replace = TRUE),
  age    = sample(LEVELS_AGE, N, replace = TRUE) %>% factor(levels = LEVELS_AGE)
) %>% mutate(
  response = ifelse(age == "senior",
                    # Seniors more likely to give positive response.
                    sample(c(1, 0), N, replace = TRUE, prob = c(0.9, 0.1)),
                    sample(c(1, 0), N, replace = TRUE, prob = c(0.4, 0.6)))
)

head(survey)
nrow(survey)

wpct(survey$mood)
wpct(survey$sex)
wpct(survey$age)

library(anesrake)

raking <- anesrake(target,
                   survey,
                   survey$caseid,
                   cap = 5,                      # Maximum allowed weight per iteration
                   choosemethod = "total",       # How are parameters compared for selection?
                   type = "pctlim",              # What selection criterion is used?
                   pctlim = 0.05                 # Threshold for selection
                   )

raking_summary <- summary(raking)

raking_summary$raking.variables

# Variables included in the weighting.
#
raking_summary$mood
raking_summary$age

# Variable not included in the weighting.
#
raking_summary$sex

survey$weight <- raking$weightvec

survey %>% select(mood, age, weight) %>% unique() %>% arrange(weight)
raking_summary$weight.summary

head(survey, 10)

wpct(survey$response)
wpct(survey$response, survey$weight)

library(Hmisc)

wtd.mean(survey$response)
wtd.mean(survey$response, survey$weight)

# Weights increase the variance.
#
wtd.var(survey$response)
wtd.var(survey$response, survey$weight)
