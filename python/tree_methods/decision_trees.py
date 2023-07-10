from sklearn.datasets import fetch_california_housing
from sklearn.tree import DecisionTreeRegressor, export_graphviz

california_housing = fetch_california_housing()
X = california_housing.data
y = california_housing.target

model = DecisionTreeRegressor(max_depth=3)
model.fit(X, y)

export_graphviz(
    model,
    out_file="california_decision_tree.dot",
    feature_names=california_housing.feature_names,
    class_names=california_housing.target_names,
    rounded=True,
    filled=True,
)
