# Installation files for Puhti ML environment

## Usage

    git clone https://github.com/mvsjober/puhti-ml.git
    
    module purge
    module use puhti-ml/modulefiles
    module load python-data/3.6.7-1   # just to get the right Python interpreter

Set `TARGET` dir correctly in `install.sh`, default is `${WRKDIR}/appl/opt`.

Next, install what you need in the right order (first python-data, etc).  The command will show what it will do, you need to confirm with pressing Return, or Ctrl-C to abort.

    ./install.sh python-data/3.6.7-1.txt
    ./install.sh pytorch/1.1.0.txt
    ./install.sh tensorflow/1.13.1.txt

