#!/bin/bash

yc managed-kubernetes cluster get-credentials homework-k8s --external
TOKEN=$(yc iam create-token)  ??????????
cat ~/.kube/config | base64 -w0
