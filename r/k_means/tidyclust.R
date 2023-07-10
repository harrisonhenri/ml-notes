library(tidyverse)
library(tidyclust)
library(tidyquant)
library(datasets)
library(plotly)
library(ggplot2)

data(iris)

iris_data <- iris %>% select(-Species)

kmeans_result <- kmeans(iris_data, centers = 3)

iris_clustered <- iris_data %>% mutate(cluster = as.factor(kmeans_result$cluster))

g <- iris_clustered %>%
  ggplot(aes(Sepal.Length, Petal.Length)) +
  geom_point(
    aes(fill = cluster),
    shape = 21,
    alpha = 0.3,
    size = 5
  ) +
  geom_smooth(color = "blue", se = FALSE) +
  scale_fill_tq() +
  theme_tq()

ggplotly(g)
