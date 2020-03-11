local singName = 'pytorch_20.02-py3.sif'

local singRoot = '/appl/soft/ai/singularity/'

help([[
PyTorch machine learning library for Python

For more help see: https://docs.csc.fi/apps/pytorch/

NOTE: This software runs in a Singularity container. You need to
modify your batch job script to run with `singularity_wrapper`, for
example:

    srun singularity_wrapper exec python3 myprog.py <options>

For more information, see:
https://docs.csc.fi/computing/containers/run-existing/ 
]])

family("python_ml_env")

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv')

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end

