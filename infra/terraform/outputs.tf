output "k8s_cluster_id" {
  value = module.k8s.cluster_id
}

output "loki_secret_key" {
  value     = module.storage.loki_secret_key
  sensitive = true
}