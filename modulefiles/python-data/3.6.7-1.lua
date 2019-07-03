-- Name of the application
local Name = "python-data/3.6.7-1 environment"

-- These two variables tell which compiler and MPI libraries
-- are needed
needs_compiler = "gcc/6.2.0"
-- needs_mpi = "openmpi/3.1.0"

-- Also the mkl is needed
needs_mkl = "mkl/17.0.1"

help(
string.format([[
This module loads the %s,
including a collection of popular data analytics and machine
learning packages (e.g., Sci-kit learn etc.).
]], Name, needs_compiler) --, needs_mpi)
)

  -- Note that the machine learning packages in this module
  -- are updated periodically.

  -- Note that this module depends on compiler %s and
  --    MPI version %s.

if (mode() == "load") then

  LmodMessage("Loading application " .. Name .. " with needed modules")

  if (not isloaded(needs_compiler)) then
    -- Determine the loaded compiler
    compiler_name = os.getenv("TACC_FAMILY_COMPILER") or ""
    if (compiler_name ~= "") then
      LmodMessage("  Switching compiler " .. compiler_name .. " to " .. 
        needs_compiler)
      unload(compiler_name)
    end
  end

  always_load(needs_compiler)

--   if (not isloaded(needs_mpi)) then
--     mpi_name = os.getenv("TACC_FAMILY_MPI") or ""
--     if (mpi_name ~= "") then
--       LmodMessage("  Switching MPI version " .. mpi_name .. " to " ..
--           needs_mpi)
--       unload(mpi_name)
--     end
--   end

--   always_load(needs_mpi)

  if (not isloaded(needs_mkl)) then
     load(needs_mkl)
  end


end

load("python/serial-3.6.7")
prepend_path('PYTHONPATH', '/wrk/kuu-ukko/appl/opt/python-data-3.6.7/lib/python3.6/site-packages')
prepend_path('PYTHONPATH', '/appl/vis/opencv/3.4.6-GPU-py36/lib/python3.6/site-packages/cv2/python-3.6')
prepend_path('PATH', '/wrk/kuu-ukko/appl/opt/python-data-3.6.7/bin')
prepend_path("LD_LIBRARY_PATH","/appl/vis/opencv/3.4.6-GPU-py36/lib64")
prepend_path("LD_LIBRARY_PATH","/appl/vis/ffmpeg/2.3.3/lib")
prepend_path("PKG_CONFIG_PATH","/appl/vis/opencv/3.4.6-GPU-py36/lib64/pkgconfig")
