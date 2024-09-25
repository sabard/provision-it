#!/bin/bash

GCLOUD_K8S_CONTEXT=provision

sudo apt update

# install pyenv
curl https://pyenv.run | bash

# install python using pyenv, create a virtualenv, and install python deps
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -s 3.8.12
pyenv uninstall -f provision-cdk8s
pyenv virtualenv -f 3.8.12 provision-cdk8s
"$(dirname "$0")/update-deps.sh"

# install kubectl
sudo apt-get install -y ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get install -y kubectl

# install nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install 18
nvm use 18
npm install -g cdk8s-cli

# use kubectl with gcloud
gcloud components install kubectl
gcloud components install gke-gcloud-auth-plugin
gcloud container clusters create provision
gcloud container clusters get-credentials provision --region=us-west1-b
# gcloud auth configure-docker us-west1-docker.pkg.dev
# gcloud auth application-default login
