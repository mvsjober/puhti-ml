### PyTorch

Includes [PyTorch](https://pytorch.org/) and related packages.

Version numbering is based on the PyTorch version.

#### 1.3.0

Created as:

    conda env create -f conda-envs/pytorch/1.3.0.yaml

In case a conda or pip package needs to be added later, add it to the yaml file, and run:

    conda env update -f conda-envs/pytorch/1.3.0.yaml

Apex still needs to be installed manually (conda-forge has nvidia-apex, but only for Python 3.6...):

    conda activate pytorch-1.3.0-1
    module load gcc/8.3.0
    export CUDA_HOME=/appl/spack/install-tree/gcc-8.3.0/cuda-10.1.168-mrdepn/
    git clone https://github.com/NVIDIA/apex
    cd apex
    rm -rf .git
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./

Torchaudio in conda seems to be broken (maybe not compiled yet for pytorch 1.3.0 as of 16.10.2019), hence manual install was needed:

    conda activate pytorch-1.3.0-1
    module load gcc/8.3.0
    export CUDA_HOME=/appl/spack/install-tree/gcc-8.3.0/cuda-10.1.168-mrdepn/
    git clone https://github.com/pytorch/audio torchaudio
    cd torchaudio
    rm -rf .git
    pip install -v --no-cache-dir --global-option=build_ext --global-option="-I/projappl/project_2001659/mvsjober/sox/src/" .

Finally, for some reason I had to reinstall `regex` (`_regex.cpython-37m-x86_64-linux-gnu.so: undefined symbol: _intel_fast_memcpy
`):

    pip install --force-reinstall --no-cache-dir regex

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
