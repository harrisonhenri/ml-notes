import numpy as np
from scipy.stats import shapiro

from hypothesis_testing.sample import production

rng = np.random.default_rng()


print(shapiro(production))

