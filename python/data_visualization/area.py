import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year"]].groupby("Year").mean()

# Seaborn
sns.set_theme()
plt.stackplot(mpg.index.strftime("%Y"), mpg["Miles_per_Gallon"])
plt.show()

# Plotly Express
fig = px.area(
    mpg,
    x=mpg.index.strftime("%Y"),
    y="Miles_per_Gallon",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
)
fig.show()
