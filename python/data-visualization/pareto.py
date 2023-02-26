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
mpg = (
    df[["Miles_per_Gallon", "Year", "Horsepower"]]
    .groupby("Year")
    .mean()
    .sort_values(by="Miles_per_Gallon", ascending=False)
)

# Seaborn
sns.set(color_codes=True)
fig, ax1 = plt.subplots()
ax1.bar(np.arange(mpg["Miles_per_Gallon"].size), mpg["Miles_per_Gallon"])
ax2 = ax1.twinx()
ax2.plot(
    np.arange(mpg["Miles_per_Gallon"].size),
    np.cumsum(mpg["Miles_per_Gallon"]) / np.sum(mpg["Miles_per_Gallon"]) * 100,
    marker="D",
)
ax2.yaxis.set_major_formatter(PercentFormatter())
plt.show()

# Plotly Express
trace_0 = go.Bar(
    x=mpg.index.strftime("%Y"),
    y=mpg["Miles_per_Gallon"],
    marker=dict(color=mpg["Miles_per_Gallon"], coloraxis="coloraxis"),
)
trace_1 = go.Scatter(
    x=mpg.index.strftime("%Y"),
    y=np.cumsum(mpg["Miles_per_Gallon"]) / np.sum(mpg["Miles_per_Gallon"]) * 100,
    mode="markers+lines",
)
fig = go.Figure()
fig.add_trace(trace_0)
fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(trace_0)
fig.add_trace(trace_1, secondary_y=True)
fig.update_layout(
    title="Average MPG in Cars [1970-1982]",
    yaxis={"title": "Average Miles per Gallon (mpg)"},
    showlegend=False,
    coloraxis_showscale=False,
)
fig.show()
