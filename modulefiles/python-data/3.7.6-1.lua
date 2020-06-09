local condaEnv = 'python-data-3.7-2'

help([[
Collection of popular data analytics and machine learning packages for Python

For more help see: https://docs.csc.fi/apps/python-data/]])

family("python_ml_env")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PATH', '/appl/soft/ai/bin')

setenv('CONDA_DEFAULT_ENV', condaEnv)
