# Part III : CNN Training
import keras
from keras.callbacks import TensorBoard
from keras import optimizers
from keras.preprocessing.image import ImageDataGenerator
import os
import modelsCNNVGG
import numpy as np
from keras.datasets import cifar10

VGG_WEIGHTS_PATH = './vgg16.h5'
CNN_WEIGHTS_PATH = './simple_cnn.h5'
NUM_CLASSES = 10
IMG_SHAPE = (32, 32, 3)

LOG_DIR = './log'
if not os.path.exists(LOG_DIR):
    os.mkdir(LOG_DIR)


MNIST_FILE = './mnist.npz'

def clear_log(log_dir = LOG_DIR):
    import shutil
    import os
    shutil.rmtree(log_dir)
    os.mkdir(log_dir)

clear_log()


((x_train, y_train), (x_valid, y_valid)) = cifar10.load_data()
y_train = keras.utils.to_categorical(y_train, NUM_CLASSES)
y_valid = keras.utils.to_categorical(y_valid, NUM_CLASSES)

model=modelsCNNVGG.vgg16(IMG_SHAPE, NUM_CLASSES, dropout=1.0)
#learning rate
optimizer=optimizers.Adam(lr=1e-4, decay=1e-6)
model.compile(loss='categorical_crossentropy', optimizer=optimizer, metrics=['accuracy'])
callback = TensorBoard(log_dir=LOG_DIR, histogram_freq = 1, write_grads=True)

model.summary()

model.fit(
    x_train,
    y_train,
    # batch_size
    batch_size=256,
    # epochs
    epochs=13,
    validation_data=(x_valid, y_valid),
    shuffle=True,
    callbacks=[callback])

model.save(model.name + '.h5')
