import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Origin"]]

# Seaborn
sns.violinplot(mpg, x="Origin", y="Miles_per_Gallon")
plt.show()

# Plotly Express
fig = px.violin(mpg, x="Origin", y="Miles_per_Gallon")
fig.show()
