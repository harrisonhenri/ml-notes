import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year", "Horsepower"]].groupby("Year").mean()

# Seaborn
palette_color = sns.color_palette("dark")
sns.scatterplot(data=mpg, x=mpg.index.strftime("%Y"), y="Miles_per_Gallon")
plt.show()
sns.jointplot(data=mpg, x=mpg.index.strftime("%Y"), y=mpg["Miles_per_Gallon"])
plt.show()
sns.pairplot(mpg[["Miles_per_Gallon", "Horsepower"]])
plt.show()

# Plotly Express
fig1 = px.scatter(
    mpg,
    x=mpg.index.strftime("%Y"),
    y="Miles_per_Gallon",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
)
fig1.show()
fig2 = px.scatter(
    mpg,
    x=mpg.index.strftime("%Y"),
    y="Miles_per_Gallon",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
    marginal_y="histogram",
    marginal_x="histogram",
)
fig2.show()

fig3 = px.scatter_matrix(
    mpg, dimensions=mpg[["Miles_per_Gallon", "Horsepower"]], width=700, height=700
)
fig3.show()
