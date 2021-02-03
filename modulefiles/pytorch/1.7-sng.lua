local singName = 'pytorch_1.7.1_csc_py38.sif'
local pytorchVersion = '1.7.1'

help(string.format([[
PyTorch machine learning library for Python

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
prepend_path('PATH', '/appl/soft/ai/singularity/bin')

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv -B ' .. singPythonPath .. ':' .. singPythonPath)
setenv('SINGULARITYENV_PYTHONPATH', pathJoin(singPythonPath, singNamePath, 'lib/python3.8/site-packages'))
setenv('SINGULARITYENV_PREPEND_PATH', pathJoin(singPythonPath, singNamePath, 'bin'))

setenv('SLURM_MPI_TYPE', 'pmix_v2')

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, the following commands will automatically execute inside the container: " .. capture("ls -C /appl/soft/ai/singularity/bin"))
end

