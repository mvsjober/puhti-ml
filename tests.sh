#!/bin/bash

module use modulefiles

PACKAGES="python-data
          pytorch"

for PKG in $PACKAGES
do
    module purge
    module load $PKG

    SCRIPT="${PKG/-/_}.py"
    echo "Running tests for $PKG"
    echo
    python3 -m unittest -v tests/$SCRIPT
    echo "==="
done
