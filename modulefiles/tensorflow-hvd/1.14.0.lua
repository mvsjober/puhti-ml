local condaEnv = 'tensorflow-hvd-1.14.0'

help([[
         Tensorflow deep learning library for Python with Horovod support.
]])

depends_on("gcc/8.3.0")
depends_on("hpcx-mpi/2.4.0")

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = pathJoin(envRoot, 'lib/python3.7')

prepend_path('PATH', pathJoin(condaRoot, 'condabin'))
prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
