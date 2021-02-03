local condaEnv = 'tensorflow-hvd-2.4.0'

help([[
Tensorflow deep learning library for Python

For more help see: https://docs.csc.fi/apps/tensorflow/]])

family("python_ml_env")

depends_on("gcc/9.1.0")
depends_on("hpcx-mpi/2.4.0")
depends_on("cuda/11.0.2")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PATH', '/appl/soft/ai/bin')

prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath))

setenv('CONDA_DEFAULT_ENV', condaEnv)
