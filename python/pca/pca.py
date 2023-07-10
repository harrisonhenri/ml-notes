from matplotlib import pyplot as plt
from sklearn.decomposition import PCA
from mpl_toolkits.mplot3d import Axes3D

import numpy as np

from utils.arrow_3d import Arrow3D

np.random.seed(4)
m = 60
w1, w2 = 0.1, 0.3
noise = 0.1

angles = np.random.rand(m) * 3 * np.pi / 2 - 0.5
X = np.empty((m, 3))
X[:, 0] = np.cos(angles) + np.sin(angles) / 2 + noise * np.random.randn(m) / 2
X[:, 1] = np.sin(angles) * 0.7 + noise * np.random.randn(m) / 2
X[:, 2] = X[:, 0] * w1 + X[:, 1] * w2 + noise * np.random.randn(m)

# PCA
pca = PCA(n_components=2)

# Projection
X2D = pca.fit_transform(X)
print(X2D)

# PCs, Explained Ratios
print(pca.components_)

print(pca.explained_variance_ratio_)
# Plot
X3D_inv = pca.inverse_transform(X2D)


def plot_pca():
    axes = [-1.8, 1.8, -1.3, 1.3, -1.0, 1.0]

    x1s = np.linspace(axes[0], axes[1], 10)
    x2s = np.linspace(axes[2], axes[3], 10)
    x1, x2 = np.meshgrid(x1s, x2s)

    C = pca.components_
    R = C.T.dot(C)
    z = (R[0, 2] * x1 + R[1, 2] * x2) / (1 - R[2, 2])

    fig = plt.figure(figsize=(6, 3.8))
    ax = fig.add_subplot(111, projection="3d")

    X3D_above = X[X[:, 2] > X[:, 2]]
    X3D_below = X[X[:, 2] <= X[:, 2]]

    ax.plot(X3D_below[:, 0], X3D_below[:, 1], X3D_below[:, 2], "bo", alpha=0.5)

    ax.plot_surface(x1, x2, z, alpha=0.2, color="k")
    np.linalg.norm(C, axis=0)
    ax.add_artist(
        Arrow3D(
            [0, C[0, 0]],
            [0, C[0, 1]],
            [0, C[0, 2]],
            mutation_scale=15,
            lw=1,
            arrowstyle="-|>",
            color="k",
        )
    )
    ax.add_artist(
        Arrow3D(
            [0, C[1, 0]],
            [0, C[1, 1]],
            [0, C[1, 2]],
            mutation_scale=15,
            lw=1,
            arrowstyle="-|>",
            color="k",
        )
    )
    ax.plot([0], [0], [0], "k.")

    for i in range(m):
        if X[i, 2] > X3D_inv[i, 2]:
            ax.plot(
                [X[i][0], X3D_inv[i][0]],
                [X[i][1], X3D_inv[i][1]],
                [X[i][2], X3D_inv[i][2]],
                "k-",
            )
        else:
            ax.plot(
                [X[i][0], X3D_inv[i][0]],
                [X[i][1], X3D_inv[i][1]],
                [X[i][2], X3D_inv[i][2]],
                "k-",
                color="#505050",
            )

    ax.plot(X3D_inv[:, 0], X3D_inv[:, 1], X3D_inv[:, 2], "k+")
    ax.plot(X3D_inv[:, 0], X3D_inv[:, 1], X3D_inv[:, 2], "k.")
    ax.plot(X3D_above[:, 0], X3D_above[:, 1], X3D_above[:, 2], "bo")
    ax.set_xlabel("$x_1$", fontsize=18, labelpad=10)
    ax.set_ylabel("$x_2$", fontsize=18, labelpad=10)
    ax.set_zlabel("$x_3$", fontsize=18, labelpad=10)
    ax.set_xlim(axes[0:2])
    ax.set_ylim(axes[2:4])
    ax.set_zlim(axes[4:6])
    plt.show()


plot_pca()
