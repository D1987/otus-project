#!/bin/bash

terraform state show module.storage.yandex_iam_service_account_static_access_key.loki_s3_keys
terraform output -raw loki_secret_key

#  Значения для secretAccessKey и accessKeyId добавить в logging/values-loki.yml
