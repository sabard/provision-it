#!/bin/bash

gsutil -m -h "Cache-Control:public, max-age=300" rsync -r -d -x "upload.sh|.gitignore|.*\.DS\_Store$|.*RSYNC_IGNORE.*" "$(dirname "$0")/../autoinstall" gs://licorice/autoinstall && gsutil -m acl ch -r -u AllUsers:R gs://licorice/autoinstall
