#!/usr/bin/env python3

import numpy as np
import unittest
from distutils.version import LooseVersion as LV

class TestMxnet(unittest.TestCase):

    def test_versions(self):
        import mxnet as mx
        self.assertEqual(LV(mx.__version__), LV("1.5.0"))

    def test_simple(self):
        import mxnet as mx
        a = mx.nd.ones((2, 3), mx.gpu())
        b = a * 2 + 1
        bn = b.asnumpy()
        self.assertEqual(bn.shape, (2, 3))
        self.assertTrue(np.all(bn == 3))

if __name__ == '__main__':
    unittest.main()
