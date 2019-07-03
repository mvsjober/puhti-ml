#!/bin/bash
module purge
module load python-data

echo "Running tests"
python3 -m unittest -v tests/python_data.py
