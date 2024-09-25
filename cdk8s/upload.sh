#!/bin/bash
set -e

export PROVISION_IMAGE_HASH=$1

pushd "$(dirname "$0")"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate provision-cdk8s

# creates kubernetes config file from cdk8s python app
cdk8s synth

kubectl delete secret provision-db --ignore-not-found
kubectl create secret generic provision-db \
    --from-literal=PROVISION_DATABASE_URI=$PROVISION_DATABASE_URI
kubectl delete secret provision-creds --ignore-not-found
kubectl create secret generic provision-creds \
    --from-file=GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS

# applies kubernetes config file to the cluster
kubectl apply -f dist/provision.k8s.yaml

popd

"$(dirname "$0")/update-dns.sh"
