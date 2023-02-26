import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year"]].groupby("Year").mean()

# Seaborn
palette_color = sns.color_palette("dark")
plt.pie(
    mpg["Miles_per_Gallon"],
    labels=mpg.index.strftime("%Y"),
    colors=palette_color,
    autopct="%.0f%%",
)
plt.tight_layout()
plt.show()

# Plotly Express
fig = px.pie(
    mpg,
    names=mpg.index.strftime("%Y"),
    values="Miles_per_Gallon",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
)
fig.show()
