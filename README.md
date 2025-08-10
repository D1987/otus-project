# SA
Run once manually to create sa for terraform
./scripts/prepare.sh

# !!!
An error Permission denied appears only for the first run `terraform apply`
It need set timeout.

Check it before terraform apply.
A reason k8s creation failed - Permission denied can be changed CLOUD_ID in prepare.sh.
OR
need to regenerate sa-homework id

# terraform (14 resources)
terraform fmt
terraform validate
terraform plan
terraform apply

# k8s get creds
yc managed-kubernetes cluster get-credentials homework-k8s --external

# Get SA Ingress key
./scripts/sa-ingress-key.sh

# Install Ingress
./scripts/install.sh

# GET S3 Keys
./scripts/s3-secrets.sh

# Kill terraform process
ps aux | grep terraform
kill -9 <PID-ID>

# Cleaning
After terraform destroy delete homework/yc from .kube/congfig