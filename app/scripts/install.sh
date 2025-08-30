#!/bin/sh

set -e

if [ "$1" = "i" ]; then
    # ingress-nginx
    # helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    # helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    #     --namespace ingress-nginx \
    #     --create-namespace \
    #     -f app/ingress/values-ingress-nginx.yml

    # cert-manager
    # https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
    # helm repo add jetstack https://charts.jetstack.io
    # helm upgrade --install cert-manager jetstack/cert-manager \
    #     --namespace cert-manager \
    #     --create-namespace \
    #     --version v1.14.4 \
    #     -f app/cert-manager/values.yml


    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm upgrade --install loki-stack grafana/loki-stack \
        --namespace loki \
        --create-namespace \
        -f app/logging/values-loki-stack.yml

    # prometheus-stack
    # helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    # helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    #     --namespace monitoring \
    #     --create-namespace \
    #     --set grafana.enabled=false \
    #     -f app/monitoring/values.yml

    # Добавляем репозиторий Grafana
    # helm repo add grafana https://grafana.github.io/helm-charts \
    # https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
    # helm upgrade --install grafana grafana/grafana \
    #   --namespace loki \
    #   --namespace loki --create-namespace \
    #   --values app/logging/values-grafana.yml

    # loki
    # https://github.com/grafana/loki/blob/main/production/helm/loki/values.yaml
    # helm upgrade --install loki grafana/loki \
    #   --values app/logging/values-loki.yml
    
    # promtail
    # https://github.com/grafana/helm-charts/blob/main/charts/promtail/values.yaml
    # helm upgrade --install promtail grafana/promtail \
    #   --namespace loki \
    #   --values app/logging/values-promtail.yml

    # argo-cd
    # https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml
      # helm repo add argo https://argoproj.github.io/argo-helm
      # helm upgrade --install argocd argo/argo-cd \
      #   --namespace argo-cd \
      #   --create-namespace
        # --values "app/argo/values.yml"
      
elif [ "$1" = "u" ]; then
    # helm uninstall argocd -n argo-cd
    # helm uninstall ingress-nginx -n ingress-nginx
    # helm uninstall cert-manager -n cert-manager
    # helm uninstall kube-prometheus-stack -n monitoring
    # helm uninstall grafana -n loki
    helm uninstall loki-stack -n loki
    # helm uninstall loki -n loki
    # helm uninstall promtail -n loki
    # helm uninstall jaeger-operator -n observability
    # helm uninstall argocd -n argo-cd
fi