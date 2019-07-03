# Installation files for Puhti ML environment

Scripts to install Python packages for CSC's Puhti machine learning environment using [pip](https://pip.pypa.io/en/stable/), and related module configuration files.

## Usage

```sh
git clone https://github.com/CSCfi/puhti-ml.git

module purge
module use puhti-ml/modulefiles
module load python-data/3.6.7-1   # just to get the right Python interpreter
```

Set `TARGET` directory to where you want the Python files installed in `install.sh`, the default is `${WRKDIR}/appl/opt`.

Next, install what you need in the right order (first python-data, etc.).  The command will show what it will do, you need to confirm with pressing Return, or Ctrl-C to abort.

```sh
./install.sh python-data/3.6.7-1.txt
./install.sh pytorch/1.1.0.txt
./install.sh tensorflow/1.13.1.txt
```

You can also just run the `install-all.sh` script, which should have them all in the right order.

Now you should be able to take the modules into use, e.g.:

```sh
module use puhti-ml/modulefiles
module load tensorflow/1.13.1
```

There are also some tests that you can run with:

```sh
./tests.sh
```


## Current modules

### python-data

Includes common machine learning and data analytics packages for Python such as [SciPy](https://www.scipy.org/), [NumPy](http://www.numpy.org/), [pandas](https://pandas.pydata.org/) and [scikit-learn](https://scikit-learn.org/stable/). Base module for the other modules.

Version numbering is `x.y.z-n`, where `x.y.z` is the Python version included, and `n` starts from 1.

### pytorch and pytorch-hvd

Includes [PyTorch](https://pytorch.org/) and related packages.  The separate module `pytorch-hvd` is the same but includes [horovod](https://github.com/horovod/horovod) support and OpenMPI.

Version numbering is based on the PyTorch version.


### tensorflow and tensorflow-hvd

Includes [Tensorflow](https://www.tensorflow.org/) and related packages.  The separate module `tensorflow-hvd` is the same but includes [horovod](https://github.com/horovod/horovod) support and OpenMPI.

Version numbering is based on the Tensorflow version.


## Adding new modules

For each new module a Python requirements file needs to be added as `foo/1.2.3.txt`, where `foo` is the name of the software package and `1.2.3` the version number.  Also a Lua-based module file is needed named as `modulefiles/foo/1.2.3.lua`.  See the existing files for examples.

At the end of the installation the script produces a frozen snapshot of exactly what packages were installed as `foo/1.2.3.txt.frozen` in case there is a need to replicate the exact environment later.

Also remember to:

- add your module to the `install-all.sh` script
- add tests as `tests/foo.py` where `foo` is your package name

### Text files

The [Python requirements file format](https://pip.pypa.io/en/stable/reference/pip_install/#requirements-file-format) has many features, we are mainly using three of them as demonstrated in this example:

```
/appl/opt/pytorch/1.1.0/cu100/torch-1.1.0-cp36-cp36m-linux_x86_64.whl
torchvision==0.3.0
torchtext
```

First a specific precompiled wheel-file is specified for the `torch` package.  This needs to be used in case the binaries provided by the [Python Package Index](https://pypi.org/) are not compatible with the environment.

On the second line, we specify that we want a particular version of the package `torchvision`.  Finally, on the third line we specify `torchtext` without an explicit version.  This means that pip will install the newest version available that is compatible with the other requirements.  The `.frozen` file will document the actual versions that were installed, e.g.:

```
torch==1.1.0
torchvision==0.3.0
torchtext==0.3.1
```

The `.frozen` file will also include various dependencies that were automatically included (but not specified explicitly in the original requirements file).

### Module files

The module files are for the [Lmod module system](https://lmod.readthedocs.io/en/latest/index.html), and the [format is documented](https://lmod.readthedocs.io/en/latest/015_writing_modules.html) on the Lmod web site.  Just a few notes:

- It is important to load other modules that are dependencies, e.g., the pytorch module would load the python-data module:

  ```
  load("python-data/3.6.7-1")
  ```

- Remember to add the new files to the Python path, e.g.:

  ```
  prepend_path('PYTHONPATH', '/path/to/appl/opt/pytorch/1.1.0/lib/python3.6/site-packages')
  ```
