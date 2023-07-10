import numpy as np
from sklearn.datasets import fetch_openml
from sklearn.decomposition import PCA
from sklearn.model_selection import train_test_split

mnist = fetch_openml("mnist_784", version=1, as_frame=False)
mnist.target = mnist.target.astype(np.uint8)

X = mnist["data"]
y = mnist["target"]

X_train, X_test, y_train, y_test = train_test_split(X, y)

# PCA
pca = PCA()
pca.fit(X_train)

# Optimal number of dimensions
cumsum = np.cumsum(pca.explained_variance_ratio_)
print(np.argmax(cumsum >= 0.95) + 1)
