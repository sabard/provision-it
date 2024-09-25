#!/bin/bash

# install pyenv
curl https://pyenv.run | bash

# install python using pyenv, create a virtualenv, and install python deps
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -s 3.10.14
pyenv uninstall -f provision
pyenv virtualenv -f 3.10.14 provision
"$(dirname "$0")/update-deps.sh"

# download cloud-sql-proxy executable
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.2.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy

# gcloud auth configure-docker us-west1-docker.pkg.dev
# gcloud auth application-default login

