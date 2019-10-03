# Installation instructions for Puhti ML environment

Installation is currently based on the miniconda3 distribution, installed in `/appl/soft/ai/miniconda3`.  Users need not concern themselves with conda, software is taken into use with the normal module system.

In general we have one conda environment per Lmod module.  Conda enviroments are supposed to be complete environments on their own and cannot be used in a hierarchical fashion, hence modules like `pytorch` do not depend on `python-data` (which has the basic ML stuff), but is instead created by first cloning `python-data` and then adding stuff to that.  At that point the basic ML stuff is copied to `pytorch`, and later additions to `python-data` will not automatically come to `pytorch`.  Instead of copying conda will actually hardlink most files, so this does not cause a huge explosion in actual files size.

Conda environments cannot have "/" in their name so conda environment `pytorch-1.1.0` corresponds to the Lmod module `pytorch/1.1.0`.

First:

    newgrp p_installation_ai
    umask 0002

Activate the miniconda environment:

    eval "$(/appl/soft/ai/miniconda3/bin/conda shell.bash hook)"

## Useful commands

List current environments:

    conda env list

List contents of the current environment:

    conda list

Remove environment if you mess something up:

    conda env remove --name foo-1.2.3
    
List all available versions of a conda package:

    conda search -f foo
    
## Current conda environments and modules

**NOTE** In the future we should try to specify as much as possible in an environment yaml file, and install as in `python-data`.  An [example file](https://github.com/CSCfi/puhti-ml/blob/master/conda-envs/pytorch/1.2.0.yaml.example) is included for pytorch-1.2.0.

**NOTE** Some additional stuff done manually after installation:

- installed pip in all envs (`conda install pip`)
- installed visdom in all PyTorch envs (`pip install --no-cache-dir visdom`)


### python-data

Includes common machine learning and data analytics packages for Python such as [SciPy](https://www.scipy.org/), [NumPy](http://www.numpy.org/), [pandas](https://pandas.pydata.org/) and [scikit-learn](https://scikit-learn.org/stable/).

Version numbering is `x.y.z-n`, where `x.y.z` is the Python version included, and `n` starts from 1.

Created as:

    conda env create -f conda-envs/python-data/3.7.3-1.yaml

### pytorch

Includes [PyTorch](https://pytorch.org/) and related packages.

Version numbering is based on the PyTorch version.

At the end of each pytorch install I have also pinned the pytorch version by adding a file `/appl/soft/ai/miniconda3/envs/pytorch-X.Y.Z/conda-meta/pinned` with content similar to:

    pytorch ==X.Y.Z
    
For more [info on pinning see the Conda docs](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning).

#### 1.2.0

Created as:

    # not sure if needed, but seems to increase changes the clone is actually hardlinking ...
    conda activate python-data-3.7.3-1

    conda create --name pytorch-1.2.0 --clone python-data-3.7.3-1

    conda activate pytorch-1.2.0
    conda install pytorch==1.2.0 cudatoolkit -c pytorch
    conda install torchvision torchtext torchaudio -c pytorch
    conda install librosa -c conda-forge
    conda install tensorboardx -c conda-forge
    
Apex installed same as below.

#### 1.1.0

Created as:

    conda create --name pytorch-1.1.0 --clone python-data-3.7.3-1

    conda activate pytorch-1.1.0
    conda install pytorch==1.1.0 torchvision==0.2.2 cudatoolkit -c pytorch
    conda install tensorboardx -c conda-forge
    conda install librosa sox -c conda-forge

Torchaudio as below.

#### 1.0.1

Created as:

    conda activate python-data-3.7.3-1

    conda create --name pytorch-1.0.1 --clone python-data-3.7.3-1

    conda activate pytorch-1.0.1
    conda install pytorch==1.0.1 cudatoolkit -c pytorch
    conda install torchvision -c pytorch
    conda install librosa sox -c conda-forge
    conda install tensorboardx -c conda-forge

Torchaudio as below.

#### torchaudio

For pytorch<=1.1.0 torchaudio cannot be installed from conda, then you need to do this:

    module load gcc/7.4.0
    export CUDA_HOME=/appl/spack/install-tree/gcc-8.3.0/cuda-10.0.130-ayjzbn
    git clone git://git.code.sf.net/p/sox/code sox
    git clone https://github.com/pytorch/audio torchaudio
    cd torchaudio
    rm -rf .git
    pip install -v --no-cache-dir --global-option=build_ext --global-option="-I/path/to/sox/src/" ./


#### apex

    module load gcc/7.4.0
    export CUDA_HOME=/appl/spack/install-tree/gcc-8.3.0/cuda-10.0.130-ayjzbn
    git clone https://github.com/NVIDIA/apex
    cd apex
    rm -rf .git
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./

### tensorflow

Includes [Tensorflow](https://www.tensorflow.org/) and related packages.

Version numbering is based on the Tensorflow version.

#### 2.0.0

Created as:

    conda create --name tensorflow-2.0.0 --clone python-data-3.7.3-1
    
    conda activate tensorflow-2.0.0
    conda install cudatoolkit==10.0.130 cudnn cupti
    pip install tensorflow-gpu==2.0.0-rc0 keras
    
Later, when 2.0.0 was released:

    conda activate tensorflow-2.0.0
    pip install --upgrade tensorflow-gpu==2.0.0

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

Tensorflow with [horovod](https://github.com/horovod/horovod) support.

First install NCCL under `/appl/soft/ai/nccl`.

Created environment:

    conda create --name tensorflow-hvd-1.13.1 --clone tensorflow-1.13.1

    conda activate tensorflow-hvd-1.13.1
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

### mxnet

Includes [MXNet](https://mxnet.apache.org/) and related packages.

Version numbering is based on the MXNet version.

Created as:

    conda create --name mxnet-1.5.0 --clone python-data-3.7.3-1

    conda activate mxnet-1.5.0
    conda install cudatoolkit cudnn mkl-dnn
    pip install mxnet-cu101mkl
    conda install tensorboardx -c conda-forge

### pytorch-hvd

*This section is work-in-progress*

PyTorch with [horovod](https://github.com/horovod/horovod) support.

    conda create --name pytorch-hvd-1.1.0 --clone pytorch-1.1.0

    conda activate pytorch-hvd-1.1.0
    conda install gcc_linux-64 gxx_linux-64

Activate MPI:

    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0  # or mpich/3.3.1

Install horovod with `pip`:

    CUDA_HOME=/usr/local/cuda-10.0/targets/x86_64-linux HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.0_x86_64 \ 
    HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

If you need to redo it, just uninstall first: `pip uninstall horovod`.  See also slurm script example above in the `tensorflow-hvd` section.


## Module files

The module files are for the [Lmod module system](https://lmod.readthedocs.io/en/latest/index.html), and the [format is documented](https://lmod.readthedocs.io/en/latest/015_writing_modules.html) on the Lmod web site.

Currently we simply set the PATH and PYTHONPATH enviroment variables to point to that conda environment.

Should be copied to `/appl/modulefiles/`, e.g., `/appl/modulefiles/tensorflow/1.14.0.lua`, should be writable by group `p_installation`.

## Testing

There are also some tests that you can run with:

    ./run-tests-gpu.sh

Note: this will run using slurm on the `gpu` partition.  Also for now the compute nodes don't have Internet access so you need to first run it on the login node to download all the models and data (`./run-tests.sh`).
