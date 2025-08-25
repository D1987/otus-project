resource "yandex_vpc_subnet" "subnet" {
  name           = var.name
  description    = var.name
  v4_cidr_blocks = ["10.2.0.0/22"]
  zone           = var.zone
  network_id     = var.network_id
}

output "subnet_id" {
  value = yandex_vpc_subnet.subnet.id
}