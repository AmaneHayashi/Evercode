from keras.layers import Conv2D
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import Flatten
from keras.layers import Input
from keras.layers import MaxPooling2D
from keras.models import Model


def simple_cnn(input_shape, classes, weights_path=None):

    img_input = Input(shape=input_shape, name='cifar10_input')

    x = Conv2D(32, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block1_conv1')(img_input)
    x = Conv2D(32, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block1_conv2')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block1_pool')(x)

    x = Conv2D(64, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block2_conv1')(x)
    x = Conv2D(64, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block2_conv2')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block2_pool')(x)
    x = Dropout(0.25)(x)

    x = Conv2D(128, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block3_conv1')(x)
    x = Conv2D(128, (3, 3), activation='relu', padding='same',
               kernel_initializer='he_normal', name='block3_conv2')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block3_pool')(x)
    x = Dropout(0.25)(x)

    x = Flatten(name='flatten')(x)
    x = Dense(
        1024,
        activation='relu',
        kernel_initializer='he_normal',
        name='fc')(x)
    x = Dropout(0.5)(x)
    x = Dense(
        classes,
        activation='softmax',
        kernel_initializer='he_normal',
        name='prediction_cifar10')(x)

    model = Model(img_input, x, name='simple_cnn')
    if weights_path:
        model.load_weights(weights_path, by_name=False)
    return model

# VERY DEEP CONVOLUTION NETWORKS FOR LARGE-SCALE IMAGE RECOGNITION


def vgg16(
        input_shape=(
            224,
            224,
            3),
        classes=10000,
        weights_path=None,
        dropout=0.5):

    img_input = Input(shape=input_shape, name='cifar10_input')

    # Block 1
    x = Conv2D(64, (3, 3), activation='relu', padding='same',
               name='block1_conv1')(img_input)
    x = Conv2D(64, (3, 3), activation='relu',
               padding='same', name='block1_conv2')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block1_pool')(x)

    # Block 2
    x = Conv2D(128, (3, 3), activation='relu',
               padding='same', name='block2_conv1')(x)
    x = Conv2D(128, (3, 3), activation='relu',
               padding='same', name='block2_conv2')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block2_pool')(x)

    # Block 3
    x = Conv2D(256, (3, 3), activation='relu',
               padding='same', name='block3_conv1')(x)
    x = Conv2D(256, (3, 3), activation='relu',
               padding='same', name='block3_conv2')(x)
    x = Conv2D(256, (3, 3), activation='relu',
               padding='same', name='block3_conv3')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block3_pool')(x)

    # Block 4
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block4_conv1')(x)
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block4_conv2')(x)
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block4_conv3')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block4_pool')(x)

    # Block 5
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block5_conv1')(x)
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block5_conv2')(x)
    x = Conv2D(512, (3, 3), activation='relu',
               padding='same', name='block5_conv3')(x)
    x = MaxPooling2D((2, 2), strides=(2, 2), name='block5_pool')(x)

    # FC Block
    x = Flatten(name='flatten')(x)
    x = Dense(
        4096,
        activation='relu',
        kernel_initializer='he_normal',
        name='new_fc1')(x)
    x = Dropout(dropout)(x)
    x = Dense(
        4096,
        activation='relu',
        kernel_initializer='he_normal',
        name='new_fc2')(x)
    x = Dropout(dropout)(x)
    x = Dense(
        classes,
        activation='softmax',
        kernel_initializer='he_normal',
        name='prediction_cifar10')(x)

    model = Model(img_input, x, name='vgg16')
    if weights_path:
        model.load_weights(weights_path, by_name=True)
    return model
