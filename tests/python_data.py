#!/usr/bin/env python3

import unittest
from distutils.version import LooseVersion as LV


class TestPythonData(unittest.TestCase):

    def test_versions(self):
        import numpy
        assert(LV(numpy.__version__) >= LV("1.16"))

        import sklearn
        assert(LV(sklearn.__version__) >= LV("0.21"))

        import matplotlib
        assert(LV(matplotlib.__version__) >= LV("3.1"))

        import pandas
        assert(LV(pandas.__version__) >= LV("0.24"))

    def test_sklearn_classification(self):
        from sklearn import datasets, neighbors, linear_model

        digits = datasets.load_digits()
        X_digits = digits.data / digits.data.max()
        y_digits = digits.target

        n_samples = len(X_digits)

        X_train = X_digits[:int(.9 * n_samples)]
        y_train = y_digits[:int(.9 * n_samples)]
        X_test = X_digits[int(.9 * n_samples):]
        y_test = y_digits[int(.9 * n_samples):]

        knn = neighbors.KNeighborsClassifier()
        logistic = linear_model.LogisticRegression(solver='lbfgs', max_iter=1000,
                                                   multi_class='multinomial')

        knn_score = knn.fit(X_train, y_train).score(X_test, y_test)
        lr_score = logistic.fit(X_train, y_train).score(X_test, y_test)

        assert(knn_score >= 0.95 and knn_score <= 0.97)
        assert(lr_score >= 0.92 and lr_score <= 0.94)


if __name__ == '__main__':
    unittest.main()
