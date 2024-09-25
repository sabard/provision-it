#!/bin/bash

# create gcp artifact registry repository if not exists
REPOS=`gcloud artifacts repositories list | sed -e '1,2d' | awk '{print $1}'`
CREATE=1
for REPO in $REPOS
do
    if [[ "$REPO" == "provision" ]]; then
        CREATE=0
        break
    fi
done
if [[ $CREATE -eq "1" ]]; then
    gcloud artifacts repositories create provision \
        --repository-format=docker \
        --location=us-west1 \
        --description="LiCoRICE Netboot"
fi

# build and tag project
docker build --no-cache -t us-west1-docker.pkg.dev/soe-licorice/provision/provision $(dirname "$0")

IMAGE=us-west1-docker.pkg.dev/soe-licorice/provision/provision

# upload to registry
docker push $IMAGE

export PROVISION_IMAGE_HASH=`docker images --no-trunc --quiet $IMAGE | head -n 1`
echo $PROVISION_IMAGE_HASH
