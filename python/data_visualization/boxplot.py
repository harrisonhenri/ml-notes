import plotly.express as px
import seaborn as sns
from matplotlib import pyplot as plt
from vega_datasets import data

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Origin"]]

# Seaborn
sns.boxplot(mpg, x="Origin", y="Miles_per_Gallon")
plt.show()

# Plotly Express
fig = px.box(mpg, x="Origin", y="Miles_per_Gallon")
fig.show()
