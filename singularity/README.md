# Preparing and using Singularity images based on NVIDIA docker containers

First, the Singulary image can be created in two ways: 

- directly converting the NVIDIA image without making any changes, or 
- building customized image using the NVIDIA image as a base

Here, we assume the building commands are run on your own computer or virtual server, as some commands might require sudo.

## Convert image from Docker

    singularity build pytorch_20.03-py3.sif docker://nvcr.io/nvidia/pytorch:20.03-py3

## Build customized image

Alternatively, a customized image can be built. First you need to create a definition file, and then simply build:

    sudo singularity build pytorch_20.03-py3-csc.sif pytorch_20.03-py3-csc.def

However, unless the commands are trivial, it usually makes sense to first experiment in a sandbox to find out the right commands for the definition file.

### Try installation commands in sandbox

Create a sandbox where to test commands:

    singularity build --sandbox pytorch_20.03-py3 docker://nvcr.io/nvidia/pytorch:20.03-py3

Run inside sandbox (`sudo` needed if you want to install with `apt`):

    sudo singularity shell --writable pytorch_20.03-py3
    
In the sandbox you can experiment with `pip install` and adding necessary requirements with `apt install`.  NOTE: you need to run `apt-get update` first to get the package list for `apt`.

Once you know the right installation commands add them to the definition file and build the final image (see above).

## Install packages "on-the-fly" on Puhti

    ssh puhti-login3
    SLURM_JOBID=X SING_IMAGE=/appl/soft/ai/singularity/images/tensorflow_20.03-tf2-py3-csc.simg SING_FLAGS="--nv -B /appl/soft/ai/singularity/python-packages/:/appl/soft/ai/singularity/python-packages/" singularity_wrapper exec bash
    export PYTHONUSERBASE=/appl/soft/ai/singularity/python-packages/nvidia-20.03-tf2-py3-csc 
    pip install --user transformers
    python3 -c "import transformers; print(transformers.__path__)"


## Install user packages

    module load pytorch/nvidia-20.03-py3
    singularity_wrapper exec pip install --user tensorboardX
