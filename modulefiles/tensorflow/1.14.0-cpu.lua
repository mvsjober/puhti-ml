local condaEnv = 'tensorflow-cpu-1.14.0'

help([[
         Tensorflow deep learning library for Python, Intel-CPU optimized version
]])

family("python_ml_env")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PATH', pathJoin(condaRoot, 'condabin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))

setenv('CONDA_EXE', pathJoin(condaRoot, '/bin/conda'))
setenv('CONDA_DEFAULT_ENV', condaEnv)
setenv('CONDA_PREFIX', envRoot)
setenv('CONDA_SHLVL', '2')
setenv('CONDA_PREFIX_1', '/appl/soft/ai/miniconda3')
