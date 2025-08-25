resource "yandex_storage_bucket" "loki_logs" {
  bucket    = "loki-logs-s3-project"
  max_size  = 1073741824
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "loki_sa" {
  name        = "sa-loki-logs"
  description = "Service Account for Loki log storage access"
}

resource "yandex_resourcemanager_folder_iam_member" "loki_storage_access_uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"
  member    = "serviceAccount:${yandex_iam_service_account.loki_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "loki_storage_access_viewer" {
  folder_id = var.folder_id
  role      = "storage.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.loki_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "loki_s3_keys" {
  service_account_id = yandex_iam_service_account.loki_sa.id
  description        = "Static access key for Loki to write logs"
}

output "loki_secret_key" {
  value     = yandex_iam_service_account_static_access_key.loki_s3_keys.secret_key
  sensitive = true
}