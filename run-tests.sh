#!/bin/bash

module use modulefiles

PACKAGES=$(find -name '*.txt' | cut -d / -f 2 | sort -u)
REPORT=""

for PKG in $PACKAGES
do
    SCRIPT="tests/${PKG/-/_}.py"
    if [ -f $SCRIPT ]; then
        echo "=== Running tests for ${PKG} ==="
        echo
        module purge
        module load $PKG

        echo
        if PYTHONWARNINGS="d,i::ImportWarning,i::DeprecationWarning,i::ResourceWarning" python3 -m unittest -f -v $SCRIPT; then
            STATUS="SUCCESS"
        else
            STATUS="FAILURE"
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
