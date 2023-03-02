from scipy.stats import binomtest

p = 0.6
n = 300
x = 165
alternative = "less"

print(binomtest(x, p=p, n=n, alternative=alternative))
