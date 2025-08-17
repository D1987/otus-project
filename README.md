В качесте облачного решения используется Яндекс облако

В качестве микросервисного приложения используется Online Boutique (https://github.com/GoogleCloudPlatform/microservices-demo)

Проект состоит из двух основных директорий:
- app
- infra
 
app - состоит содержит:
    app - основное приложение Online Boutique
    scripts - установка установка дополнительных приложений с помощью helm
    cert-manager - менеджер сертификатов
    ingress - ингресс
    monitoring - прометеус
    logging - графана + локи

infra - содержит terraform сетап на основе модулей для разворачивания инфраструктуры:
    МОДУЛИ
    iam - сервис аккаунты
    network - сеть
    storage - сторедж
    k8s - кластер

    СКРИПТЫ
    prepare.sh - создание первоначально сервис аккаунта в яндекс облаке для работы терраформ. Запускатеся единожды в самом начале.
    get-s3-secrets.sh - получение S3 данных для использования в приложениях

# terraform (15 resources)
terraform fmt
terraform validate
terraform plan
terraform apply

# k8s get creds
yc managed-kubernetes cluster get-credentials homework-k8s --external

# Сетап github репозитория (https://github.com/D1987/otus-project)
Создание токена для авторизации в k8s яндекс из гитхаб репозитория
```
    TOKEN=$(yc iam create-token)
    cat ~/.kube/config | base64 -w0
    сохранить в гитхаб конфиг куба KUBE_CONFIG_DATA
````

# Get SA Ingress key
./scripts/sa-ingress-key.sh

# Install Ingress
./scripts/install.sh

# Cleaning
After terraform destroy delete homework/yc from .kube/congfig


Приложение доступно по адрессу
158.160.187.124.sslip.io
Используется сервис sslip.io
