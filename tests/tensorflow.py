#!/usr/bin/env python3

import unittest
from distutils.version import LooseVersion as LV

import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'
mod_version = os.getenv('MOD_VERSION')

is_tf2 = LV(mod_version) >= LV("2.0")


class TestTensorflow(unittest.TestCase):

    def test_versions(self):
        import tensorflow as tf
        self.assertEqual(LV(tf.__version__), LV(mod_version))

        import keras
        self.assertGreaterEqual(LV(keras.__version__), LV("2.0"))

        if is_tf2:
            self.assertGreaterEqual(LV(keras.__version__), LV("2.2.4"))

    def test_keras_backend(self):
        from keras import backend as K
        self.assertEqual(K.backend(), "tensorflow")

    def test_cuda(self):
        import tensorflow as tf
        self.assertTrue(tf.test.is_gpu_available(cuda_only=True))

    def test_add(self):
        import tensorflow as tf
        if is_tf2:
            a = tf.constant(10)
            b = tf.constant(32)
            c = a + b
        else:
            sess = tf.Session()

            a = tf.constant(10)
            b = tf.constant(32)
            c = sess.run(a + b)

        self.assertEqual(c, 42)

    def test_keras_cnn(self):
        if is_tf2:
            import tensorflow as tf
            from tensorflow.keras.datasets import mnist
            from tensorflow.keras.models import Sequential
            from tensorflow.keras.layers import Dense, Dropout, Flatten
            from tensorflow.keras.layers import Conv2D, MaxPooling2D
            from tensorflow.keras import backend as K
            from tensorflow.keras.utils import to_categorical
        else:
            import keras
            from keras.datasets import mnist
            from keras.models import Sequential
            from keras.layers import Dense, Dropout, Flatten
            from keras.layers import Conv2D, MaxPooling2D
            from keras import backend as K
            from keras.utils import to_categorical

        from tensorflow.python.util import deprecation
        deprecation._PRINT_DEPRECATION_WARNINGS = False

        from datetime import datetime
        begin = datetime.now()

        batch_size = 128
        num_classes = 10
        epochs = 5

        # input image dimensions
        img_rows, img_cols = 28, 28

        # the data, shuffled and split between train and test sets
        (x_train, y_train), (x_test, y_test) = mnist.load_data()

        if K.image_data_format() == 'channels_first':
            x_train = x_train.reshape(x_train.shape[0], 1, img_rows, img_cols)
            x_test = x_test.reshape(x_test.shape[0], 1, img_rows, img_cols)
            input_shape = (1, img_rows, img_cols)
        else:
            x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
            x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
            input_shape = (img_rows, img_cols, 1)

        x_train = x_train.astype('float32')
        x_test = x_test.astype('float32')
        x_train /= 255
        x_test /= 255

        # convert class vectors to binary class matrices
        y_train = to_categorical(y_train, num_classes)
        y_test = to_categorical(y_test, num_classes)

        model = Sequential()
        model.add(Conv2D(32, kernel_size=(3, 3),
                         activation='relu',
                         input_shape=input_shape))
        model.add(Conv2D(64, (3, 3), activation='relu'))
        model.add(MaxPooling2D(pool_size=(2, 2)))
        model.add(Dropout(0.25))
        model.add(Flatten())
        model.add(Dense(128, activation='relu'))
        model.add(Dropout(0.5))
        model.add(Dense(num_classes, activation='softmax'))

        model.compile(loss='categorical_crossentropy',
                      optimizer='adam',
                      metrics=['accuracy'])

        model.fit(x_train, y_train,
                  batch_size=batch_size,
                  epochs=epochs,
                  verbose=0,
                  validation_data=(x_test, y_test))
        score = model.evaluate(x_test, y_test, verbose=0)
        print('Test loss:', score[0])
        print('Test accuracy:', score[1])

        self.assertLessEqual(score[0], 0.06)
        self.assertGreaterEqual(score[1], 0.97)

        end = datetime.now()
        secs = (end-begin).total_seconds()
        print('Took {} seconds'.format(secs))
        self.assertLessEqual(secs, 80)


if __name__ == '__main__':
    unittest.main()
