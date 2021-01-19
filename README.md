# Installation instructions for Puhti ML environment

Installation is currently based on the miniconda3 distribution, installed in `/appl/soft/ai/miniconda3`.  Users need not concern themselves with conda, software is taken into use with the normal module system.

In general we have one conda environment per Lmod module.  Conda enviroments are supposed to be complete environments on their own and cannot be used in a hierarchical fashion, hence modules like `pytorch` do not depend on `python-data` (which has the basic ML stuff).  However, at least in theory conda should be able to symlink common files to save disk space.

Conda environments cannot have "/" in their name so for example the conda environment `pytorch-1.3.0` corresponds to the Lmod module `pytorch/1.3.0`.

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

List all available versions in an alternative channel:

    conda search -c conda-forge -f foo
    
Export list of installed packages

    conda env export > my-list.yaml

Create new environment based on yaml list:

    conda env create -f my-list.yaml

## Current conda environments and modules

Ideally, every installation should be based on a single yaml file.  Later manual installations could be added to a new yaml file, e.g. `next-version.yaml`, so that every subsequent version would include also manually installed packages.

### python-data

Includes common machine learning and data analytics packages for Python such as [SciPy](https://www.scipy.org/), [NumPy](http://www.numpy.org/), [pandas](https://pandas.pydata.org/) and [scikit-learn](https://scikit-learn.org/stable/).

Version numbering is `x.y.z-n`, where `x.y.z` is the Python version included, and `n` starts from 1.

Created as:

    conda env create -f conda-envs/python-data/3.7.3-1.yaml
    
If you add more packages manually later, please also add them to the yaml file for the next installation [`conda-envs/python-data/next-version.yaml`](conda-envs/python-data/next-version.yaml).  In this way, we will remember to also add the new packages when creating the next version.


### pytorch

Includes [PyTorch](https://pytorch.org/) and related packages.

Version numbering is based on the PyTorch version.

#### 1.4 and 1.3.1

Created as:

    conda env create -f conda-envs/pytorch/X.Y.yaml

where `X.Y` is the corresponding version number.

For older PyTorch installations see [pytorch.md](pytorch.md).

#### 1.3.1-hvd

PyTorch with [horovod](https://github.com/horovod/horovod) support.

Created as:

    conda create --name pytorch-hvd-1.3.1 --clone pytorch-1.3.1-1
    conda activate pytorch-hvd-1.3.1
    conda install gcc_linux-64 gxx_linux-64
    conda install cudatoolkit-dev -c conda-forge
    
    ml purge
    ml gcc/8.3.0 hpcx-mpi/2.4.0
    
    
    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.4.8-1+cuda10.1_x86_64 \
                     HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_PYTORCH=1 \
                     HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITHOUT_MXNET=1 \
                     pip install -v --no-cache-dir horovod
    
#### 1.3.1-hvd-mpich

Same as above, but with mpich instead of hpcx-mpi:

    conda create --name pytorch-hvd-1.3.1-mpich --clone pytorch-1.3.1-1
    conda activate pytorch-hvd-1.3.1-mpich'
    conda install gcc_linux-64 gxx_linux-64
    conda install cudatoolkit-dev -c conda-forge
    
    ml purge
    ml gcc/8.3.0 mpich/3.3.1
    
    CC=$GCC HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.5.6-1+cuda10.1_x86_64 \
    CUDA_HOME=/appl/soft/ai/miniconda3/envs/pytorch-hvd-1.3.1-mpich/pkgs/cuda-toolkit/ \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_PYTORCH=1 \
    HOROVOD_WITHOUT_TENSORFLOW=1 HOROVOD_WITHOUT_MXNET=1 \
    pip install -v --no-cache-dir horovod


### tensorflow

Includes [TensorFlow](https://www.tensorflow.org/) and related packages.

Version numbering is based on the TensorFlow version.

#### 2.4-hvd

TensorFlow with [horovod](https://github.com/horovod/horovod) support,
using CUDA 11.0 and cuDNN 8.

First install NCCL under `/appl/soft/ai/nccl`.

Created as:

    conda create --name tensorflow-hvd-2.4.0 --clone python-data-3.7-2
    conda activate tensorflow-hvd-2.4.0
    conda install tensorflow-gpu==2.2.0 keras
    conda remove tensorflow tensorflow-gpu tensorflow-base # no 2.4 in conda
    pip install tensorflow-gpu==2.4.0
    pip install keras autokeras
    conda install pydot
    conda install cudatoolkit==11.0.221
    conda remove cudnn # cudatoolkit brings cudnn 6 with it
    conda install gcc_linux-64 gxx_linux-64

Install cuDNN manually from `cudnn-11.0-linux-x64-v8.0.5.39.tgz`:

    tar xvf cudnn-11.0-linux-x64-v8.0.5.39.tgz
    cd cuda/lib64/
    cp -i * /appl/soft/ai/miniconda3/envs/tensorflow-hvd-2.4.0/lib/
    cd ../include
    cp -i * /appl/soft/ai/miniconda3/envs/tensorflow-hvd-2.4.0/include/
    cd /appl/soft/ai/miniconda3/envs/tensorflow-hvd-2.4.0/lib/
    chgrp p_installation_ai *
    chgrp -h p_installation_ai *
    cd ../include
    chgrp p_installation_ai *
    chgrp -h p_installation_ai *

For some reason, this is needed:

    pip uninstall tensorflow_estimator
    pip install -U tensorflow_estimator

Activate MPI:

    ml gcc/9.1.0 cuda/11.0.2
    ml hpcx-mpi/2.4.0

Install horovod with `pip`:

    HOROVOD_NCCL_HOME=/appl/soft/ai/nccl/nccl_2.8.3-1+cuda11.0_x86_64 HOROVOD_GPU_ALLREDUCE=NCCL pip install --no-cache-dir horovod

For older TensorFlow installations see [tensorflow.md](tensorflow.md).

### mxnet

Includes [MXNet](https://mxnet.apache.org/) and related packages.

Version numbering is based on the MXNet version.

Created as:

    conda create --name mxnet-1.5.0 --clone python-data-3.7.3-1
    conda activate mxnet-1.5.0
    conda install cudatoolkit cudnn mkl-dnn
    pip install mxnet-cu101mkl
    conda install tensorboardx -c conda-forge

### rapids

Includes [Rapids](https://rapids.ai/) suite of libraries.

Version numbering is based on the Rapids version.

Created as:

    conda create --name rapids-0.11 --clone python-data-3.7.3-1
    conda activate rapids-0.11
    conda install cudatoolkit==10.0.130 cupti
    conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.11 python=3.7

## Module files

The module files are for the [Lmod module system](https://lmod.readthedocs.io/en/latest/index.html), and the [format is documented](https://lmod.readthedocs.io/en/latest/015_writing_modules.html) on the Lmod web site.

Currently we simply set the PATH and PYTHONPATH enviroment variables to point to that conda environment.

Should be copied to `/appl/modulefiles/`, e.g., `/appl/modulefiles/tensorflow/1.14.0.lua`, should be writable by group `p_installation`.

## Testing

There are also some tests that you can run with:

    ./run-tests-gpu.sh

Note: this will run using slurm on the `gpu` partition.  Also for now the compute nodes don't have Internet access so you need to first run it on the login node to download all the models and data (`./run-tests.sh`).

By default the tests are run for the default version of each of the modules.  If you want to run the test only for a specific module or version you can do like this:

    PACKAGES=pytorch/1.3.0 ./run-tests-gpu.sh

## Singularity

In addition to conda-installations one can also use singularity images, which can be created from Docker images, see [notes on conversion and running existing containers](https://docs.csc.fi/computing/containers/run-existing/).

Images are placed in `/appl/soft/ai/singularity/images/`, and each image should have a corresponding module file in `/appl/soft/ai/singularity/modulefiles/`.

Usage:

    module use /appl/soft/ai/singularity/modulefiles/
    module avail  # to see existing images
    module load nvidia-pytorch/19.11-py3

Testing by starting a Python interpreter inside the container:

    srun -A project_2001659 -n 1 -c 10 -p gputest --gres=gpu:v100:1 -t 15 --mem=64G --pty singularity_wrapper run python3
