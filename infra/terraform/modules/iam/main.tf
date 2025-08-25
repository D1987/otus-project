resource "yandex_iam_service_account" "k8s_cluster_agent" {
  name        = "sa-k8s-cluster-agent"
  description = "Сервисный аккаунт для управления кластером Kubernetes"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_agent_role" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster_agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_vpc_admin_role" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster_agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_lb_admin_role" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster_agent.id}"
}

resource "yandex_iam_service_account" "image_puller" {
  name        = "sa-k8s-image-puller"
  description = "Сервисный аккаунт для pull Docker-образов"
}

resource "yandex_resourcemanager_folder_iam_member" "image_puller_role" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.image_puller.id}"
}

output "k8s_cluster_agent_id" {
  value = yandex_iam_service_account.k8s_cluster_agent.id
}

output "image_puller_id" {
  value = yandex_iam_service_account.image_puller.id
}