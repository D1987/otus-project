#!/bin/bash

# YC config
set -euo pipefail

### Вводные данные
SA_NAME="sa-homework"
FOLDER_ID=""
CLOUD_ID=""
FOLDER_NAME="default"
PROFILE_NAME="sa-homework-profile"
KEY_FILE="key.json"
ROLE="admin"

### 1. Установка Яндекс CLI
echo "Установка Яндекс CLI"
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | \
    bash -s -- -a

### 2. Первоначальная аутентификация
echo "Требуется вход в Yandex Cloud..."
yc init --cloud-id "$CLOUD_ID" --folder-id "$FOLDER_ID"

### 3. Установка текущего каталога
yc config set folder-id "$FOLDER_ID"

### 4. Создание сервисного аккаунта
echo "Создание сервисного аккаунта: $SA_NAME"
SA_ID=$(yc iam service-account create --name "$SA_NAME" --folder-id "$FOLDER_ID" --format json | jq -r '.id')
echo "ID сервисного аккаунта: $SA_ID"

### 5. Назначение роли сервисному аккаунту
echo "Назначение роли '$ROLE' на каталог $FOLDER_ID"
yc resource-manager folder add-access-binding "$FOLDER_ID" \
  --role "$ROLE" \
  --subject "serviceAccount:$SA_ID"

### 6. Генерация авторизованного ключа
echo "Создание ключа авторизации"
yc iam key create \
  --service-account-id "$SA_ID" \
  --folder-id "$FOLDER_ID" \
  --output "../$KEY_FILE"

### 7. Создание CLI-профиля
echo "Создание профиля CLI: $PROFILE_NAME"
yc config profile create "$PROFILE_NAME"

yc config set service-account-key "../$KEY_FILE"
yc config set cloud-id "$CLOUD_ID"
yc config set folder-id "$FOLDER_ID"

### 8. Экспорт переменных окружения
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

echo "Готово."
echo "YC_TOKEN=$YC_TOKEN"
echo "YC_CLOUD_ID=$YC_CLOUD_ID"
echo "YC_FOLDER_ID=$YC_FOLDER_ID"

### 9. Установка kubectl
echo Установка kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
kubectl version --client