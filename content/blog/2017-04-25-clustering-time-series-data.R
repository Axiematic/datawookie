library(quantmod)
symbols = c('A', 'AAPL', 'ADBE', 'AMD', 'AMZN', 'BA', 'CL', 'CSCO', 'EXPE', 'FB', 'GOOGL',
            'GRMN', 'IBM', 'INTC', 'LMT', 'MSFT', 'NFLX', 'ORCL', 'RHT', 'YHOO')

start = as.Date("2014-01-01")
until = as.Date("2014-12-31")

# Grab data, selecting only the Adjusted close price.
#
stocks = lapply(symbols, function(symbol) {
  adjusted = getSymbols(symbol, from = start, to = until, auto.assign = FALSE)[, 6]
  names(adjusted) = symbol
  adjusted
})

# Merge by date
#
stocks = do.call(merge.xts, stocks)

# Convert from xts object to a matrix (since xts not supported as input for TSclust)
# Also need to transpose because diss() expects data to be along rows.
#
stocks = t(as.matrix(stocks))

library(TSclust)

D1 <- diss(stocks, "COR")
summary(D1)

sort(rowMeans(as.matrix(D1)))

C1 <- hclust(D1)

D2 <- diss(stocks, "FRECHET")

D3 <- diss(stocks, "DTWARP")

D4 <- diss(stocks, "INT.PER")

