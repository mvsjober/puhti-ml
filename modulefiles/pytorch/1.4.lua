local condaEnv = 'pytorch-1.4.0'

help([[
PyTorch machine learning library for Python

For more help see: https://docs.csc.fi/apps/pytorch/]])

family("python_ml_env")

depends_on("gcc/7.4.0")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PATH', '/appl/soft/ai/bin')

setenv('CONDA_DEFAULT_ENV', condaEnv)
