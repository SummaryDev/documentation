#!/usr/bin/env bash

export namespace=${namespace-dev}

env | grep 'namespace\|sha_short\|domain'

export copyright="$namespace $sha_short"
export src_dir="site"
export dest_pod="data-nginx"
export dest_dir="/data/docs"

mkdocs build

echo "built to local folder $src_dir"

kubectl exec --namespace $namespace -it $dest_pod -- rm -rf $dest_pod

echo "deleted $dest_dir on pod $dest_pod"

kubectl cp --namespace $namespace $src_dir $dest_pod:$dest_dir

echo "copied $src_dir to $dest_pod:$dest_dir"

kubectl exec --namespace $namespace -it $dest_pod -- ls -la $dest_dir

echo "https://$subdomain$domain/docs"