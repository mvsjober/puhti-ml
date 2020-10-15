### tensorflow

#### 2.0.0

Created as:

    conda create --name tensorflow-2.0.0 --clone python-data-3.7.3-1 
    conda activate tensorflow-2.0.0
    conda install cudatoolkit==10.0.130 cudnn cupti
    pip install tensorflow-gpu==2.0.0-rc0 keras
    
Later, when 2.0.0 was released:

    conda activate tensorflow-2.0.0
    pip install --upgrade tensorflow-gpu==2.0.0

Ever later:

    conda install geopandas rasterio
    conda install -c conda-forge imbalanced-learn
    
And, to enable tensorboard.dev:

    conda activate tensorflow-2.0.0
    pip install --upgrade tensorboard==2.0.1

#### 2.0.0-hvd

TensorFlow with [horovod](https://github.com/horovod/horovod) support.

First install NCCL under `/appl/soft/ai/nccl`.

Created as:

    conda create --name tensorflow-hvd-2.0.0 --clone tensorflow-2.0.0
    conda activate tensorflow-hvd-2.0.0
    conda install gcc_linux-64 gxx_linux-64

Activate MPI:

    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0

Install horovod with `pip`:

    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.0_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

If you need to redo it, just uninstall first: `pip uninstall horovod`.

In the slurm script on puhti you should no longer use `mpirun` but just `srun` directly, for example:

    export NCCL_DEBUG=INFO  # prints some useful NCCL debug info
    srun python3 my_horovod_script.py


#### 1.15-hvd

First install NCCL under `/appl/soft/ai/nccl`.

Created as:

    conda create --name tensorflow-hvd-1.15.0 --clone python-data-3.7.3-1
    conda activate tensorflow-hvd-1.15.0
    conda install tensorflow-gpu==1.15.0 keras  # still needs to be the "-gpu" version
    conda install cudatoolkit==10.0.130 cudnn cupti
    conda install gcc_linux-64 gxx_linux-64
    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0
    
Install horovod with `pip`:
    
    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.0_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

#### 1.14.0

Created as:

    conda create --name tensorflow-1.14.0 --clone python-data-3.7.3-1   
    conda activate tensorflow-1.14.0
    conda install tensorflow-gpu==1.14.0 keras
    
#### 1.13.1

Created as:

    conda create --name tensorflow-1.13.1 --clone python-data-3.7.3-1
    conda activate tensorflow-1.13.1
    conda install tensorflow-gpu==1.13.1 keras

#### 1.13.1-hvd

First install NCCL under `/appl/soft/ai/nccl`.

Created environment:

    conda create --name tensorflow-hvd-1.13.1 --clone tensorflow-1.13.1
    conda activate tensorflow-hvd-1.13.1
    conda install gcc_linux-64 gxx_linux-64
    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0

Install horovod with `pip`:

    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.0_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

If you need to redo it, just uninstall first: `pip uninstall horovod`.

In the slurm script on puhti you should no longer use `mpirun` but just `srun` directly, for example:

    export NCCL_DEBUG=INFO  # prints some useful NCCL debug info
    srun python3 my_horovod_script.py
