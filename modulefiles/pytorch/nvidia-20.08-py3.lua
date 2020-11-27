local singName = 'pytorch_20.08-py3-csc-v2.sif'
local pytorchVersion = '1.7.0a0+8deb4fe'

help(string.format([[
PyTorch machine learning library for Python

PyTorch version %s running in NVIDIA's optimized container: 
https://ngc.nvidia.com/catalog/containers/nvidia:pytorch

For more help see: https://docs.csc.fi/apps/pytorch/

NOTE: This software runs in a Singularity container. You need to
modify your batch job script to run with `singularity_wrapper`, for
example:

    srun singularity_wrapper exec python3 myprog.py <options>

For more information, see:
https://docs.csc.fi/computing/containers/run-existing/
]], pytorchVersion))

local singRoot = '/appl/soft/ai/singularity/'
local singPythonPath = '/appl/soft/ai/singularity/python-packages/'
local singNamePath = singName:gsub('%.%a+', '')

family("python_ml_env")

depends_on("gcc/7.4.0")

prepend_path('PATH', '/appl/soft/ai/bin')

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv -B ' .. singPythonPath .. ':' .. singPythonPath)
setenv('SINGULARITYENV_PYTHONPATH', pathJoin(singPythonPath, singNamePath, 'lib/python3.6/site-packages'))
setenv('SINGULARITYENV_PREPEND_PATH', pathJoin(singPythonPath, singNamePath, 'bin'))

setenv('SLURM_MPI_TYPE', 'pmix_v2')

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end

