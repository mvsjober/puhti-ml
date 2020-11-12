local singName = 'nvidia-rapidsai_0.15-cuda11.0-runtime-centos7.sif'

help([[
Collection of libraries for data science and analytics on GPUs

For more help see: https://docs.csc.fi/apps/rapids/

NOTE: This software runs in a Singularity container. You need to
modify your batch job script to run with `singularity_wrapper`, for
example:

    srun singularity_wrapper exec python3 myprog.py <options>

For more information, see:
https://docs.csc.fi/computing/containers/run-existing/
]])

local singRoot = '/appl/soft/ai/singularity/'
local singPythonPath = '/appl/soft/ai/singularity/python-packages/'
local singNamePath = singName:gsub('%.%a+', '')

family("python_ml_env")

depends_on("gcc/7.4.0")

prepend_path('PATH', '/appl/soft/ai/bin')

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv -B ' .. singPythonPath .. ':' .. singPythonPath)
setenv('SINGULARITYENV_PYTHONPATH', pathJoin(singPythonPath, singNamePath, 'lib/python3.6/site-packages'))
setenv('SINGULARITYENV_PREPEND_PATH', '/opt/conda/envs/rapids/bin/:' .. pathJoin(singPythonPath, singNamePath, 'bin'))

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end

