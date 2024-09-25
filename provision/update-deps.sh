#!/bin/bash

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate provision

# pip install "cython<3.0.0" # TODO upgrade to cython 3
# pip install "pyyaml==5.4.1" --no-build-isolation # TODO upgrade pyyaml
# pip install wheel
pip install --upgrade pip setuptools wheel pip-tools

pip-compile "./requirements.in" --resolver=backtracking
# pip-compile "./requirements-dev.in" --resolver=backtracking
pip-sync "./requirements.txt" # "./requirements-dev.txt"
