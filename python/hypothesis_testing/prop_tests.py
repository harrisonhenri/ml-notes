import pandas as pd
from scipy.stats import ttest_1samp

from hypothesis_testing.sample import sample

df = pd.DataFrame({"fat": sample})
mu = 15
x = df["fat"]
alternative = "less"

print(ttest_1samp(x, popmean=mu, alternative=alternative))
