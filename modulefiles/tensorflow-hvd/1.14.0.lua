local condaEnv = 'tensorflow-hvd-1.14.0'

help([[
         Tensorflow deep learning library for Python with Horovod support.
]])

local condaRoot = '/appl/soft/ai/miniconda3'
local envRoot = pathJoin(condaRoot, 'envs', condaEnv)
local libPath = 'lib/python3.7'

-- MPI
-- local mpiRoot = '/appl/spack/install-tree/gcc-8.3.0/hpcx-mpi-2.4.0-rdpcfp/'
local mpiRoot = '/appl/spack/install-tree/gcc-8.3.0/hpcx-mpi-2.4.0-7gyvq3/'
prepend_path('PATH', pathJoin(mpiRoot, 'bin'))
prepend_path('LD_LIBRARY_PATH', pathJoin(mpiRoot, 'lib'))

-- conda env
prepend_path('PATH', pathJoin(condaRoot, 'condabin'))
prepend_path('PATH', pathJoin(envRoot, 'bin'))
prepend_path('PYTHONPATH', pathJoin(libPath))
prepend_path('PYTHONPATH', pathJoin(libPath, 'lib-dynload'))
prepend_path('PYTHONPATH', pathJoin(libPath, 'site-packages'))
