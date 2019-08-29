#!/bin/bash

TO_INSTALL={python-data,pytorch,tensorflow,mxnet}
TARGET_DIR=/appl/modulefiles

INSTALL_FROM=$(eval echo modulefiles/$TO_INSTALL)
INSTALL_TO=$(eval echo $TARGET_DIR/${TO_INSTALL}/*)

set -x

rsync -rv -p --chmod=g+w -g --groupmap='*:p_installation' $INSTALL_FROM $TARGET_DIR

ls -l $INSTALL_TO
