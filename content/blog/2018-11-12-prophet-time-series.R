install.packages("pageviews")

library(pageviews)
library(prophet)
library(dplyr)
library(ggplot2)

influenza <- article_pageviews(project = "en.wikipedia",
                           article = c("Influenza", "Swine_influenza", "Avian_influenza"),
                           start = as.Date('2015-07-01'), end = as.Date("2018-06-30"),
                           user_type = "user")

saveRDS(influenza, "influenza-views.rds")

influenza <- influenza %>%
  mutate(log_views = log10(views)) %>%
  select(date, article, views, log_views)

ggplot(views, aes(x = date, y = views)) +
  geom_line() +
  facet_wrap(~ article, ncol = 1, scales = "free_y") +
  labs(x = "", y = "Views") +
  theme(panel.background = element_blank())

ggplot(views, aes(x = date, y = log_views)) +
  geom_line() +
  facet_wrap(~ article, ncol = 1, scales = "free_y") +
  labs(x = "", y = "log(Views)") +
  theme(panel.background = element_blank())

model <- prophet()

df <- influenza %>%
  filter(article == "Influenza") %>%
  rename(
    ds = date,
    y = views
  )

# SIMPLE MODEL --------------------------------------------------------------------------------------------------------

model <- prophet(df)

future <- make_future_dataframe(model, periods = 31)

predictions <- predict(model, future)

plot(model, predictions) + labs(x = "", y = "")

prophet_plot_components(model, predictions)
#
# DOES THIS TREND LOOK RIGHT?

if ("month" %in% input$seasonality) {
  model <- model %>% add_seasonality(name = 'monthly', period = 30.5, fourier.order = input$fourier)
}
model %>% fit.prophet(data())

# OUTBREAKS -----------------------------------------------------------------------------------------------------------

# BIG PEAK IN 2016 IS BEING PICKED UP IN SEASONALITY. RATHER ASSOCIATE THIS WITH A "SPECIAL EVENT".