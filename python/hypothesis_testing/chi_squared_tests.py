from scipy.stats import chisquare

ddof = 2
f_obs = [35, 24, 27, 32, 25, 36, 31]
f_exp = [30, 30, 30, 30, 30, 30, 30]

print(chisquare(f_obs=f_obs, f_exp=f_exp, ddof=ddof))
