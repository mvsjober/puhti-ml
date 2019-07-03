#!/bin/bash

PIP=pip3
# TARGET=~/appl
TARGET=${WRKDIR}/appl/opt


REQFN=$1
if [ -z "$REQFN" ]; then
    echo "Usage: $0 REQFN"
    echo "Example: $0 pkg/1.2.3.txt"
    echo "where pkg/1.2.3.txt is the requirements.txt file for installing package pkg/1.2.3"
    exit 1
fi

PKG=${REQFN/.txt/}
FROZEN="${REQFN}.frozen"

PREFIX="$TARGET/$PKG"
if [ -d "$PREFIX" ]; then
    echo "WARNING: $PREFIX directory already exists"
fi

echo "Install packages:"
sed -e 's/^/  /' $REQFN
echo "to installation prefix: $PREFIX"
read -p "OK? [Return = OK, Ctrl-C = abort] "

set -o xtrace

mkdir -p $PREFIX

PYTHONUSERBASE=$PREFIX $PIP install --no-warn-script-location --user -r $REQFN
PYTHONPATH=${PREFIX}/lib64/python3.6/site-packages:${PREFIX}/lib/python3.6/site-packages \
          $PIP freeze -r $REQFN > $FROZEN
