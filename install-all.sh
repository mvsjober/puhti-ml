#!/bin/bash

PACKAGES="python-data/3.6.7-1
          pytorch/1.1.0
          pytorch-hvd/1.1.0
          tensorflow/1.13.1
          tensorflow-hvd/1.13.1"

for PKG in $PACKAGES
do
    ./install.sh ${PKG}.txt
done
