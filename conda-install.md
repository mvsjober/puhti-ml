# Activate Sami's miniconda
  
    eval "$(/appl/soft/ai/miniconda3/bin/conda shell.bash hook)"

# Useful commands

List current envs

    conda info --envs

Remove environment

    conda env remove --name foo-1.2.3
    

# Create python-data

    # conda create --name python-data-3.7.3-1 scikit-learn jupyterlab pandas tqdm seaborn requests pillow h5py graphviz matplotlib
    
    conda env create -f python-data/3.7.3-1.yaml

# Create pytorch

    # conda create --name pytorch-1.1.0 pytorch==1.1.0 torchvision==0.2.2 cudatoolkit -c pytorch

    conda create --name pytorch-1.1.0 --clone python-data-3.7.3-1

    conda activate pytorch-1.1.0
    conda install pytorch==1.1.0 torchvision==0.2.2 cudatoolkit -c pytorch

# Create tensorflow

    conda create --name tensorflow-1.14.0 --clone python-data-3.7.3-1
    
    conda activate tensorflow-1.14.0
    conda install tensorflow-gpu==1.14.0 keras
