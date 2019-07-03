-- Name of the application
local Name = "tensorflow/1.13.1 environment"

help(
string.format([[
This module loads the %s,
which provides Tensorflow, a popular deep learning library for Python.
]], Name)
)

if (mode() == "load") then

  LmodMessage("Loading application " .. Name .. " with needed modules")

end

load("python-data/3.6.7-1")
load("cuda/10.0")
load("cudnn/7.4.1-cuda10")
load("nccl/2.4.2-cuda10")
prepend_path('PYTHONPATH', '/wrk/mvsjober/appl/opt/tensorflow/1.13.1/lib/python3.6/site-packages')
prepend_path('PATH', '/wrk/mvsjober/appl/opt/tensorflow/1.13.1/bin')
