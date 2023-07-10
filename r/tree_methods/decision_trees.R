library(tidymodels)
library(tidyverse)
library(rpart.plot)

set.seed(1234)
data("Boston", package = "MASS")

Boston <- as_tibble(Boston)

model <- decision_tree(mode = "regression")

Boston_split <- initial_split(Boston)
Boston_train <- training(Boston_split)

data_recipe <-
  recipe(medv ~ ., data = Boston_train)

workflow <-
  workflow() %>%
  add_model(model) %>%
  add_recipe(data_recipe)

fitted <- workflow %>% 
  fit(Boston_train)

rpart.plot(fitted$fit$fit$fit, roundint = FALSE)

