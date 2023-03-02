import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year", "Horsepower"]].groupby("Year").mean()

# Seaborn
sns.set(color_codes=True)
fig, axs = plt.subplots(ncols=2, figsize=(30, 7))
sns.distplot(mpg["Miles_per_Gallon"], ax=axs[0], kde=False)
sns.distplot(mpg["Miles_per_Gallon"], ax=axs[1])
plt.show()

# Plotly Express
fig = px.histogram(
    mpg, x="Miles_per_Gallon", histnorm="probability density", width=600, height=400
)
fig.show()
