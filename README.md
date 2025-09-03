# Otus-Project

Данный проект предназначен для развертывания микросервисного приложения.

В качесте облачного решения используется Яндекс облако (YC)

В качестве микросервисного приложения используется Online Boutique (https://github.com/GoogleCloudPlatform/microservices-demo)

В качесте дополнительных сервисов платформы используются подсеть, сервис аккаунты, хранилище S3.

Настроен мониторинг и логирование кластера и приложения. Также добавлены алерты.

Для развертывания инфраструктуры используется terraform.

Для деплоя приложений платформы и самого микросервисного приложения используются Github Actions.

Проект состоит из трех основных директорий:
- .github
- app
- infra
 
## .github - содержит:
    workflows/deploy.yml - файл для автоматизированного деплоя приложения 

## app - содержит:
    - app
        - web - директория содержит манифест основного приложения Online Boutique
        - манифесты неймспейса, ингресса, серт менеджера
    - argocd - директория содержит манифесты создание проектов и приложений в арго
    - helm-apps - содержит необходимые файлы для устанвки приложения платформы с помощью helm + github actions
        - argocd - директория содержит values для установки арго
        - cert-manager - директория содержит values для установки серт менеджера
        - ingress-nginx - директория содержит values для установки ингресс
        - loki-stack - директория содержит values для установки локи стека

## infra - содержит terraform сетап на основе модулей для разворачивания инфраструктуры:
    - scripts - содержит 3 скрипта:
        - prepare.sh - первоначальная подготовка сервис аккаунта и установка необходимых инструметов. Запускается один раз вначале
        - get-s3-secrets.sh - получение секрет и аксес ключа для яндекс s3 хранилища. Запускается после развертывания s3
        - get-k8s-token.sh - получение токена для того чтобы можно было деплоить в куб из Github Actions
    - terraform - содержит файлы установки на основе модулей инфраструктуры в яндекс облаке:
        iam - сервис аккаунты
        network - сеть
        storage - сторедж
        k8s - кластер

# Развертывание инфраструктуры и сервисов платформы (локально без CICD)

## 1. Подготовить локальное окружение для работы с YC

Заполнить раздел '### Вводные данные', в файле `infra/scripts/prepare.sh`

`./infra/scripts./prepare.sh`

## 2. Развернуть инфраструктуру

`cd ../terraform`

На основе файла template.tfvars создать файл terraform.tfvars с необходимыми переменными для доступа к YC.

`terraform fmt`

`terraform init`

`terraform validate`

`terraform plan`

`terraform apply`

## 3. Убедится что кластер доступен и работает
`kubectl get no -o wide`

## 4. Получить секреты для доступа в S3 из локи
`../scripts/get-s3-secrets.sh`

## 5. Сохранить секреты в гитхаб секреты (https://github.com/D1987/otus-project/settings/secrets/actions)

- `ACCESS_KEY_ID`
- `SECRET_ACCESS_KEY`

# Развертывание приложений в кластере  (https://github.com/D1987/otus-project/actions/workflows/deploy.yml)

## 1. Подготовить токен для деплоя в куб с помощью github actions
`../scripts/get-k8s-token.sh`

## 1.1 Cохранить токен в гитхаб секретах (https://github.com/D1987/otus-project/settings/secrets/actions)
- `KUBE_CONFIG_DATA`

## 3. Установить арго

Запустить стейдж `argo` в Run workflow

## 3.1 Получить пароль admin юзера

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

## 4. Установить серт менеджер и ингресс

Запустить стейдж `infra` в Run workflow

## 4.1 Сохранить ингресс ip в гитхаб секреты (https://github.com/D1987/otus-project/settings/secrets/actions)

Получить IP

`kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`

Сохранить IP

- `INGRESS_IP`

## 5. Установить локи стек

## 5.1. Установить 2 переменные (https://github.com/D1987/otus-project/settings/secrets/actions)

- EMAIL_21_VEK - куда отправлять графана алерт

- EMAIL_GMAIL - кто будет отправлять

Запустить стейдж `loki` в Run workflow

## 5.2. Получить графана admin пароль

`kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

## 6. Развернуть само приложение

Запустить стейдж `app` в Run workflow

## После деплоя, приложения будут доступно по адрессам (Используется сервис sslip.io)

веб - https://${INGRESS_IP}.sslip.io

арго - https://${INGRESS_IP}.argo.sslip.io

графана - https://${INGRESS_IP}.grafana.sslip.io

# Удаление ресурсов

`terraform destroy`
