local condaEnv = 'pytorch-1.3.0-1'

help([[
PyTorch machine learning library for Python

For more help see: https://docs.csc.fi/apps/pytorch/]])

family("python_ml_env")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PATH', '/appl/soft/ai/bin')

setenv('CONDA_DEFAULT_ENV', condaEnv)
