library(tidyverse)
library(factoextra)

set.seed(123)
n <- 100
p <- 4
synthetic_data <- matrix(rnorm(n * p), nrow = n, ncol = p)

data <- as_tibble(synthetic_data)

pca_result <- prcomp(data, scale. = TRUE)

principal_components <- get_pca_var(pca_result)$coord

variance_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)

fviz_eig(pca_result)

