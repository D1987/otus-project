module "network" {
  source     = "./modules/network"
  name       = "sub-homework"
  zone       = var.zone
  network_id = var.network_id
}

module "iam" {
  source    = "./modules/iam"
  folder_id = var.folder_id
}

module "k8s" {
  source              = "./modules/k8s"
  network_id          = var.network_id
  zone                = var.zone
  subnet_id           = module.network.subnet_id
  cluster_agent_sa_id = module.iam.k8s_cluster_agent_id
  image_puller_sa_id  = module.iam.image_puller_id
  
  depends_on = [
    module.network,
    module.iam
  ]
}

module "storage" {
  source    = "./modules/storage"
  folder_id = var.folder_id
}