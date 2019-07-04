#!/usr/bin/env python3

import unittest
from distutils.version import LooseVersion as LV


class TestPytorchHorovod(unittest.TestCase):

    def test_versions(self):
        import horovod
        self.assertEqual(LV(horovod.__version__), LV("0.16.1"))

    def test_horovod(self):
        import horovod.torch as hvd
        self.assertEqual(hvd.init(), 1)
        self.assertEqual(hvd.rank(), 0)
        print('\nNOTE: remember to also test horovod with a real script, for example')
        print('https://github.com/CSCfi/machine-learning-scripts/blob/master/examples/pytorch_dvc_cnn_simple_hvd.py')


if __name__ == '__main__':
    unittest.main()
