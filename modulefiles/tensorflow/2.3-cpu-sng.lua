local singName = 'tensorflow-2.3.0-cpu.sif'
local tfVersion = '2.3.0'

help(
string.format([[
Helper module for using the %s singularity image. Contains TensorFlow %s.
]], singName, tfVersion)
)

local singRoot = '/appl/soft/ai/singularity/'

setenv('SING_IMAGE', pathJoin(singRoot, 'images', singName))

if (mode() == "load") then
   LmodMessage("NOTE: This module uses Singularity, see: https://docs.csc.fi/computing/containers/run-existing/")
end
