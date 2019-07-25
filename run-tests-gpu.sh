#!/bin/bash
srun -A project_2001659 --partition gpu --time=5 --gres=gpu:v100:1 --mem=2G ./run-tests.sh
