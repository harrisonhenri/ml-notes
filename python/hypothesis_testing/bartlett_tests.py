import pandas as pd
from scipy.stats import bartlett

from hypothesis_testing.sample import stores

df = pd.DataFrame(stores)

print(bartlett(df["store1"], df["store2"], df["store3"]))
