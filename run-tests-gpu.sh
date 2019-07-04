#!/bin/bash

srun --partition gputest --time=5 --gres=gpu:k80:1 --mem=2G ./run-tests.sh
