#!/bin/bash

PORT=5000
AUTH_PORT=5001

case $OSTYPE in
    linux*)
        CLOUD_SQL_PROXY_BIN=./cloud-sql-proxy
    ;;
    darwin*)
        CLOUD_SQL_PROXY_BIN=./cloud-sql-proxy-mac
    ;;
esac

if [ "$1" == "--docker" ]; then
    docker build -t provision .
    docker run \
        -p $PORT:5000 \
        -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/keys/gcloud_creds.json \
        -v $GOOGLE_APPLICATION_CREDENTIALS:/tmp/keys/gcloud_creds.json:ro \
        -e PROVISION_DATABASE_URI=$PROVISION_DATABASE_URI \
        provision
else
    export PROVISION_DATABASE_URI="${PROVISION_DATABASE_URI:-sqlite:///provision/database.db}"
    $CLOUD_SQL_PROXY_BIN soe-licorice:us-central1:provision-test -p $AUTH_PORT &
    uvicorn provision.app:app --port $PORT $@
fi
