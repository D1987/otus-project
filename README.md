Данный проект предназначен для развертывания микросервисного приложения.

В качесте облачного решения используется Яндекс облако (YC)

В качестве микросервисного приложения используется Online Boutique (https://github.com/GoogleCloudPlatform/microservices-demo)

В качесте дополнительных сервисов платформы используются подсеть, сервис аккаунты, хранилище S3.

Настроен мониторинг и логирование кластера и приложения. Также добавлены алерты.

Для развертывания инфраструктуры используется terraform.

Для деплоя приложения используется Github Actions.

Проект состоит из трех основных директорий:
- .github
- app
- infra
 
.github - содержит:
    Файл для автоматизированного деплоя приложения workflows/deploy.yml

app - содержит:
    app - основное приложение Online Boutique
    scripts - установка установка дополнительных приложений с помощью helm
    cert-manager - менеджер сертификатов
    ingress - ингресс
    loki-stack - локи стек

infra - содержит terraform сетап на основе модулей для разворачивания инфраструктуры:
    МОДУЛИ
    iam - сервис аккаунты
    network - сеть
    storage - сторедж
    k8s - кластер

    СКРИПТЫ
    prepare.sh - создание первоначально сервис аккаунта в яндекс облаке для работы терраформ. Запускатеся единожды в самом начале.
    get-s3-secrets.sh - получение S3 данных для использования в приложениях

## Развертывание инфраструктуры и сервисов платформы

# 1. Подготовить локальное окружение для работы с YC
cd infra/scripts
Заполнить раздел '### Вводные данные в файле prepare.sh'
./prepare.sh

# 2. Развернуть инфраструктуру
cd ../terraform
На основе файла template.tfvars создать файл terraform.tfvars с необходимыми переменными для доступа к YC.
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply

# 3. Убедится что кластер доступен и работает
kubectl get no -o wide

# 4. Получить секреты для доступа в S3
../scripts/get-s3-secrets.sh

# Сохранить в гитхаб секреты
access_key
secret_access_key

## Развертывание приложения в кластере

# 1. Подготовить токен для деплоя в куб с помощью github actions
    ```

script make copy config


    yc managed-kubernetes cluster get-credentials homework-k8s --external

        TOKEN=$(yc iam create-token)  ??????????
        cat ~/.kube/config | base64 -w0
    ````

# 2. Cохранить токен в github секретах 'KUBE_CONFIG_DATA'

# CICD Поставить арго
Запускаем арго в github CICD
port-forward


 Развернуть infra app > github actions

 Сохранить ингресс ip в гитхаб секрет

 Графана contact point

 Развернуть приложение


# 3. Cделать пуш в github. Создать Pull Request в Main ветку. Это запустит автоматически деплой приложения в кластер.

После деплоя, приложение будет доступно по адрессу https://158.160.187.124.sslip.io
Используется сервис sslip.io


##################################

IP в ингрес и серт менеджер
поменять урл серт менеджера


# Get SA Ingress key
./scripts/sa-ingress-key.sh

# Cleaning
After terraform destroy delete homework/yc from .kube/congfig

kubectl patch application loki-stack -n argocd \
  -p '{"metadata":{"finalizers":[]}}' --type=merge