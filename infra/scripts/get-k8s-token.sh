#!/bin/bash

yc managed-kubernetes cluster get-credentials homework-k8s --external

TOKEN=$(yc iam create-token)

sed -i '' "/exec:/,/provideClusterInfo: false/c\\
    token: $TOKEN
" ~/.kube/config

cat ~/.kube/config | base64 -w0
