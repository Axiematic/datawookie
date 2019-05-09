library(quantmod)
library(tibble)
library(dplyr)
library(tidyr)
library(ggplot2)
library(TSclust)

SYMBOLS = c('A', 'AAPL', 'ADBE', 'AMD', 'AMZN', 'BA', 'CL', 'CSCO', 'EXPE', 'FB', 'GOOGL',
            'GRMN', 'IBM', 'INTC', 'LMT', 'MSFT', 'NFLX', 'ORCL', 'RHT')

start = as.Date("2014-01-01")
until = as.Date("2014-12-31")

# Grab data, selecting only the Adjusted close price.
#
stocks = lapply(SYMBOLS, function(symbol) {
  adjusted = getSymbols(symbol, from = start, to = until, auto.assign = FALSE)[, 6]
  names(adjusted) = symbol
  adjusted
})

# Merge by date
#
stocks = do.call(merge.xts, stocks)

# Compound time series plot.
#
as.data.frame(stocks) %>%
  rownames_to_column("date") %>%
  mutate(date = as.Date(date)) %>%
  gather(symbol, close, -date) %>%
  ggplot(aes(x = date, y = close)) +
  geom_line(aes(group = symbol)) +
  facet_grid(symbol ~ ., scales = "free_y") +
  scale_y_continuous("Adjusted Closing Price") +
  scale_x_date("", date_breaks = "3 months", date_labels = "%b %Y") +
  theme_classic() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

# Convert from xts object to a matrix (since xts not supported as input for TSclust)
# Also need to transpose because diss() expects data to be along rows.
#
stocks = t(as.matrix(stocks))

D1 <- diss(stocks, "COR")
summary(D1)

# Create dissimilarity plot.
#
as.matrix(D1) %>%
  as.data.frame() %>%
  rownames_to_column("row") %>%
  gather(col, dissimilarity, -row) %>%
  ggplot(aes(x = col, y = row)) +
  geom_tile(aes(fill = dissimilarity)) +
  scale_fill_gradient("", low = "#ffffff", high = "#2980b9") +
  labs(x = "", y = "") +
  coord_fixed()

sort(rowMeans(as.matrix(D1)))

C1 <- hclust(D1)

D2 <- diss(stocks, "FRECHET")

D3 <- diss(stocks, "DTWARP")

D4 <- diss(stocks, "INT.PER")

