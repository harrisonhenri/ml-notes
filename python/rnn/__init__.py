import numpy as np
from tensorflow import keras
import tensorflow as tf

from rnn.dataset import generate_dataset

# Data
n_steps = 50
data = generate_dataset(10000, n_steps + 1)
X_train, y_train = data[:7000, :n_steps], data[:7000, -1]
X_valid, y_valid = data[7000:9000, :n_steps], data[7000:9000, -1]
X_test, y_test = data[9000:, :n_steps], data[9000:, -1]

# Deep RNN
np.random.seed(42)
tf.random.set_seed(42)

model = keras.models.Sequential(
    [
        keras.layers.SimpleRNN(20, return_sequences=True, input_shape=[None, 1]),
        keras.layers.SimpleRNN(20, return_sequences=True),
        keras.layers.SimpleRNN(1),
    ]
)

model.compile(loss="mse", optimizer="adam")
history = model.fit(X_train, y_train, epochs=20, validation_data=(X_valid, y_valid))
