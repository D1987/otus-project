#!/bin/sh

set -e

if [ "$1" = "i" ]; then
    # https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml
      helm repo add argo https://argoproj.github.io/argo-helm
      helm upgrade --install argocd argo/argo-cd \
        --namespace argocd \
        --create-namespace
        --values "app/argo/values.yml"
      
elif [ "$1" = "u" ]; then
    helm uninstall argocd -n argo-cd
fi