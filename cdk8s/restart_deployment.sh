#!/bin/bash

kubectl delete pod `kubectl get pods --field-selector=status.phase==Running | tail -n 1 | awk '{print $1}'`
# kubectl rollout restart deployment $(kubectl get deployment | tail -n 1 | awk '{print $1}')

"$(dirname "$0")/update-dns.sh"
