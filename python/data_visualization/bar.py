import numpy as np
import plotly.express as px
from matplotlib import pyplot as plt
from vega_datasets import data
import seaborn as sns

# from IPython.display import set_matplotlib_formats
# set_matplotlib_formats('retina', quality=100)

# Dataset
df = data.cars()
df.head()
mpg = df[["Miles_per_Gallon", "Year"]].groupby("Year").mean()

# Matplotlib
fig, ax = plt.subplots()

bars = ax.bar(
    x=np.arange(mpg.size),
    height=mpg["Miles_per_Gallon"],
    tick_label=mpg.index.strftime("%Y"),
)

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_color("#DDDDDD")
ax.tick_params(bottom=False, left=False)
ax.set_axisbelow(True)
ax.yaxis.grid(True, color="#EEEEEE")
ax.xaxis.grid(False)

bar_color = bars[0].get_facecolor()

for bar in bars:
    ax.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 0.3,
        round(bar.get_height(), 1),
        horizontalalignment="center",
        color=bar_color,
        weight="bold",
    )

ax.set_xlabel("Year of Car Release", labelpad=15, color="#333333")
ax.set_ylabel("Average Miles per Gallon (mpg)", labelpad=15, color="#333333")
ax.set_title("Average MPG in Cars [1970-1982]", pad=15, color="#333333", weight="bold")

fig.tight_layout()

# Seaborn
plt.subplots()
sns.set_style("darkgrid")
sns_barplot = sns.barplot(
    data=mpg, x=mpg.index.strftime("%Y"), y="Miles_per_Gallon", color=bar_color
)
sns_barplot.set_ylabel("Average Miles per Gallon (mpg)", labelpad=15, color="#333333")
sns_barplot.set_xlabel("Year of Car Release", labelpad=15, color="#333333")
sns_barplot.set_ylabel("Average Miles per Gallon (mpg)", labelpad=15, color="#333333")
sns_barplot.set_title(
    "Average MPG in Cars [1970-1982]", pad=15, color="#333333", weight="bold"
)
sns_barplot.spines["top"].set_visible(False)
sns_barplot.spines["right"].set_visible(False)
sns_barplot.spines["left"].set_visible(False)
sns_barplot.spines["bottom"].set_color("#DDDDDD")
sns_barplot.tick_params(bottom=False, left=False)
sns_barplot.set_axisbelow(True)
sns_barplot.yaxis.grid(True, color="#EEEEEE")
sns_barplot.xaxis.grid(False)

plt.tight_layout()
plt.show()

# Plotly Express
fig = px.bar(
    mpg,
    x=mpg.index.strftime("%Y"),
    y="Miles_per_Gallon",
    width=600,
    height=400,
    title="Average MPG in Cars [1970-1982]",
    labels={
        "Miles_per_Gallon": "Average Miles per Gallon (mpg)",
        "x": "Year of Car Release",
    },
)

fig.update_layout(
    font_family="Courier New",  # Changing Styling of the plot
    font_color="black",
    font_size=16,
    title_font_family="Times New Roman",
    title_font_color="green",
    title_font_size=26,
    title={"y": 0.9, "x": 0.5},
)

fig.show()
