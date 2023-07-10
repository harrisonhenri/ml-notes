from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeRegressor

california_housing = fetch_california_housing()
X = california_housing.data
y = california_housing.target

model = AdaBoostRegressor(
    DecisionTreeRegressor(max_depth=3), n_estimators=100, learning_rate=0.5
)
model.fit(X, y)
