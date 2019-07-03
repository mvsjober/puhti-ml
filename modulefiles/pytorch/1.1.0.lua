-- Name of the application
local Name = "pytorch/1.1.0 environment"

help(
string.format([[
This module loads the %s,
which provides PyTorch, a popular machine learning library for Python.
]], Name)
)

if (mode() == "load") then
  LmodMessage("Loading application " .. Name .. " with needed modules")
end

load("python-data/3.6.7-1")
load("cuda/10.0")
load("cudnn/7.4.1-cuda10")
load("nccl/2.4.2-cuda10")
prepend_path('PYTHONPATH', '/wrk/kuu-ukko/appl/opt/pytorch/1.1.0/lib/python3.6/site-packages')
prepend_path('PATH', '/wrk/kuu-ukko/appl/opt/pytorch/1.1.0/bin')
