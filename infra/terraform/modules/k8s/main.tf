resource "yandex_kubernetes_cluster" "cluster" {
  name       = "homework-k8s"
  network_id = var.network_id

  master {
    version = "1.31"
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }
    public_ip = true
  }

  service_account_id      = var.cluster_agent_sa_id
  node_service_account_id = var.image_puller_sa_id
  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "workload_nodes" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = "workload-pool"
  version    = "1.31"

  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 16
      cores  = 4
    }

    network_interface {
      subnet_ids = [var.subnet_id]
      nat        = true
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  labels = {
    "node-role" = "workload"
  }

  node_labels = {
    "role" = "workload"
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }
}

resource "yandex_kubernetes_node_group" "infra_nodes" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = "infra-pool"
  version    = "1.31"

  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 16
      cores  = 4
    }

    network_interface {
      subnet_ids = [var.subnet_id]
      nat        = true
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  labels = {
    "node-role" = "infra"
  }

  node_labels = {
    "role" = "infra"
  }

  node_taints = [
    "node-role=infra:NoSchedule"
  ]

  allocation_policy {
    location {
      zone = var.zone
    }
  }
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}