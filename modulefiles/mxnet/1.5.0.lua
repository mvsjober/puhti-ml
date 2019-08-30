local condaEnv = 'mxnet-1.5.0'
local condaList = '/appl/soft/ai/miniconda3/condabin/conda list -n ' .. condaEnv

help([[
         MXNet deep learning library for Python

To list the exact packages and versions included a specific module you can run:
]] .. condaList)

family("python_ml_env")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath))
