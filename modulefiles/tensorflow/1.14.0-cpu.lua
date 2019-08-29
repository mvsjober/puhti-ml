local condaEnv = 'tensorflow-cpu-1.14.0'
local condaList = subprocess('/appl/soft/ai/miniconda3/condabin/conda list -n ' .. condaEnv)

help([[
         Tensorflow deep learning library for Python, Intel-CPU optimized version

]] .. condaList)

family("python_ml_env")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
