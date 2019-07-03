-- Name of the application
local Name = "tensorflow/1.13.1 environment"

needs_mpi = "openmpi/3.1.0"

help(
string.format([[
This module loads the %s,
which provides Tensorflow with horovod support.
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

load("tensorflow/1.13.1")
prepend_path('PYTHONPATH', '/wrk/kuu-ukko/appl/opt/tensorflow-hvd/1.13.1/lib/python3.6/site-packages')
prepend_path('PATH', '/wrk/kuu-ukko/appl/opt/tensorflow-hvd/1.13.1/bin')
