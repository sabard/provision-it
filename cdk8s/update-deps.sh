#!/bin/bash

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate provision-cdk8s

pip install --upgrade pip setuptools wheel pip-tools

pip-compile "./requirements.in" --resolver=backtracking
pip-sync "./requirements.txt"
