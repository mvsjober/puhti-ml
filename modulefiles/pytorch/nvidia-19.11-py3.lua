local singName = 'pytorch_19.11-py3.sif'
local pytorchVersion = '1.4.0a0+649135b'

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
family("python_ml_env")

prepend_path('PATH', '/appl/soft/ai/bin')

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))
setenv('SING_FLAGS', '--nv')

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end

