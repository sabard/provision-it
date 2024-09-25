#!/bin/bash

# TODO error handling?

"$(dirname "$0")/autoinstall/upload.sh"
PROVISION_IMAGE_HASH=$("$(dirname "$0")/provision/upload.sh" | tail -n 1)
"$(dirname "$0")/cdk8s/upload.sh" $PROVISION_IMAGE_HASH
"$(dirname "$0")/salt/upload.sh"
