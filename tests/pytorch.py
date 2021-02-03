#!/usr/bin/env python3

import unittest
try:
    from packaging.version import Version as LV
except ImportError:
    from distutils.version import LooseVersion as LV
    print('WARNING: using distutils version check, not packaging!')

import os

nvidia = False  # if running within NVIDIA container
nvidia_skip = False
mod_version = os.getenv('MOD_VERSION')  # module version, if running in module
expect_horovod = False  # if we should expect horovod

if mod_version is not None:
    mv_parts = os.getenv('MOD_VERSION').split('-', 1)
    mod_version = mv_parts[0]
    mod_version_spec = '' if len(mv_parts) == 1 else mv_parts[1]
    nvidia = mod_version == 'nvidia'
    expect_horovod = 'hvd' in mod_version_spec


class TestPytorch(unittest.TestCase):
    def test_versions(self):
        if nvidia:
            print('NOTE: running NVIDIA container')

        import torch
        import torch.nn

        if mod_version:
            if mod_version == '1.0.1':
                self.assertEqual(torch.__version__, '1.0.1.post2')
            elif not nvidia:
                tv = torch.__version__
                if '+' in tv:
                    tv,_ = tv.split('+')
                self.assertEqual(LV(tv), LV(mod_version))
        if expect_horovod:
            print('Expecting Horovod...')
            import horovod
            import horovod.torch as hvd
            self.assertGreaterEqual(LV(horovod.__version__), LV("0.18.2"))

        import torchvision
        if LV(torch.__version__) >= LV("1.2"):
            self.assertGreaterEqual(LV(torchvision.__version__), LV("0.4"))
        else:
            self.assertGreaterEqual(LV(torchvision.__version__), LV("0.2"))

        if LV(torch.__version__) >= LV("1.2"):
            import torchtext
            if not nvidia_skip:
                import dask_jobqueue
        if not nvidia_skip:
            import torchaudio
            import tensorboardX
        import librosa

        if LV(torch.__version__) >= LV("1.3") and not nvidia_skip:
            import transformers
            import visdom
        elif LV(torch.__version__) >= LV("1.2"):
            import pytorch_transformers

        if LV(torch.__version__) >= LV("1.6"):
            import torch.cuda.amp
        elif LV(torch.__version__) >= LV("1.1"):
            import apex

    def test_magma(self):
        import torch
        use_cuda = torch.cuda.is_available()
        if not use_cuda:
            print("WARNING: testing magma, but no GPU found!")
        device = torch.device("cuda" if use_cuda else "cpu")

        x = torch.randn(10, 10).to(device)
        y = x.inverse()
        self.assertTrue(y[0][0].item() > -1.0)
        self.assertTrue(torch.cuda.has_magma)


    def test_cuda(self):
        import torch
        self.assertTrue(torch.cuda.is_available())

    def test_lstm(self):
        # Example from https://github.com/pytorch/examples/tree/master/time_sequence_prediction
        import torch
        import numpy as np
        import torch.nn as nn
        import torch.optim as optim

        from datetime import datetime
        begin = datetime.now()

        np.random.seed(42)
        torch.manual_seed(42)

        use_cuda = torch.cuda.is_available()
        device = torch.device("cuda" if use_cuda else "cpu")

        T = 20
        L = 500
        N = 50

        x = np.empty((N, L), 'int64')
        x[:] = np.array(range(L)) + np.random.randint(-4 * T, 4 * T, N).reshape(N, 1)
        data = np.sin(x / 1.0 / T).astype('float64')

        input = torch.from_numpy(data[3:, :-1]).to(device)
        target = torch.from_numpy(data[3:, 1:]).to(device)

        test_input = torch.from_numpy(data[:3, :-1]).to(device)
        test_target = torch.from_numpy(data[:3, 1:]).to(device)

        class Sequence(nn.Module):
            def __init__(self):
                super(Sequence, self).__init__()
                self.lstm1 = nn.LSTMCell(1, 51)
                self.lstm2 = nn.LSTMCell(51, 51)
                self.linear = nn.Linear(51, 1)

            def forward(self, input, future=0):
                outputs = []
                h_t = torch.zeros(input.size(0), 51, dtype=torch.double).to(device)
                c_t = torch.zeros(input.size(0), 51, dtype=torch.double).to(device)
                h_t2 = torch.zeros(input.size(0), 51, dtype=torch.double).to(device)
                c_t2 = torch.zeros(input.size(0), 51, dtype=torch.double).to(device)

                for i, input_t in enumerate(input.chunk(input.size(1), dim=1)):
                    h_t, c_t = self.lstm1(input_t, (h_t, c_t))
                    h_t2, c_t2 = self.lstm2(h_t, (h_t2, c_t2))
                    output = self.linear(h_t2)
                    outputs += [output]
                for i in range(future):  # if we should predict the future
                    h_t, c_t = self.lstm1(output, (h_t, c_t))
                    h_t2, c_t2 = self.lstm2(h_t, (h_t2, c_t2))
                    output = self.linear(h_t2)
                    outputs += [output]
                outputs = torch.stack(outputs, 1).squeeze(2)
                return outputs

        seq = Sequence().to(device)
        seq.double()
        criterion = nn.MSELoss()
        # use LBFGS as optimizer since we can load the whole data to train
        optimizer = optim.LBFGS(seq.parameters(), lr=0.8)

        def closure():
            optimizer.zero_grad()
            out = seq(input)
            loss = criterion(out, target)
            # print('loss:', loss.item())
            loss.backward()
            return loss

        optimizer.step(closure)
        # begin to predict, no need to track gradient here
        with torch.no_grad():
            future = 1000
            pred = seq(test_input, future=future)
            loss = criterion(pred[:, :-future], test_target)
            self.assertLessEqual(loss.item(), 0.003)

        end = datetime.now()
        secs = (end-begin).total_seconds()
        #print('SECS', secs)
        if use_cuda:
            self.assertLessEqual(secs, 20)
        else:
            self.assertLessEqual(secs, 100)

    def test_cnn(self):
        # From https://github.com/pytorch/examples/blob/master/mnist/main.py
        import torch
        import torch.nn as nn
        import torch.nn.functional as F
        import torch.optim as optim
        from torchvision import datasets, transforms

        use_cuda = torch.cuda.is_available()
        torch.manual_seed(42)
        #self.assertTrue(use_cuda)

        from datetime import datetime
        begin = datetime.now()

        class Net(nn.Module):
            def __init__(self):
                super(Net, self).__init__()
                self.conv1 = nn.Conv2d(1, 20, 5, 1)
                self.conv2 = nn.Conv2d(20, 50, 5, 1)
                self.fc1 = nn.Linear(4*4*50, 500)
                self.fc2 = nn.Linear(500, 10)

            def forward(self, x):
                x = F.relu(self.conv1(x))
                x = F.max_pool2d(x, 2, 2)
                x = F.relu(self.conv2(x))
                x = F.max_pool2d(x, 2, 2)
                x = x.view(-1, 4*4*50)
                x = F.relu(self.fc1(x))
                x = self.fc2(x)
                return F.log_softmax(x, dim=1)

        def train(model, device, train_loader, optimizer, epoch):
            model.train()
            for batch_idx, (data, target) in enumerate(train_loader):
                data, target = data.to(device), target.to(device)
                optimizer.zero_grad()
                output = model(data)
                loss = F.nll_loss(output, target)
                loss.backward()
                optimizer.step()

        def test(model, device, test_loader):
            model.eval()
            test_loss = 0
            correct = 0
            with torch.no_grad():
                for data, target in test_loader:
                    data, target = data.to(device), target.to(device)
                    output = model(data)
                    test_loss += F.nll_loss(output, target, reduction='sum').item()
                    pred = output.argmax(dim=1, keepdim=True)
                    correct += pred.eq(target.view_as(pred)).sum().item()

            test_loss /= len(test_loader.dataset)
            accuracy = correct / len(test_loader.dataset)
            self.assertLessEqual(test_loss, 0.13)
            self.assertGreaterEqual(accuracy, 0.95)

        device = torch.device("cuda" if use_cuda else "cpu")

        kwargs = {'num_workers': 1, 'pin_memory': True} if use_cuda else {}
        train_loader = torch.utils.data.DataLoader(
            datasets.MNIST('data', train=True, download=True,
                           transform=transforms.Compose([
                               transforms.ToTensor(),
                               transforms.Normalize((0.1307,), (0.3081,))
                           ])),
            batch_size=64, shuffle=True, **kwargs)
        test_loader = torch.utils.data.DataLoader(
            datasets.MNIST('data', train=False, transform=transforms.Compose([
                               transforms.ToTensor(),
                               transforms.Normalize((0.1307,), (0.3081,))
                           ])),
            batch_size=1000, shuffle=True, **kwargs)

        model = Net().to(device)
        optimizer = optim.SGD(model.parameters(), lr=0.01)

        for epoch in range(1, 2+1):
            train(model, device, train_loader, optimizer, epoch)
        test(model, device, test_loader)

        end = datetime.now()
        secs = (end-begin).total_seconds()
        self.assertLessEqual(secs, 60)

if __name__ == '__main__':
    unittest.main()
