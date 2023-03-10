library(BSDA)

data <- data.frame(
  fat = c(
    19.8, 23.4, 13.6, 6.6, 13.7, 5.2, 14.3, 13.3, 12.2, 14.3, 8.5, 15.8, 16.0,
    18.3, 28.7, 11.6, 16.4, 14.4, 26.2, 17.0, 6.5, 10.0, 24.5, 34.9, 19.1, 6.9,
    19.5, 11.0, 8.9, 10.6, 9.5, 14.0, 6.0, 18.0, 10.8, 16.7, 18.4, 10.1, 12.3,
    6.5, 25.4, 15.3, 12.1, 13.1, 7.7, 17.4, 10.7, 24.1, 14.0, 21.4
  )
)

alternative <- c("two.sided")
mu <- 15
alpha <- 0.05
sigma <- sd(data$fat)
x <- data$fat

z.test(
  x = x, y = NULL,
  alternative = alternative,
  mu = mu,
  sigma.x = sigma,
  conf.level = 1 - alpha
)
