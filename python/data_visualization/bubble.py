import plotly.express as px
from vega_datasets import data

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year", "Horsepower"]].groupby("Year").mean()

# Plotly Express
fig = px.scatter(
    mpg,
    x=mpg.index.strftime("%Y"),
    y="Miles_per_Gallon",
    size="Horsepower",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
)
fig.show()
