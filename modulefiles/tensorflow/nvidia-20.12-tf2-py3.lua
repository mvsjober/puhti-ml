local singName = 'tensorflow_20.12-tf2-py3.sif'
local tfVersion = '2.3.1'

help(string.format([[
Tensorflow deep learning library for Python

TensorFlow version %s running in NVIDIA's optimized container: 
https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow

For more help see: https://docs.csc.fi/apps/tensorflow/

NOTE: This software runs in a Singularity container. You need to
modify your batch job script to run with `singularity_wrapper`, for
example:

    srun singularity_wrapper exec python3 myprog.py <options>

For more information, see:
https://docs.csc.fi/computing/containers/run-existing/
]], tfVersion))

local singRoot = '/appl/soft/ai/singularity/'
local singPythonPath = '/appl/soft/ai/singularity/python-packages/'
local singNamePath = singName:gsub('%.%a+', '')

family("python_ml_env")

prepend_path('PATH', '/appl/soft/ai/bin')

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv -B ' .. singPythonPath .. ':' .. singPythonPath)
setenv('SINGULARITYENV_PYTHONPATH', pathJoin(singPythonPath, singNamePath, 'lib/python3.8/site-packages'))
setenv('SINGULARITYENV_PREPEND_PATH', pathJoin(singPythonPath, singNamePath, 'bin'))

setenv('SLURM_MPI_TYPE', 'pmix_v2')

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end

