#!/bin/bash
srun -A project_2001659 --partition=gputest --time=10 --gres=gpu:v100:1 --mem=8G ./run-tests.sh
