library("tidyverse")

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = carat, color=cut), binwidth = 0.5)

ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = price, y=..density.., color = cut), binwidth = 500)