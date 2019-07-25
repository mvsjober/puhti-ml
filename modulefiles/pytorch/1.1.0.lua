local condaEnv = 'pytorch-1.1.0'

help([[
         PyTorch machine learning library for Python
]])

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = 'lib/python3.7'

prepend_path('PATH', pathJoin(condaRoot, 'bin'))
-- prepend_path('PATH', pathJoin(condaRoot, '/condabin'))
-- setenv('CONDA_EXE', pathJoin(condaRoot, '/bin/conda'))
-- setenv('CONDA_DEFAULT_ENV', condaEnv)
-- setenv('CONDA_PREFIX', envRoot)
-- setenv('CONDA_SHLVL', '2')
-- setenv('CONDA_PREFIX_1', '/appl/soft/ai/miniconda3')

prepend_path('PYTHONPATH', pathJoin(envRoot, libPath))
prepend_path('PYTHONPATH', pathJoin(envRoot, libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(envRoot, libPath, 'site-packages'))
