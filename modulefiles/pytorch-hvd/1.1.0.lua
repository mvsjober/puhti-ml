-- Name of the application
local Name = "pytorch-hvd/1.1.0 environment"

needs_mpi = "openmpi/3.1.0"

help(
string.format([[
This module loads the %s,
which provides PyTorch with horovod support.
Note that this module depends on MPI version %s.
]], Name, needs_mpi)
)

if (mode() == "load") then

  LmodMessage("Loading application " .. Name .. " with needed modules")

  if (not isloaded(needs_mpi)) then
    mpi_name = os.getenv("TACC_FAMILY_MPI") or ""
    if (mpi_name ~= "") then
      LmodMessage("  Switching MPI version " .. mpi_name .. " to " ..
          needs_mpi)
      unload(mpi_name)
    end
  end

  always_load(needs_mpi)
end

load("pytorch/1.1.0")
prepend_path('PYTHONPATH', '/wrk/mvsjober/appl/opt/pytorch-hvd/1.1.0/lib/python3.6/site-packages')
prepend_path('PATH', '/wrk/mvsjober/appl/opt/pytorch-hvd/1.1.0/bin')
