#!/bin/bash

# module use modulefiles

if [ -z $PACKAGES ]
then
    PACKAGES=$(find modulefiles -name *.lua | cut -d / -f 2- | sed 's/\.lua$//' | grep -v cpu)
fi
REPORT=""

for PKG in $PACKAGES
do
    BASE_PKG=${PKG/\/*/}
    export MOD_VERSION=${PKG/*\//}
    SCRIPT="tests/${BASE_PKG/-/_}.py"
    if [ -f $SCRIPT ]; then
        echo "=== Running tests for ${PKG} ==="
        module purge
        module load $PKG
        module list
        
        if PYTHONWARNINGS="d,i::ImportWarning,i::DeprecationWarning,i::ResourceWarning" python3 -m unittest -v $SCRIPT; then
            STATUS="SUCCESS"
        else
            STATUS="$(tput bold)$(tput setaf 1)FAILURE$(tput sgr0)"
        fi
    else
        echo "=== WARNING: $SCRIPT not found, i.e., there are no tests for $PKG ==="
        STATUS="NO TESTS"

    fi
    REPORT="${REPORT}\n$PKG [$SCRIPT]: $STATUS"
    echo
done

echo "=== TESTING SUMMARY ==="
echo -e $REPORT
