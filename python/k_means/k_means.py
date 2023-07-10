from sklearn.cluster import KMeans
from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split

X_digits, y_digits = load_digits(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X_digits, y_digits, random_state=42)

kmeans = KMeans(n_clusters=50, random_state=42)
kmeans.fit_transform(X_train)

print(kmeans.score(X_test, y_test))
