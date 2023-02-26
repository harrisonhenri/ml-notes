import numpy as np
import plotly.express as px
from matplotlib import pyplot as plt
from matplotlib.ticker import PercentFormatter
from plotly.subplots import make_subplots
from vega_datasets import data
import seaborn as sns
import plotly.graph_objects as go

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Origin"]]

# Seaborn
sns.set(color_codes=True)
sns.boxplot(mpg, x="Origin", y="Miles_per_Gallon")
plt.show()

# Plotly Express
fig = px.box(mpg, x="Origin", y="Miles_per_Gallon")
fig.show()
