#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

echo $CA_CRT | base64 --decode > ${HOME}/ca.crt

kubectl config set-cluster our-k8s-cluster --embed-certs=true --server=${CLUSTER_ENDPOINT} --certificate-authority=${HOME}/ca.crt
kubectl config set-credentials travis-echo --token=$SA_TOKEN
kubectl config set-context travis --cluster=$CLUSTER_NAME --user=travis-echo --namespace=echo
kubectl config use-context travis
kubectl config current-context


kubectl set image deployment/$REPO *=registry.cloudmule.xyz/$GROUP/$REPO:${COMMIT:0:8}

function cleanup {
    printf "Cleaning up...\n"
    rm -vf "${HOME}/ca.crt"
    printf "Cleaning done."
}

trap cleanup EXIT