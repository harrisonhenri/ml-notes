alternative <- c("less")
p <- 0.6
alpha <- 0.05
n <- 300
x <- 165

binom.test(
  x = x,
  n = n,
  alternative = alternative,
  p = p,
  conf.level = 1 - alpha
)
