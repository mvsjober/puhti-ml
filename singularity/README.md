# Preparing and using Singularity images based on NVIDIA docker containers

The Singulary image can be created in two ways: 

1. directly converting the NVIDIA image without making any changes, or 
2. building customized image using the NVIDIA image as a base

In case 2, you can install additional software with `apt` directly into the image in the build definition file.

In both cases, additional packages can be installed later "on-the-fly" with `pip` to a container-specific directory on Puhti.

## Convert image from Docker

If you don't need to do any complicated installs you may simply convert the NVIDIA image to Singularity:

    singularity build tensorflow_20.03-tf2-py3.sif docker://nvcr.io/nvidia/tensorflow:20.03-tf2-py3

## Build customized image

Alternatively, a customized image can be built. First you need to create a definition file, and then simply build:

    sudo singularity build pytorch_20.03-py3-csc.sif pytorch_20.03-py3-csc.def
    
NOTE: this has to be done on a separate machine where you have `sudo` access such as a Pouta instance.

NOTE: add `-csc` to the image name to signify that we have made some changes to the image.

However, unless the commands are trivial, it usually makes sense to first experiment in a sandbox to find out the right commands for the definition file.

### Try installation commands in sandbox

Create a sandbox where to test commands:

    singularity build --sandbox pytorch_20.03-py3 docker://nvcr.io/nvidia/pytorch:20.03-py3

Run inside sandbox (`sudo` needed if you want to install with `apt`):

    sudo singularity shell --writable pytorch_20.03-py3
    
In the sandbox you can experiment with `pip install` and adding necessary requirements with `apt install`.  NOTE: you need to run `apt-get update` first to get the package list for `apt`.

Once you know the right installation commands add them to the definition file and build the final image (see above).  It seems that installing things with `pip` in the definition file is a bit tricky if it wants to upgrade things already in the original container, therefore the recommendation would be to just install stuff with `apt` in the definition file, and do `pip` installs later in Puhti as described below.

## Install the new image on Puhti

Images should be copied to `/appl/soft/ai/singularity/images/`, and should have a corresponding module file in `/appl/modulefiles/` (visible to all by default) or `/appl/soft/ai/singularity/modulefiles/` for more specialized software (not visible by default to all).

Take a look at `pytorch/nvidia-20.03-py3.lua` for an example of a module file.  Most importantly it will set `SINGULARITYENV_PYTHONPATH` to point to something like `/appl/soft/ai/singularity/python-packages/pytorch_20.03-py3-csc/lib/python3.6/site-packages`.  This is where we will install additional packages on Puhti with `pip install`.

## Install packages "on-the-fly" on Puhti

First check that you don't have anything in `~/.local/lib/python3.6` which might affect pip installs (e.g., it finds some requirement already there and doesn't install it).

    ssh puhti-login3
    module load pytorch/nvidia-20.03-py3
    export PYTHONUSERBASE=/appl/soft/ai/singularity/python-packages/pytorch_20.03-py3-csc
    
    singularity_wrapper exec pip install --user -r requirements-pytorch_20.03-py3-csc.txt
    singularity_wrapper exec pip install --user transformers
    
    unset PYTHONUSERBASE  # to avoid later unpleasant surprises...
    
NOTE: `PYTHONUSERBASE` should indeed point to `/appl/soft/ai/singularity/python-packages/pytorch_20.03-py3-csc` and not the `lib/python3.6/site-packages` subdirectory!

## Install user packages

If a user wants to install their own packages it can be done as:

    module load pytorch/nvidia-20.03-py3
    singularity_wrapper exec pip install --user tensorboardX
