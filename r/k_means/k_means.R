library(cluster)
library(factoextra)
library(datasets)

data(iris)

iris_data <- iris[, -5]

kmeans_result <- kmeans(iris_data, centers = 3)

print(kmeans_result)


fviz_cluster(kmeans_result, data = iris_data)
