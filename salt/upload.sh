#!/bin/bash

USER=salt
CONTROLLER=${LICO_CONTROLLER:-172.17.3.200}

if [ "$1" == "rebuild" ]; then
    ssh -t $USER@$CONTROLLER 'sudo salt-key -y -d "meadow2.lan"'
fi
rsync -r $(dirname "$0")/state/ $USER@$CONTROLLER:/srv/salt/ --delete
