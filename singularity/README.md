# Creating singularity images based on NVIDIA docker images

## Try installation commands in sandbox

Create a sandbox where to test commands:

    singularity build --sandbox sandbox/ docker://nvcr.io/nvidia/tensorflow:20.03-tf2-py3

Run inside sandbox (`sudo` needed if you want to install with `apt`):

    sudo singularity shell --writable sandbox/
    
In the sandbox you can experiment with `pip install` and adding necessary requirements with `apt install`.  NOTE: you need to run `apt-get update` first to get the package list for `apt`.

Once you know the right installation commands add them to the definition file (e.g., `nvidia-tensorflow-csc.def`).

## Build continer when definition file is ready

    sudo singularity build tensorflow_20.03-tf2-py3-csc.sif nvidia-tensorflow-csc.def

## Install packages "on-the-fly" on Puhti

    ssh puhti-login3
    SLURM_JOBID=X SING_IMAGE=/appl/soft/ai/singularity/images/tensorflow_20.03-tf2-py3-csc.simg SING_FLAGS="--nv -B /appl/soft/ai/singularity/python-packages/:/appl/soft/ai/singularity/python-packages/" singularity_wrapper exec bash
    export PYTHONUSERBASE=/appl/soft/ai/singularity/python-packages/nvidia-20.03-tf2-py3-csc 
    pip install --user transformers
    python3 -c "import transformers; print(transformers.__path__)"


