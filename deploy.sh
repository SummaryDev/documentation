#!/usr/bin/env bash

env | grep 'namespace\|sha_short'

export namespace=${namespace}

export copyright="© 2022 Summary Developers</br>$namespace $sha_short"

mkdocs build

kubectl exec --namespace $namespace -it data-nginx -- rm -rf data/docs && \
kubectl cp --namespace $namespace site data-nginx:/data/docs

kubectl exec --namespace $namespace -it data-nginx -- ls -la data/docs

echo "https://$namespace.summary.dev/docs"