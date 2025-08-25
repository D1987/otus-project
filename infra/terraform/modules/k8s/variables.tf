variable "network_id" {
  type        = string
  description = "Network ID"
}

variable "zone" {
  type        = string
  description = "Availability zone"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "cluster_agent_sa_id" {
  type        = string
  description = "Cluster service account ID"
}

variable "image_puller_sa_id" {
  type        = string
  description = "Image puller service account ID"
}