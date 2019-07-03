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

Now you should be able to take the modules into use, e.g.:

    module load tensorflow/1.13.1

## Notes

For each new module a Python requirements file needs to be added as `foo/1.2.3.txt`, where `foo` is the name of the software package and `1.2.3` the version number.  Also a Lua-based modulefile is needed named as `modulefiles/foo/1.2.3.lua`.  See the existing files for examples.

At the end of the installation the script produces a frozen snapshot of exactly what packages were installed as `foo/1.2.3.txt.frozen` in case there is later a need to replicate the exact environment.

### Text files

The [Python requirements file format](https://pip.pypa.io/en/stable/reference/pip_install/#requirements-file-format) has many features, we are mainly using three of them as demonstrated in this example:

    /appl/opt/pytorch/1.1.0/cu100/torch-1.1.0-cp36-cp36m-linux_x86_64.whl
    torchvision==0.3.0
    torchtext

First a specific precompiled wheel-file is specified for the torch package.  This needs to be used in case the binaries provided by the [Python Package Index](https://pypi.org/) are not compatible with the environment.

On the second line, we specify that we want a particular version of the package `torchvision`.  Finally, on the third line we specify we want whatever is the newest version of `torchtext` that is compatible with the other requirements.  The `.frozen` file will document the actual version that were installed, e.g.:

    torch==1.1.0
    torchvision==0.3.0
    torchtext==0.3.1

The `.frozen` file will also include various dependencies that were automatically included (but not specified in the original requirements file).

### Module files

The modulefiles are for the [Lmod module system](https://lmod.readthedocs.io/en/latest/index.html), and the [format is documented](https://lmod.readthedocs.io/en/latest/015_writing_modules.html) on the Lmod web site.  Just a few notes:

- It is important to load other modules that are dependencies, e.g., the pytorch module would load the python-data module:

      load("python-data/3.6.7-1")

- Remember to add the new files to the Python path, e.g.:

      prepend_path('PYTHONPATH', '/path/to/appl/opt/pytorch/1.1.0/lib/python3.6/site-packages')
