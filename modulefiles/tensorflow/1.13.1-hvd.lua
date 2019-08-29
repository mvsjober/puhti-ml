local condaEnv = 'tensorflow-hvd-1.13.1'
local condaList = subprocess('/appl/soft/ai/miniconda3/condabin/conda list -n ' .. condaEnv)

help([[
         Tensorflow deep learning library for Python with Horovod support.

]] .. condaList)

family("python_ml_env")

depends_on("gcc/8.3.0")
depends_on("hpcx-mpi/2.4.0")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
