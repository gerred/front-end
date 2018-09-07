#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

mkdir -p ${HOME}/.kube
echo $KUBECONFIG | base64 --decode > ${HOME}/.kube/config

kubectl set image deployments/$REPO *=registry.cloudmule.xyz/$GROUP/$REPO:${COMMIT:0:8} -n sock-shop

function cleanup {
    printf "Cleaning up...\n"
    rm -vf "${HOME}/.kube/config"
    printf "Cleaning done."
}

trap cleanup EXIT