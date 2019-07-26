# Installation instructions for Puhti ML environment

Installation is currently based on the miniconda3 distribution, installed in `/appl/soft/ai/miniconda3`.  Users need not concern themselves with conda, software is taken into use with the normal module system.

In general we have one conda environment per Lmod module.  Conda enviroments are supposed to be complete environments on their own and cannot be used in a hierarchical fashion, hence modules like `pytorch` do not depend on `python-data` (which has the basic ML stuff), but is instead created by first cloning `python-data` and then adding stuff to that.  At that point the basic ML stuff is copied to `pytorch`, and later additions to `python-data` will not automatically come to `pytorch`.  Instead of copying conda will actually hardlink most files, so this does not cause a huge explosion in actual files size.

(For now you can activate several at once with Lmod, but we might have to disable that in the future (by adding `reject` commands in the modulefile), as conda environments are not supposed to be use together.)

Conda environments cannot have "/" in their name so conda environment `pytorch-1.1.0` corresponds to the Lmod module `pytorch/1.1.0`.

First:

    newgrp p_installation_ai
    umask 0002

Activate the miniconda environment:

    eval "$(/appl/soft/ai/miniconda3/bin/conda shell.bash hook)"

## Useful commands

List current environments:

    conda info --envs

Remove environment if you mess something up:

    conda env remove --name foo-1.2.3
    
## Current conda environments and modules

### python-data

Includes common machine learning and data analytics packages for Python such as [SciPy](https://www.scipy.org/), [NumPy](http://www.numpy.org/), [pandas](https://pandas.pydata.org/) and [scikit-learn](https://scikit-learn.org/stable/).

Version numbering is `x.y.z-n`, where `x.y.z` is the Python version included, and `n` starts from 1.

Created as:

    env create -f python-data/3.7.3-1.yaml

### pytorch

Includes [PyTorch](https://pytorch.org/) and related packages.

Version numbering is based on the PyTorch version.

Created as:

    conda create --name pytorch-1.1.0 --clone python-data-3.7.3-1

    conda activate pytorch-1.1.0
    conda install pytorch==1.1.0 torchvision==0.2.2 cudatoolkit -c pytorch
    conda install tensorboardx -c conda-forge

### tensorflow

Includes [Tensorflow](https://www.tensorflow.org/) and related packages.

Version numbering is based on the Tensorflow version.

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

### tensorflow-hvd

Tensorflow with [horovod](https://github.com/horovod/horovod) support.

First install NCCL under `/appl/soft/ai/nccl`.

Created environment:

    conda create --name tensorflow-hvd-1.14.0 --clone tensorflow-1.14.0

    conda activate tensorflow-hvd-1.14.0
    conda install gcc_linux-64 gxx_linux-64
    
Activate MPI:

    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0

Install horovod with `pip`:

    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.1_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

If you need to redo it, just uninstall first: `pip uninstall horovod`.

In the slurm script on puhti you should no longer use `mpirun` but just `srun` directly, for example:

    export NCCL_DEBUG=INFO  # prints some useful NCCL debug info
    srun -n 2 python3 my_horovod_script.py


### pytorch-hvd

PyTorch with [horovod](https://github.com/horovod/horovod) support.

    conda create --name pytorch-hvd-1.1.0 --clone pytorch-1.1.0

    conda activate pytorch-hvd-1.1.0
    conda install gcc_linux-64 gxx_linux-64

Activate MPI:

    ml gcc/8.3.0
    ml hpcx-mpi/2.4.0

Install horovod with `pip`:

    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.7-1+cuda10.1_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

If you need to redo it, just uninstall first: `pip uninstall horovod`.  See also slurm script example above in the `tensorflow-hvd` section.


## Module files

The module files are for the [Lmod module system](https://lmod.readthedocs.io/en/latest/index.html), and the [format is documented](https://lmod.readthedocs.io/en/latest/015_writing_modules.html) on the Lmod web site.

Currently we simply set the PATH and PYTHONPATH enviroment variables to point to that conda environment.

Should be copied to `/appl/modulefiles/`, e.g., `/appl/modulefiles/tensorflow/1.14.0.lua`, should be writable by group `p_installation`.

## Testing

There are also some tests that you can run with:

    ./run-tests-gpu.sh

Note: this will run using slurm on the `gpu` partition.  Also for now the compute nodes don't have Internet access so you need to first run it on the login node to download all the models and data (`./run-tests.sh`).


## TODO

- Test what happens if user tries to use conda to create own environments

- Test and benchmark things...

- Document things to docs.csc.fi
